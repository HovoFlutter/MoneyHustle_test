import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:money_hustle/style/mh.color.style.dart';
import 'package:money_hustle/style/mh.text.style.dart';
import 'package:money_hustle/app/data/models/mh.idea.dart';
import 'package:money_hustle/app/data/providers/mh.ideas.provider.dart';
import 'package:money_hustle/app/ui/screens/idea_details/mh.idea_details.page.dart';
import 'package:money_hustle/app/ui/screens/widgets/mh.category_chip.dart';

class MHMyIdeasScreen extends StatefulWidget {
  const MHMyIdeasScreen({super.key});

  @override
  State<MHMyIdeasScreen> createState() => _MHMyIdeasScreenState();
}

class _MHMyIdeasScreenState extends State<MHMyIdeasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MHColorStyles.onbBackground,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: MHColorStyles.white,
            border: null,
            largeTitle: Text('My Ideas', style: MHTextStyles.largeTitleEmphasized),
            heroTag: 'my_ideas_nav',
          ),
          Consumer<MHIdeasProvider>(
            builder: (context, provider, _) {
              final inProgress = provider.getSavedIdeasByStatus(MHIdeaStatus.inProgress);
              final saved = provider.getSavedIdeasByStatus(MHIdeaStatus.saved);
              final completed = provider.getSavedIdeasByStatus(MHIdeaStatus.completed);

              if (inProgress.isEmpty && saved.isEmpty && completed.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.all(16.r),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (inProgress.isNotEmpty) ...[
                      _SectionHeader(title: 'In Progress', count: inProgress.length),
                      SizedBox(height: 8.r),
                      ...inProgress.map((savedIdea) {
                        final idea = provider.getIdeaById(savedIdea.ideaId);
                        if (idea == null) return const SizedBox.shrink();
                        return _SavedIdeaCard(
                          idea: idea,
                          savedIdea: savedIdea,
                          onTap: () => _openDetails(idea.id),
                          onAction: () => _showActions(context, provider, idea, savedIdea),
                        );
                      }),
                      SizedBox(height: 16.r),
                    ],
                    if (saved.isNotEmpty) ...[
                      _SectionHeader(title: 'Saved', count: saved.length),
                      SizedBox(height: 8.r),
                      ...saved.map((savedIdea) {
                        final idea = provider.getIdeaById(savedIdea.ideaId);
                        if (idea == null) return const SizedBox.shrink();
                        return _SavedIdeaCard(
                          idea: idea,
                          savedIdea: savedIdea,
                          onTap: () => _openDetails(idea.id),
                          onAction: () => _showActions(context, provider, idea, savedIdea),
                        );
                      }),
                      SizedBox(height: 16.r),
                    ],
                    if (completed.isNotEmpty) ...[
                      _SectionHeader(title: 'Completed', count: completed.length),
                      SizedBox(height: 8.r),
                      ...completed.map((savedIdea) {
                        final idea = provider.getIdeaById(savedIdea.ideaId);
                        if (idea == null) return const SizedBox.shrink();
                        return _SavedIdeaCard(
                          idea: idea,
                          savedIdea: savedIdea,
                          onTap: () => _openDetails(idea.id),
                          onAction: () => _showActions(context, provider, idea, savedIdea),
                        );
                      }),
                    ],
                    SizedBox(height: 20.r),
                  ]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openDetails(String ideaId) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (_) => MHIdeaDetailsPage(ideaId: ideaId),
      ),
    );
  }

  void _showActions(
    BuildContext context,
    MHIdeasProvider provider,
    MHIdea idea,
    MHSavedIdea savedIdea,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(idea.title),
        actions: [
          if (savedIdea.status == MHIdeaStatus.saved)
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                provider.startIdea(idea.id);
              },
              child: const Text('Start'),
            ),
          if (savedIdea.status == MHIdeaStatus.inProgress)
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                provider.completeIdea(idea.id);
              },
              child: const Text('Mark as Completed'),
            ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              provider.removeIdea(idea.id);
            },
            child: const Text('Remove from Saved'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: MHTextStyles.title3Emphasized),
        SizedBox(width: 8.r),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 2.r),
          decoration: BoxDecoration(
            color: MHColorStyles.indigo,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            '$count',
            style: MHTextStyles.caption1Emphasized.copyWith(
              color: MHColorStyles.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _SavedIdeaCard extends StatelessWidget {
  final MHIdea idea;
  final MHSavedIdea savedIdea;
  final VoidCallback onTap;
  final VoidCallback onAction;

  const _SavedIdeaCard({
    required this.idea,
    required this.savedIdea,
    required this.onTap,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.r),
        decoration: BoxDecoration(
          color: MHColorStyles.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: MHColorStyles.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      idea.title,
                      style: MHTextStyles.headlineRegular,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: onAction,
                    child: Icon(
                      CupertinoIcons.ellipsis,
                      color: MHColorStyles.gray2Dark,
                      size: 22.r,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.r),
              Row(
                children: [
                  MHCategoryChip(category: idea.category),
                  SizedBox(width: 8.r),
                  _StatusBadge(status: savedIdea.status),
                ],
              ),
              if (savedIdea.status == MHIdeaStatus.inProgress) ...[
                SizedBox(height: 12.r),
                _ProgressIndicator(progress: savedIdea.progress),
              ],
              if (savedIdea.status == MHIdeaStatus.completed) ...[
                SizedBox(height: 12.r),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: MHColorStyles.green,
                      size: 18.r,
                    ),
                    SizedBox(width: 6.r),
                    Text(
                      'Completed',
                      style: MHTextStyles.caption1Emphasized.copyWith(
                        color: MHColorStyles.green,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final MHIdeaStatus status;

  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case MHIdeaStatus.saved:
        return MHColorStyles.gray2Dark;
      case MHIdeaStatus.inProgress:
        return MHColorStyles.orange;
      case MHIdeaStatus.completed:
        return MHColorStyles.green;
    }
  }

  String get _label {
    switch (status) {
      case MHIdeaStatus.saved:
        return 'Saved';
      case MHIdeaStatus.inProgress:
        return 'In Progress';
      case MHIdeaStatus.completed:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        _label,
        style: MHTextStyles.caption2Emphasized.copyWith(color: _color),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final int progress;

  const _ProgressIndicator({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: MHTextStyles.caption1Regular.copyWith(
                color: MHColorStyles.gray2Dark,
              ),
            ),
            Text(
              '$progress%',
              style: MHTextStyles.caption1Emphasized.copyWith(
                color: MHColorStyles.indigo,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.r),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: MHColorStyles.fillsTertiary,
            valueColor: AlwaysStoppedAnimation<Color>(MHColorStyles.indigo),
            minHeight: 6.r,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.folder_open,
              size: 64.r,
              color: MHColorStyles.gray2Dark,
            ),
            SizedBox(height: 16.r),
            Text(
              'Your idea piggy bank is empty',
              style: MHTextStyles.title3Emphasized,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.r),
            Text(
              'Save ideas from the Home or Explore tabs to start building your collection',
              style: MHTextStyles.subheadlineRegular.copyWith(
                color: MHColorStyles.gray2Dark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
