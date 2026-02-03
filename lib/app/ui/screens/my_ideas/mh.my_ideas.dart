import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:money_hustle/style/mh.color.style.dart';
import 'package:money_hustle/style/mh.text.style.dart';
import 'package:money_hustle/app/data/models/mh.idea.dart';
import 'package:money_hustle/app/data/providers/mh.ideas.provider.dart';
import 'package:money_hustle/app/ui/screens/idea_details/mh.idea_details.page.dart';
import 'package:money_hustle/app/ui/screens/explore/mh_explore.dart';

class MHMyIdeasScreen extends StatefulWidget {
  const MHMyIdeasScreen({super.key});

  @override
  State<MHMyIdeasScreen> createState() => _MHMyIdeasScreenState();
}

class _MHMyIdeasScreenState extends State<MHMyIdeasScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MHColorStyles.onbBackground,
      body: Column(
        children: [
          CupertinoNavigationBar(
            backgroundColor: MHColorStyles.white,
            border: null,
            middle: Text('My Ideas', style: MHTextStyles.headlineRegular),
            transitionBetweenRoutes: false,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                Consumer<MHIdeasProvider>(
            builder: (context, provider, _) {
              final inProgress = provider.getSavedIdeasByStatus(MHIdeaStatus.inProgress);
              final saved = provider.getSavedIdeasByStatus(MHIdeaStatus.saved);
              final completed = provider.getSavedIdeasByStatus(MHIdeaStatus.completed);

              if (inProgress.isEmpty && saved.isEmpty && completed.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(onFindIdea: _goToExplore),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.all(16.r),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (inProgress.isNotEmpty) ...[
                              _SectionHeader(
                                title: 'In Progress',
                                count: inProgress.length,
                              ),
                              SizedBox(height: 12.r),
                              ...inProgress.map((savedIdea) {
                                final idea = provider.getIdeaById(savedIdea.ideaId);
                                if (idea == null) return const SizedBox.shrink();
                                return _InProgressCard(
                                  idea: idea,
                                  savedIdea: savedIdea,
                                  onTap: () => _openDetails(idea.id),
                                  onContinue: () => _openDetails(idea.id),
                                );
                              }),
                              SizedBox(height: 24.r),
                            ],
                            if (saved.isNotEmpty) ...[
                              _SectionHeader(
                                title: 'Saved',
                                count: saved.length,
                              ),
                              SizedBox(height: 12.r),
                              ...saved.map((savedIdea) {
                                final idea = provider.getIdeaById(savedIdea.ideaId);
                                if (idea == null) return const SizedBox.shrink();
                                return _SavedIdeaRow(
                                  idea: idea,
                                  onTap: () => _openDetails(idea.id),
                                  onStart: () => _startIdea(provider, idea.id),
                                );
                              }),
                              SizedBox(height: 24.r),
                            ],
                            if (completed.isNotEmpty) ...[
                              _SectionHeader(
                                title: 'Completed',
                                count: completed.length,
                              ),
                              SizedBox(height: 12.r),
                              ...completed.map((savedIdea) {
                                final idea = provider.getIdeaById(savedIdea.ideaId);
                                if (idea == null) return const SizedBox.shrink();
                                return _CompletedRow(
                                  idea: idea,
                                  onTap: () => _openDetails(idea.id),
                                );
                              }),
                            ],
                            SizedBox(height: 20.r),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              );
              },
            ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDetails(String ideaId) {
    HapticFeedback.selectionClick();
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (_) => MHIdeaDetailsPage(ideaId: ideaId),
      ),
    );
  }

  void _goToExplore() {
    HapticFeedback.mediumImpact();
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (_) => const MHExploreScreen(),
      ),
    );
  }

  Future<void> _startIdea(MHIdeasProvider provider, String ideaId) async {
    HapticFeedback.mediumImpact();
    await provider.startIdea(ideaId);
    if (mounted) {
      _showStartConfirmation();
    }
  }

  void _showStartConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Nice. Let's start small today.",
          style: MHTextStyles.subheadlineRegular.copyWith(color: MHColorStyles.white),
        ),
        backgroundColor: MHColorStyles.primaryTxt,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        margin: EdgeInsets.all(16.r),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: MHTextStyles.subheadlineEmphasized.copyWith(
            color: MHColorStyles.gray2Dark,
          ),
        ),
        SizedBox(width: 8.r),
        Text(
          '$count',
          style: MHTextStyles.subheadlineRegular.copyWith(
            color: MHColorStyles.labelsTertiary,
          ),
        ),
      ],
    );
  }
}

class _InProgressCard extends StatefulWidget {
  final MHIdea idea;
  final MHSavedIdea savedIdea;
  final VoidCallback onTap;
  final VoidCallback onContinue;

  const _InProgressCard({
    required this.idea,
    required this.savedIdea,
    required this.onTap,
    required this.onContinue,
  });

  @override
  State<_InProgressCard> createState() => _InProgressCardState();
}

class _InProgressCardState extends State<_InProgressCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.98),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: EdgeInsets.only(bottom: 10.r),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: MHColorStyles.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: MHColorStyles.fillsTertiary.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.idea.title,
                style: MHTextStyles.headlineRegular,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.r),
              _ProgressBar(progress: widget.savedIdea.progress),
              SizedBox(height: 14.r),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ContinueButton(onTap: widget.onContinue),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$progress% complete',
              style: MHTextStyles.caption1Regular.copyWith(color: MHColorStyles.gray2Dark),
            ),
          ],
        ),
        SizedBox(height: 6.r),
        ClipRRect(
          borderRadius: BorderRadius.circular(3.r),
          child: LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: MHColorStyles.fillsTertiary.withValues(alpha: 0.5),
            valueColor: AlwaysStoppedAnimation<Color>(MHColorStyles.indigo),
            minHeight: 4.r,
          ),
        ),
      ],
    );
  }
}

class _ContinueButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ContinueButton({required this.onTap});

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 8.r),
          decoration: BoxDecoration(
            color: MHColorStyles.indigo,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            'Continue',
            style: MHTextStyles.caption1Emphasized.copyWith(color: MHColorStyles.white),
          ),
        ),
      ),
    );
  }
}

class _SavedIdeaRow extends StatefulWidget {
  final MHIdea idea;
  final VoidCallback onTap;
  final VoidCallback onStart;

  const _SavedIdeaRow({
    required this.idea,
    required this.onTap,
    required this.onStart,
  });

  @override
  State<_SavedIdeaRow> createState() => _SavedIdeaRowState();
}

class _SavedIdeaRowState extends State<_SavedIdeaRow> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.98),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: EdgeInsets.only(bottom: 8.r),
          padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 14.r),
          decoration: BoxDecoration(
            color: MHColorStyles.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: MHColorStyles.fillsTertiary.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.idea.title,
                  style: MHTextStyles.subheadlineRegular,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 12.r),
              _StartButton(onTap: widget.onStart),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartButton extends StatefulWidget {
  final VoidCallback onTap;

  const _StartButton({required this.onTap});

  @override
  State<_StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<_StartButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.9),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 6.r),
          decoration: BoxDecoration(
            color: MHColorStyles.indigo.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Text(
            'Start',
            style: MHTextStyles.caption1Emphasized.copyWith(color: MHColorStyles.indigo),
          ),
        ),
      ),
    );
  }
}

class _CompletedRow extends StatelessWidget {
  final MHIdea idea;
  final VoidCallback onTap;

  const _CompletedRow({
    required this.idea,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.r),
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 14.r),
        decoration: BoxDecoration(
          color: MHColorStyles.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.checkmark_circle_fill,
              size: 18.r,
              color: MHColorStyles.green,
            ),
            SizedBox(width: 12.r),
            Expanded(
              child: Text(
                idea.title,
                style: MHTextStyles.subheadlineRegular.copyWith(
                  color: MHColorStyles.gray2Dark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onFindIdea;

  const _EmptyState({required this.onFindIdea});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Padding(
      padding: EdgeInsets.fromLTRB(24.r, 0, 24.r, bottomPadding + 24.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Container(
            width: 100.r,
            height: 100.r,
            decoration: BoxDecoration(
              color: MHColorStyles.indigo.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.lightbulb,
              size: 44.r,
              color: MHColorStyles.indigo,
            ),
          ),
          SizedBox(height: 28.r),
          Text(
            "Your money journey\nhasn't started yet.",
            style: MHTextStyles.title3Emphasized,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.r),
          Text(
            'Save one idea and start today.',
            style: MHTextStyles.subheadlineRegular.copyWith(
              color: MHColorStyles.gray2Dark,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 3),
          SizedBox(
            width: double.infinity,
            child: _PrimaryButton(
              label: 'Find an idea',
              onTap: onFindIdea,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.r),
          decoration: BoxDecoration(
            color: MHColorStyles.indigo,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: MHTextStyles.headlineRegular.copyWith(color: MHColorStyles.white),
            ),
          ),
        ),
      ),
    );
  }
}
