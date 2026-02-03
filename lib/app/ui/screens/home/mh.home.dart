import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:money_hustle/style/mh.color.style.dart';
import 'package:money_hustle/style/mh.text.style.dart';
import 'package:money_hustle/app/data/providers/mh.ideas.provider.dart';
import 'package:money_hustle/app/ui/screens/idea_details/mh.idea_details.page.dart';
import 'package:money_hustle/app/ui/screens/widgets/mh.idea_card.dart';
import 'package:money_hustle/app/ui/premium/mh.main_paywall.page.dart';

class MHHomeScreen extends StatefulWidget {
  const MHHomeScreen({super.key});

  @override
  State<MHHomeScreen> createState() => _MHHomeScreenState();
}

class _MHHomeScreenState extends State<MHHomeScreen> {
  bool _showMotivational = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkMotivational();
    });
  }

  void _checkMotivational() {
    final provider = context.read<MHIdeasProvider>();
    if (provider.shouldShowMotivational()) {
      setState(() => _showMotivational = true);
      provider.markMotivationalShown();
    }
  }

  void _dismissMotivational() {
    setState(() => _showMotivational = false);
  }

  Future<void> _handleSave(String ideaId) async {
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
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: MHColorStyles.white,
            border: null,
            largeTitle: Text('Daily Ideas', style: MHTextStyles.largeTitleEmphasized),
            heroTag: 'home_nav',
          ),
          if (_showMotivational)
            SliverToBoxAdapter(child: _MotivationalBanner(onDismiss: _dismissMotivational)),
          SliverPadding(
            padding: EdgeInsets.all(16.r),
            sliver: Consumer<MHIdeasProvider>(
              builder: (context, provider, _) {
                final ideas = provider.dailyIdeas;
                if (ideas.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No ideas available',
                        style: MHTextStyles.bodyRegular.copyWith(
                          color: MHColorStyles.gray2Dark,
                        ),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final idea = ideas[index];
                      final isSaved = provider.isIdeaSaved(idea.id);
                      final savedIdea = provider.getSavedIdea(idea.id);
                      return MHIdeaCard(
                        idea: idea,
                        isSaved: isSaved,
                        progress: savedIdea?.progress,
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (_) => MHIdeaDetailsPage(ideaId: idea.id),
                            ),
                          );
                        },
                        onSave: () => _handleSave(idea.id),
                      );
                    },
                    childCount: ideas.length,
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20.r)),
        ],
      ),
    );
  }
}

class _MotivationalBanner extends StatelessWidget {
  final VoidCallback onDismiss;

  const _MotivationalBanner({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [MHColorStyles.indigo, MHColorStyles.indigo.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.lightbulb_fill, color: MHColorStyles.yellow, size: 28.r),
          SizedBox(width: 12.r),
          Expanded(
            child: Text(
              'What did you do today to earn more?',
              style: MHTextStyles.subheadlineEmphasized.copyWith(
                color: MHColorStyles.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: Icon(CupertinoIcons.xmark, color: MHColorStyles.white, size: 20.r),
          ),
        ],
      ),
    );
  }
}
