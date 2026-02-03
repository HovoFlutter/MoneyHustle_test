import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mh.idea.dart';

class MHIdeasStorage {
  static const _savedIdeasKey = 'mh_saved_ideas';
  static const _lastMotivationalKey = 'mh_last_motivational';
  static const _lastMotivationalIndexKey = 'mh_last_motivational_index';
  static const _freeSavedLimit = 5;

  late SharedPreferences _prefs;
  bool _initialized = false;

  static final MHIdeasStorage _instance = MHIdeasStorage._();
  factory MHIdeasStorage() => _instance;
  MHIdeasStorage._();

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  int get freeSavedLimit => _freeSavedLimit;

  List<MHSavedIdea> getSavedIdeas() {
    final jsonString = _prefs.getString(_savedIdeasKey);
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((e) => MHSavedIdea.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveSavedIdeas(List<MHSavedIdea> ideas) async {
    final jsonString = json.encode(ideas.map((e) => e.toJson()).toList());
    await _prefs.setString(_savedIdeasKey, jsonString);
  }

  Future<bool> saveIdea(String ideaId, int stepsCount) async {
    final ideas = getSavedIdeas();
    if (ideas.any((e) => e.ideaId == ideaId)) return true;

    final newIdea = MHSavedIdea(
      ideaId: ideaId,
      status: MHIdeaStatus.saved,
      progress: 0,
      stepsCompleted: List.filled(stepsCount, false),
      savedAt: DateTime.now(),
    );
    ideas.add(newIdea);
    await _saveSavedIdeas(ideas);
    return true;
  }

  Future<void> removeIdea(String ideaId) async {
    final ideas = getSavedIdeas();
    ideas.removeWhere((e) => e.ideaId == ideaId);
    await _saveSavedIdeas(ideas);
  }

  Future<void> updateIdeaStatus(String ideaId, MHIdeaStatus status) async {
    final ideas = getSavedIdeas();
    final index = ideas.indexWhere((e) => e.ideaId == ideaId);
    if (index == -1) return;

    ideas[index] = ideas[index].copyWith(status: status);
    await _saveSavedIdeas(ideas);
  }

  Future<void> updateStepProgress(String ideaId, int stepIndex, bool completed) async {
    final ideas = getSavedIdeas();
    final index = ideas.indexWhere((e) => e.ideaId == ideaId);
    if (index == -1) return;

    final savedIdea = ideas[index];
    final newSteps = List<bool>.from(savedIdea.stepsCompleted);
    if (stepIndex < newSteps.length) {
      newSteps[stepIndex] = completed;
    }

    final completedCount = newSteps.where((e) => e).length;
    final progress = newSteps.isEmpty ? 0 : (completedCount * 100 ~/ newSteps.length);

    ideas[index] = savedIdea.copyWith(
      stepsCompleted: newSteps,
      progress: progress,
    );
    await _saveSavedIdeas(ideas);
  }

  Future<void> updateProgress(String ideaId, int progress) async {
    final ideas = getSavedIdeas();
    final index = ideas.indexWhere((e) => e.ideaId == ideaId);
    if (index == -1) return;

    ideas[index] = ideas[index].copyWith(progress: progress.clamp(0, 100));
    await _saveSavedIdeas(ideas);
  }

  bool isIdeaSaved(String ideaId) {
    return getSavedIdeas().any((e) => e.ideaId == ideaId);
  }

  MHSavedIdea? getSavedIdea(String ideaId) {
    final ideas = getSavedIdeas();
    try {
      return ideas.firstWhere((e) => e.ideaId == ideaId);
    } catch (_) {
      return null;
    }
  }

  int getSavedCount() => getSavedIdeas().length;

  bool canSaveMore(bool hasPremium) {
    if (hasPremium) return true;
    return getSavedCount() < _freeSavedLimit;
  }

  DateTime? getLastMotivationalShown() {
    final timestamp = _prefs.getInt(_lastMotivationalKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  Future<void> setLastMotivationalShown(DateTime time) async {
    await _prefs.setInt(_lastMotivationalKey, time.millisecondsSinceEpoch);
  }

  bool shouldShowMotivational() {
    final last = getLastMotivationalShown();
    if (last == null) return true;
    return DateTime.now().difference(last).inHours >= 24;
  }

  int getNextMotivationalIndex() {
    final lastIndex = _prefs.getInt(_lastMotivationalIndexKey) ?? -1;
    return (lastIndex + 1) % MHMotivationalMessages.messages.length;
  }

  Future<void> setMotivationalIndex(int index) async {
    await _prefs.setInt(_lastMotivationalIndexKey, index);
  }

  String getTodaysMotivationalMessage() {
    final index = getNextMotivationalIndex();
    return MHMotivationalMessages.messages[index];
  }
}

class MHMotivationalMessages {
  static const List<String> messages = [
    "You don't need a big idea. Just a first step.",
    "Consistency beats motivation.",
    "One small action today can change your income tomorrow.",
    "Every expert was once a beginner.",
    "The best time to start was yesterday. The next best time is now.",
    "Small steps lead to big changes.",
    "Your future self will thank you for starting today.",
  ];
}
