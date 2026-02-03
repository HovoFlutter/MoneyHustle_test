import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:money_hustle/style/mh.color.style.dart';
import 'package:money_hustle/style/mh.text.style.dart';
import 'package:money_hustle/app/data/providers/mh.ideas.provider.dart';
import 'package:money_hustle/app/data/models/mh.idea.dart';
import 'package:money_hustle/app/data/repositories/mh.ideas.repository.dart';
import 'package:money_hustle/app/ui/screens/idea_details/mh.idea_details.page.dart';
import 'package:money_hustle/app/ui/premium/mh.main_paywall.page.dart';

class MHHomeScreen extends StatefulWidget {
  const MHHomeScreen({super.key});

  @override
  State<MHHomeScreen> createState() => _MHHomeScreenState();
}

class _MHHomeScreenState extends State<MHHomeScreen> with SingleTickerProviderStateMixin {
  bool _showMotivational = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkMotivational();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkMotivational() {
    final provider = context.read<MHIdeasProvider>();
    if (provider.shouldShowMotivational()) {
      setState(() => _showMotivational = true);
      provider.markMotivationalShown();
    }
  }

  void _dismissMotivational() {
    HapticFeedback.lightImpact();
    setState(() => _showMotivational = false);
  }

  Future<void> _handleSave(String ideaId) async {
    HapticFeedback.mediumImpact();
    final provider = context.read<MHIdeasProvider>();
    final canSave = await provider.canSaveIdea();

    if (!canSave) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).push(MHMainPaywallPage.route());
      }
      return;
    }

    if (provider.isIdeaSaved(ideaId)) {
      await provider.removeIdea(ideaId);
    } else {
      await provider.saveIdea(ideaId);
    }
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
            middle: Text('Today', style: MHTextStyles.headlineRegular),
            transitionBetweenRoutes: false,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Consumer<MHIdeasProvider>(
                  builder: (context, provider, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_showMotivational)
                          _MotivationalBanner(
                            message: provider.todaysMotivation,
                            onDismiss: _dismissMotivational,
                          ),
                        SizedBox(height: 8.r),
                        _TodaysFocusChip(focus: provider.dailyFocus),
                        SizedBox(height: 16.r),
                        _IdeaOfTheDayCard(
                          idea: provider.ideaOfTheDay,
                          isSaved: provider.isIdeaSaved(provider.ideaOfTheDay.id),
                          onTap: () => _openDetails(provider.ideaOfTheDay.id),
                          onSave: () => _handleSave(provider.ideaOfTheDay.id),
                        ),
                        SizedBox(height: 28.r),
                        _MoreIdeasSection(
                          ideas: provider.focusIdeas,
                          provider: provider,
                          onTap: _openDetails,
                          onSave: _handleSave,
                        ),
                        SizedBox(height: 24.r),
                        _MicroCopyFooter(),
                        SizedBox(height: 40.r),
                      ],
                    );
                  },
                ),
              ),
            ),
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
}

class _MotivationalBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const _MotivationalBanner({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MHColorStyles.indigo,
            MHColorStyles.indigo.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.sparkles, color: MHColorStyles.yellow, size: 20.r),
          SizedBox(width: 12.r),
          Expanded(
            child: Text(
              message,
              style: MHTextStyles.subheadlineRegular.copyWith(
                color: MHColorStyles.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: Icon(CupertinoIcons.xmark, color: MHColorStyles.white.withValues(alpha: 0.6), size: 16.r),
          ),
        ],
      ),
    );
  }
}

class _TodaysFocusChip extends StatelessWidget {
  final DailyFocus focus;

  const _TodaysFocusChip({required this.focus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
        decoration: BoxDecoration(
          color: MHColorStyles.indigoWithOpacity,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.compass_fill, size: 14.r, color: MHColorStyles.indigo),
            SizedBox(width: 6.r),
            Text(
              focus.title,
              style: MHTextStyles.caption1Emphasized.copyWith(
                color: MHColorStyles.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdeaOfTheDayCard extends StatefulWidget {
  final MHIdea idea;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const _IdeaOfTheDayCard({
    required this.idea,
    required this.isSaved,
    required this.onTap,
    required this.onSave,
  });

  @override
  State<_IdeaOfTheDayCard> createState() => _IdeaOfTheDayCardState();
}

class _IdeaOfTheDayCardState extends State<_IdeaOfTheDayCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.98);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF8F7FF),
                  const Color(0xFFFDFCFF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: MHColorStyles.indigo.withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: MHColorStyles.indigo.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
                  decoration: BoxDecoration(
                    color: MHColorStyles.indigo,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19.r),
                      topRight: Radius.circular(19.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.star_fill, size: 14.r, color: MHColorStyles.yellow),
                      SizedBox(width: 8.r),
                      Text(
                        'Idea of the Day',
                        style: MHTextStyles.caption1Emphasized.copyWith(
                          color: MHColorStyles.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 24.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.idea.title,
                              style: MHTextStyles.title2Emphasized.copyWith(
                                height: 1.2,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.r),
                          _BookmarkButton(
                            isSaved: widget.isSaved,
                            onTap: widget.onSave,
                          ),
                        ],
                      ),
                      SizedBox(height: 12.r),
                      Text(
                        widget.idea.preview,
                        style: MHTextStyles.subheadlineRegular.copyWith(
                          color: MHColorStyles.color6,
                          height: 1.45,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 16.r),
                      Row(
                        children: [
                          _CategoryBadge(category: widget.idea.category),
                          SizedBox(width: 10.r),
                          Icon(CupertinoIcons.time, size: 13.r, color: MHColorStyles.gray2Dark),
                          SizedBox(width: 4.r),
                          Text(
                            '${widget.idea.readMinutes} min',
                            style: MHTextStyles.caption1Regular.copyWith(
                              color: MHColorStyles.gray2Dark,
                            ),
                          ),
                          const Spacer(),
                          _LearnMoreButton(onTap: widget.onTap),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookmarkButton extends StatefulWidget {
  final bool isSaved;
  final VoidCallback onTap;

  const _BookmarkButton({required this.isSaved, required this.onTap});

  @override
  State<_BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<_BookmarkButton> {
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
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: widget.isSaved
                ? MHColorStyles.indigo.withValues(alpha: 0.12)
                : MHColorStyles.fillsTertiary.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.isSaved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
            color: widget.isSaved ? MHColorStyles.indigo : MHColorStyles.gray2Dark,
            size: 18.r,
          ),
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final MHIdeaCategory category;

  const _CategoryBadge({required this.category});

  Color get _color {
    switch (category) {
      case MHIdeaCategory.onlineWork:
        return MHColorStyles.cyan;
      case MHIdeaCategory.offlineGigs:
        return MHColorStyles.orange;
      case MHIdeaCategory.hobbyIncome:
        return MHColorStyles.pink;
      case MHIdeaCategory.seasonal:
        return MHColorStyles.yellowDark;
      case MHIdeaCategory.skillsFreelance:
        return MHColorStyles.green;
      case MHIdeaCategory.sellingReselling:
        return MHColorStyles.indigo;
    }
  }

  Color get _bgColor {
    switch (category) {
      case MHIdeaCategory.onlineWork:
        return MHColorStyles.cyanWithOpacity;
      case MHIdeaCategory.offlineGigs:
        return MHColorStyles.orangeWithOpacity;
      case MHIdeaCategory.hobbyIncome:
        return MHColorStyles.pinkWithOpacity;
      case MHIdeaCategory.seasonal:
        return MHColorStyles.yellowWithOpacity;
      case MHIdeaCategory.skillsFreelance:
        return MHColorStyles.greenWithOpacity;
      case MHIdeaCategory.sellingReselling:
        return MHColorStyles.indigoWithOpacity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 4.r),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        category.label,
        style: MHTextStyles.caption1Emphasized.copyWith(color: _color),
      ),
    );
  }
}

class _LearnMoreButton extends StatefulWidget {
  final VoidCallback onTap;

  const _LearnMoreButton({required this.onTap});

  @override
  State<_LearnMoreButton> createState() => _LearnMoreButtonState();
}

class _LearnMoreButtonState extends State<_LearnMoreButton> {
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Learn more',
                style: MHTextStyles.caption1Emphasized.copyWith(
                  color: MHColorStyles.white,
                ),
              ),
              SizedBox(width: 4.r),
              Icon(CupertinoIcons.arrow_right, size: 12.r, color: MHColorStyles.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreIdeasSection extends StatelessWidget {
  final List<MHIdea> ideas;
  final MHIdeasProvider provider;
  final Function(String) onTap;
  final Function(String) onSave;

  const _MoreIdeasSection({
    required this.ideas,
    required this.provider,
    required this.onTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    if (ideas.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More for you',
            style: MHTextStyles.headlineRegular,
          ),
          SizedBox(height: 12.r),
          Container(
            decoration: BoxDecoration(
              color: MHColorStyles.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: MHColorStyles.fillsTertiary.withValues(alpha: 0.5),
                width: 0.5,
              ),
            ),
            child: Column(
              children: ideas.take(3).toList().asMap().entries.map((entry) {
                final index = entry.key;
                final idea = entry.value;
                final isSaved = provider.isIdeaSaved(idea.id);
                final isLast = index == (ideas.take(3).length - 1);
                return _SecondaryIdeaCell(
                  idea: idea,
                  isSaved: isSaved,
                  showDivider: !isLast,
                  onTap: () => onTap(idea.id),
                  onSave: () => onSave(idea.id),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondaryIdeaCell extends StatefulWidget {
  final MHIdea idea;
  final bool isSaved;
  final bool showDivider;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const _SecondaryIdeaCell({
    required this.idea,
    required this.isSaved,
    required this.showDivider,
    required this.onTap,
    required this.onSave,
  });

  @override
  State<_SecondaryIdeaCell> createState() => _SecondaryIdeaCellState();
}

class _SecondaryIdeaCellState extends State<_SecondaryIdeaCell> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _isPressed ? MHColorStyles.fillsTertiary.withValues(alpha: 0.3) : Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 14.r),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.idea.title,
                          style: MHTextStyles.subheadlineRegular,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.r),
                        Row(
                          children: [
                            _SmallCategoryTag(category: widget.idea.category),
                            SizedBox(width: 10.r),
                            Icon(CupertinoIcons.time, size: 11.r, color: MHColorStyles.labelsTertiary),
                            SizedBox(width: 3.r),
                            Text(
                              '${widget.idea.readMinutes} min',
                              style: MHTextStyles.caption2Regular.copyWith(
                                color: MHColorStyles.labelsTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.r),
                  Icon(
                    CupertinoIcons.chevron_right,
                    size: 16.r,
                    color: MHColorStyles.labelsTertiary,
                  ),
                ],
              ),
            ),
            if (widget.showDivider)
              Padding(
                padding: EdgeInsets.only(left: 16.r),
                child: Divider(height: 0.5, thickness: 0.5, color: MHColorStyles.fillsTertiary.withValues(alpha: 0.5)),
              ),
          ],
        ),
      ),
    );
  }
}

class _SmallCategoryTag extends StatelessWidget {
  final MHIdeaCategory category;

  const _SmallCategoryTag({required this.category});

  Color get _color {
    switch (category) {
      case MHIdeaCategory.onlineWork:
        return MHColorStyles.cyan;
      case MHIdeaCategory.offlineGigs:
        return MHColorStyles.orange;
      case MHIdeaCategory.hobbyIncome:
        return MHColorStyles.pink;
      case MHIdeaCategory.seasonal:
        return MHColorStyles.yellowDark;
      case MHIdeaCategory.skillsFreelance:
        return MHColorStyles.green;
      case MHIdeaCategory.sellingReselling:
        return MHColorStyles.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6.r,
          height: 6.r,
          decoration: BoxDecoration(
            color: _color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5.r),
        Text(
          category.label,
          style: MHTextStyles.caption2Regular.copyWith(color: MHColorStyles.labelsTertiary),
        ),
      ],
    );
  }
}

class _MicroCopyFooter extends StatelessWidget {
  const _MicroCopyFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.r),
      child: Text(
        'One small action today can change your income tomorrow.',
        style: MHTextStyles.footnoteRegular.copyWith(
          color: MHColorStyles.gray2Dark,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
