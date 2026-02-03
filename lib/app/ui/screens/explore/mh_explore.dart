import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:money_hustle/style/mh.color.style.dart';
import 'package:money_hustle/style/mh.text.style.dart';
import 'package:money_hustle/app/data/models/mh.idea.dart';
import 'package:money_hustle/app/data/providers/mh.ideas.provider.dart';
import 'package:money_hustle/app/ui/screens/idea_details/mh.idea_details.page.dart';
import 'package:money_hustle/app/ui/screens/widgets/mh.idea_card.dart';
import 'package:money_hustle/app/ui/screens/widgets/mh.category_chip.dart';
import 'package:money_hustle/app/ui/premium/mh.main_paywall.page.dart';

class MHExploreScreen extends StatefulWidget {
  const MHExploreScreen({super.key});

  @override
  State<MHExploreScreen> createState() => _MHExploreScreenState();
}

class _MHExploreScreenState extends State<MHExploreScreen> {
  final _searchController = TextEditingController();
  final Set<MHIdeaCategory> _selectedCategories = {};
  final Set<MHInvestmentType> _selectedInvestments = {};
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleCategory(MHIdeaCategory category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  void _toggleInvestment(MHInvestmentType investment) {
    setState(() {
      if (_selectedInvestments.contains(investment)) {
        _selectedInvestments.remove(investment);
      } else {
        _selectedInvestments.add(investment);
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedCategories.clear();
      _selectedInvestments.clear();
      _searchQuery = '';
      _searchController.clear();
    });
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
            largeTitle: Text('Explore', style: MHTextStyles.largeTitleEmphasized),
            heroTag: 'explore_nav',
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Search ideas...',
                onChanged: (value) => setState(() => _searchQuery = value),
                onSuffixTap: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Categories', style: MHTextStyles.subheadlineEmphasized),
                      if (_selectedCategories.isNotEmpty || _selectedInvestments.isNotEmpty)
                        GestureDetector(
                          onTap: _clearFilters,
                          child: Text(
                            'Clear all',
                            style: MHTextStyles.subheadlineRegular.copyWith(
                              color: MHColorStyles.indigo,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.r),
                  Wrap(
                    spacing: 8.r,
                    runSpacing: 8.r,
                    children: MHIdeaCategory.values.map((category) {
                      return MHCategoryChip(
                        category: category,
                        selected: _selectedCategories.contains(category),
                        onTap: () => _toggleCategory(category),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.r),
                  Text('Investment', style: MHTextStyles.subheadlineEmphasized),
                  SizedBox(height: 8.r),
                  Wrap(
                    spacing: 8.r,
                    runSpacing: 8.r,
                    children: MHInvestmentType.values.map((investment) {
                      return MHInvestmentChip(
                        investment: investment,
                        selected: _selectedInvestments.contains(investment),
                        onTap: () => _toggleInvestment(investment),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(
              height: 1,
              thickness: 1,
              color: MHColorStyles.fillsTertiary,
              indent: 16.r,
              endIndent: 16.r,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.r),
            sliver: Consumer<MHIdeasProvider>(
              builder: (context, provider, _) {
                final ideas = provider.filterIdeas(
                  query: _searchQuery.isEmpty ? null : _searchQuery,
                  categories: _selectedCategories.isEmpty ? null : _selectedCategories,
                  investments: _selectedInvestments.isEmpty ? null : _selectedInvestments,
                );

                if (ideas.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(
                      hasFilters: _searchQuery.isNotEmpty ||
                          _selectedCategories.isNotEmpty ||
                          _selectedInvestments.isNotEmpty,
                      onClear: _clearFilters,
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final idea = ideas[index];
                      final isSaved = provider.isIdeaSaved(idea.id);
                      return MHIdeaCard(
                        idea: idea,
                        isSaved: isSaved,
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

class _EmptyState extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onClear;

  const _EmptyState({required this.hasFilters, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.search,
              size: 48.r,
              color: MHColorStyles.gray2Dark,
            ),
            SizedBox(height: 16.r),
            Text(
              hasFilters ? 'No results found' : 'Start exploring',
              style: MHTextStyles.title3Emphasized,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.r),
            Text(
              hasFilters
                  ? 'Try adjusting your filters or search terms'
                  : 'Use the search bar or filters to find ideas',
              style: MHTextStyles.subheadlineRegular.copyWith(
                color: MHColorStyles.gray2Dark,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              SizedBox(height: 16.r),
              CupertinoButton(
                onPressed: onClear,
                child: Text(
                  'Clear filters',
                  style: MHTextStyles.subheadlineEmphasized.copyWith(
                    color: MHColorStyles.indigo,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
