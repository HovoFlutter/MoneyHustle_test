import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:money_hustle/style/mh.color.style.dart';
import 'package:money_hustle/style/mh.text.style.dart';
import 'package:money_hustle/app/data/models/mh.idea.dart';
import 'package:money_hustle/app/data/providers/mh.ideas.provider.dart';
import 'package:money_hustle/app/ui/screens/widgets/mh.category_chip.dart';
import 'package:money_hustle/app/ui/premium/mh.main_paywall.page.dart';

class MHIdeaDetailsPage extends StatefulWidget {
  final String ideaId;

  const MHIdeaDetailsPage({super.key, required this.ideaId});

  @override
  State<MHIdeaDetailsPage> createState() => _MHIdeaDetailsPageState();
}

class _MHIdeaDetailsPageState extends State<MHIdeaDetailsPage> {
  void _showProgressFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(CupertinoIcons.checkmark_circle_fill, color: MHColorStyles.white, size: 20.r),
            SizedBox(width: 12.r),
            Text(
              'Great progress! Keep going.',
              style: MHTextStyles.subheadlineRegular.copyWith(color: MHColorStyles.white),
            ),
          ],
        ),
        backgroundColor: MHColorStyles.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        margin: EdgeInsets.all(16.r),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showStartFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(CupertinoIcons.flame_fill, color: MHColorStyles.white, size: 20.r),
            SizedBox(width: 12.r),
            Text(
              "Nice. Let's start small today.",
              style: MHTextStyles.subheadlineRegular.copyWith(color: MHColorStyles.white),
            ),
          ],
        ),
        backgroundColor: MHColorStyles.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        margin: EdgeInsets.all(16.r),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MHIdeasProvider>(
      builder: (context, provider, _) {
        final idea = provider.getIdeaById(widget.ideaId);
        if (idea == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Idea not found')),
          );
        }

        final savedIdea = provider.getSavedIdea(widget.ideaId);
        final isSaved = savedIdea != null;
        final isInProgress = savedIdea?.status == MHIdeaStatus.inProgress;
        final isCompleted = savedIdea?.status == MHIdeaStatus.completed;

        return Scaffold(
          backgroundColor: MHColorStyles.onbBackground,
          body: Column(
            children: [
              CupertinoNavigationBar(
                backgroundColor: MHColorStyles.white,
                border: null,
                middle: Text('Details', style: MHTextStyles.headlineRegular),
                transitionBetweenRoutes: false,
                trailing: GestureDetector(
                  onTap: () => _handleSave(context, provider, idea),
                  child: Icon(
                    isSaved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                    color: isSaved ? MHColorStyles.primary : MHColorStyles.gray2Dark,
                  ),
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.all(16.r),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Text(idea.title, style: MHTextStyles.title2Emphasized),
                          SizedBox(height: 12.r),
                          _MetaRow(idea: idea),
                          SizedBox(height: 16.r),
                          _ContentSection(title: 'Overview', content: idea.content),
                          SizedBox(height: 20.r),
                          _StepsSection(
                            steps: idea.steps,
                            stepsCompleted: savedIdea?.stepsCompleted ?? [],
                            isInProgress: isInProgress,
                            onStepToggle: (index, completed) {
                              provider.updateStepProgress(widget.ideaId, index, completed);
                              if (completed) {
                                _showProgressFeedback();
                              }
                            },
                          ),
                          SizedBox(height: 20.r),
                          _TipsSection(tips: idea.tips),
                          SizedBox(height: 20.r),
                          _DisclaimerSection(disclaimer: idea.disclaimer),
                          SizedBox(height: 120.r),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              _BottomActionBar(
                idea: idea,
                isSaved: isSaved,
                isInProgress: isInProgress,
                isCompleted: isCompleted,
                onStart: () => _handleStart(context, provider),
                onComplete: () => provider.completeIdea(widget.ideaId),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleSave(BuildContext context, MHIdeasProvider provider, MHIdea idea) async {
    if (provider.isIdeaSaved(idea.id)) {
      await provider.removeIdea(idea.id);
      return;
    }

    final canSave = await provider.canSaveIdea();
    if (!canSave) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).push(MHMainPaywallPage.route());
      }
      return;
    }
    await provider.saveIdea(idea.id);
  }

  Future<void> _handleStart(BuildContext context, MHIdeasProvider provider) async {
    final canSave = await provider.canSaveIdea();
    if (!canSave && !provider.isIdeaSaved(widget.ideaId)) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).push(MHMainPaywallPage.route());
      }
      return;
    }
    await provider.startIdea(widget.ideaId);
    if (mounted) {
      _showStartFeedback();
    }
  }
}

class _MetaRow extends StatelessWidget {
  final MHIdea idea;

  const _MetaRow({required this.idea});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.r,
      runSpacing: 8.r,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        MHCategoryChip(category: idea.category),
        _InvestmentBadge(investment: idea.investmentType),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.time, size: 14.r, color: MHColorStyles.gray2Dark),
            SizedBox(width: 4.r),
            Text(
              '${idea.readMinutes} min read',
              style: MHTextStyles.caption1Regular.copyWith(color: MHColorStyles.gray2Dark),
            ),
          ],
        ),
      ],
    );
  }
}

class _InvestmentBadge extends StatelessWidget {
  final MHInvestmentType investment;

  const _InvestmentBadge({required this.investment});

  IconData get _icon {
    switch (investment) {
      case MHInvestmentType.none:
        return CupertinoIcons.checkmark_circle;
      case MHInvestmentType.upTo100:
        return CupertinoIcons.money_dollar_circle;
      case MHInvestmentType.equipmentRequired:
        return CupertinoIcons.hammer;
    }
  }

  Color get _color {
    switch (investment) {
      case MHInvestmentType.none:
        return MHColorStyles.green;
      case MHInvestmentType.upTo100:
        return MHColorStyles.orange;
      case MHInvestmentType.equipmentRequired:
        return MHColorStyles.pink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 14.r, color: _color),
          SizedBox(width: 4.r),
          Text(
            investment.label,
            style: MHTextStyles.caption1Emphasized.copyWith(color: _color),
          ),
        ],
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final String title;
  final String content;

  const _ContentSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: MHColorStyles.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: MHTextStyles.headlineRegular),
          SizedBox(height: 8.r),
          Text(
            content,
            style: MHTextStyles.bodyRegular.copyWith(
              color: MHColorStyles.color6,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepsSection extends StatelessWidget {
  final List<String> steps;
  final List<bool> stepsCompleted;
  final bool isInProgress;
  final Function(int, bool) onStepToggle;

  const _StepsSection({
    required this.steps,
    required this.stepsCompleted,
    required this.isInProgress,
    required this.onStepToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: MHColorStyles.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.list_number, size: 20.r, color: MHColorStyles.primary),
              SizedBox(width: 8.r),
              Text('Steps to Get Started', style: MHTextStyles.headlineRegular),
            ],
          ),
          if (isInProgress) ...[
            SizedBox(height: 8.r),
            Text(
              'Tap to mark steps as done',
              style: MHTextStyles.caption1Regular.copyWith(color: MHColorStyles.gray2Dark),
            ),
          ],
          SizedBox(height: 12.r),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isCompleted = index < stepsCompleted.length && stepsCompleted[index];

            return Padding(
              padding: EdgeInsets.only(bottom: 8.r),
              child: GestureDetector(
                onTap: isInProgress ? () => onStepToggle(index, !isCompleted) : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28.r,
                      height: 28.r,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? MHColorStyles.green
                            : (isInProgress ? MHColorStyles.fillsTertiary : MHColorStyles.primaryWithOpacity),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(CupertinoIcons.checkmark, size: 16.r, color: MHColorStyles.white)
                            : Text(
                                '${index + 1}',
                                style: MHTextStyles.caption1Emphasized.copyWith(
                                  color: isInProgress ? MHColorStyles.gray2Dark : MHColorStyles.primary,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 12.r),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.r),
                        child: Text(
                          step,
                          style: MHTextStyles.subheadlineRegular.copyWith(
                            color: isCompleted ? MHColorStyles.gray2Dark : MHColorStyles.primaryTxt,
                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _TipsSection extends StatelessWidget {
  final List<String> tips;

  const _TipsSection({required this.tips});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: MHColorStyles.greenWithOpacity,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.lightbulb, size: 20.r, color: MHColorStyles.green),
              SizedBox(width: 8.r),
              Text(
                'Pro Tips',
                style: MHTextStyles.headlineRegular.copyWith(color: MHColorStyles.green),
              ),
            ],
          ),
          SizedBox(height: 12.r),
          ...tips.map((tip) => Padding(
                padding: EdgeInsets.only(bottom: 6.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: MHTextStyles.bodyRegular.copyWith(color: MHColorStyles.green)),
                    Expanded(
                      child: Text(
                        tip,
                        style: MHTextStyles.subheadlineRegular.copyWith(
                          color: MHColorStyles.primaryTxt,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _DisclaimerSection extends StatelessWidget {
  final String disclaimer;

  const _DisclaimerSection({required this.disclaimer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: MHColorStyles.orangeWithOpacity,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.exclamationmark_triangle, size: 18.r, color: MHColorStyles.orange),
              SizedBox(width: 8.r),
              Text(
                'Realistic Expectations',
                style: MHTextStyles.subheadlineEmphasized.copyWith(color: MHColorStyles.orange),
              ),
            ],
          ),
          SizedBox(height: 8.r),
          Text(
            disclaimer,
            style: MHTextStyles.footnoteRegular.copyWith(
              color: MHColorStyles.primaryTxt,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final MHIdea idea;
  final bool isSaved;
  final bool isInProgress;
  final bool isCompleted;
  final VoidCallback onStart;
  final VoidCallback onComplete;

  const _BottomActionBar({
    required this.idea,
    required this.isSaved,
    required this.isInProgress,
    required this.isCompleted,
    required this.onStart,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 16.r + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: MHColorStyles.white,
        boxShadow: [
          BoxShadow(
            color: MHColorStyles.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isCompleted && !isInProgress) ...[
            Text(
              'This takes ~${idea.readMinutes * 5} minutes to start.',
              style: MHTextStyles.caption1Regular.copyWith(color: MHColorStyles.gray2Dark),
            ),
            SizedBox(height: 12.r),
          ],
          if (isInProgress) ...[
            Text(
              "Mark today's step as done above",
              style: MHTextStyles.caption1Regular.copyWith(color: MHColorStyles.gray2Dark),
            ),
            SizedBox(height: 12.r),
          ],
          _ActionButton(
            isSaved: isSaved,
            isInProgress: isInProgress,
            isCompleted: isCompleted,
            onStart: onStart,
            onComplete: onComplete,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final bool isSaved;
  final bool isInProgress;
  final bool isCompleted;
  final VoidCallback onStart;
  final VoidCallback onComplete;

  const _ActionButton({
    required this.isSaved,
    required this.isInProgress,
    required this.isCompleted,
    required this.onStart,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.r),
        decoration: BoxDecoration(
          color: MHColorStyles.green,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.checkmark_circle_fill, color: MHColorStyles.white, size: 20.r),
            SizedBox(width: 8.r),
            Text(
              'Completed',
              style: MHTextStyles.headlineRegular.copyWith(color: MHColorStyles.white),
            ),
          ],
        ),
      );
    }

    if (isInProgress) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onComplete,
          style: FilledButton.styleFrom(
            backgroundColor: MHColorStyles.green,
            padding: EdgeInsets.symmetric(vertical: 16.r),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
          ),
          child: Text(
            'Mark as Completed',
            style: MHTextStyles.headlineRegular.copyWith(color: MHColorStyles.white),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onStart,
        style: FilledButton.styleFrom(
          backgroundColor: MHColorStyles.primary,
          padding: EdgeInsets.symmetric(vertical: 16.r),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
        ),
        child: Text(
          isSaved ? 'Start This Idea' : 'Save & Start',
          style: MHTextStyles.headlineRegular.copyWith(color: MHColorStyles.white),
        ),
      ),
    );
  }
}
