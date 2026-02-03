import 'package:apphud_helper/apphud_helper.dart';
import 'package:flutter/foundation.dart';
import '../models/mh.idea.dart';
import '../repositories/mh.ideas.repository.dart';
import '../services/mh.ideas.storage.dart';

class MHIdeasProvider extends ChangeNotifier {
  final MHIdeasRepository _repository = MHIdeasRepository();
  final MHIdeasStorage _storage = MHIdeasStorage();

  List<MHIdea> _dailyIdeas = [];
  List<MHIdea> _allIdeas = [];
  List<MHSavedIdea> _savedIdeas = [];
  bool _initialized = false;

  List<MHIdea> get dailyIdeas => _dailyIdeas;
  List<MHIdea> get allIdeas => _allIdeas;
  List<MHSavedIdea> get savedIdeas => _savedIdeas;
  bool get initialized => _initialized;

  int get freeSavedLimit => _storage.freeSavedLimit;

  Future<void> init() async {
    if (_initialized) return;
    await _storage.init();
    _allIdeas = _repository.getAllIdeas();
    _dailyIdeas = _repository.getDailyIdeas(limit: 5);
    _loadSavedIdeas();
    _initialized = true;
    notifyListeners();
  }

  void _loadSavedIdeas() {
    _savedIdeas = _storage.getSavedIdeas();
  }

  MHIdea? getIdeaById(String id) => _repository.getIdeaById(id);

  List<MHIdea> searchIdeas(String query) => _repository.searchIdeas(query);

  List<MHIdea> filterIdeas({
    String? query,
    Set<MHIdeaCategory>? categories,
    Set<MHInvestmentType>? investments,
  }) {
    return _repository.filterIdeas(
      query: query,
      categories: categories,
      investments: investments,
    );
  }

  bool isIdeaSaved(String ideaId) => _storage.isIdeaSaved(ideaId);

  MHSavedIdea? getSavedIdea(String ideaId) => _storage.getSavedIdea(ideaId);

  Future<bool> canSaveIdea() async {
    final dynamic hasPremiumValue = ApphudHelper.service.hasPremium;
    bool premium = false;
    if (hasPremiumValue is Future) {
      final result = await hasPremiumValue;
      premium = result == true;
    } else {
      premium = hasPremiumValue == true;
    }
    return _storage.canSaveMore(premium);
  }

  Future<bool> saveIdea(String ideaId) async {
    final idea = getIdeaById(ideaId);
    if (idea == null) return false;

    final canSave = await canSaveIdea();
    if (!canSave) return false;

    await _storage.saveIdea(ideaId, idea.steps.length);
    _loadSavedIdeas();
    notifyListeners();
    return true;
  }

  Future<void> removeIdea(String ideaId) async {
    await _storage.removeIdea(ideaId);
    _loadSavedIdeas();
    notifyListeners();
  }

  Future<void> startIdea(String ideaId) async {
    if (!isIdeaSaved(ideaId)) {
      final saved = await saveIdea(ideaId);
      if (!saved) return;
    }
    await _storage.updateIdeaStatus(ideaId, MHIdeaStatus.inProgress);
    _loadSavedIdeas();
    notifyListeners();
  }

  Future<void> completeIdea(String ideaId) async {
    await _storage.updateIdeaStatus(ideaId, MHIdeaStatus.completed);
    await _storage.updateProgress(ideaId, 100);
    _loadSavedIdeas();
    notifyListeners();
  }

  Future<void> updateStepProgress(String ideaId, int stepIndex, bool completed) async {
    await _storage.updateStepProgress(ideaId, stepIndex, completed);
    _loadSavedIdeas();
    notifyListeners();
  }

  List<MHSavedIdea> getSavedIdeasByStatus(MHIdeaStatus status) {
    return _savedIdeas.where((e) => e.status == status).toList();
  }

  List<MHIdea> getIdeasForSaved(List<MHSavedIdea> savedList) {
    return savedList
        .map((s) => getIdeaById(s.ideaId))
        .where((e) => e != null)
        .cast<MHIdea>()
        .toList();
  }

  bool shouldShowMotivational() => _storage.shouldShowMotivational();

  Future<void> markMotivationalShown() async {
    await _storage.setLastMotivationalShown(DateTime.now());
  }

  int getSavedCount() => _savedIdeas.length;
}
