import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_hustle/app/ui/screens/home/mh.home.dart';
import 'package:money_hustle/app/ui/screens/my_ideas/mh.my_ideas.dart';
import 'package:money_hustle/app/ui/screens/explore/mh_explore.dart';
import 'package:money_hustle/app/ui/settings/mh.settings.page.dart';
import 'package:money_hustle/style/mh.color.style.dart';

/// ignore: must_be_immutable
class MHMainPage extends StatefulWidget {
  int? selectedIndex;
  final bool isAdd;
  final VoidCallback? onAddPressed;

  MHMainPage({
    super.key,
    this.selectedIndex,
    this.isAdd = false,
    this.onAddPressed,
  });

  @override
  State<MHMainPage> createState() => _MHMainPageState();
}

class _MHMainPageState extends State<MHMainPage> {
  static const _screens = <Widget>[
    MHHomeScreen(),
    MHExploreScreen(),
    MHMyIdeasScreen(),
    MHSettingsPage(),
  ];

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = (widget.selectedIndex ?? 0).clamp(0, _screens.length - 1);
  }

  void switchToTab(int index) {
    if (_selectedIndex != index && index >= 0 && index < _screens.length) {
      setState(() => _selectedIndex = index);
    }
  }

  int _navCurrentIndex(bool isAdd, int selectedIndex) {
    if (!isAdd) return selectedIndex;
    return selectedIndex >= 2 ? selectedIndex + 1 : selectedIndex;
  }

  void _onTap(int tappedIndex) {
    if (widget.isAdd && tappedIndex == 2) {
      widget.onAddPressed?.call();
      return;
    }

    int target = tappedIndex;
    if (widget.isAdd && tappedIndex > 2) {
      target = tappedIndex - 1;
    }

    if (_selectedIndex != target) {
      setState(() => _selectedIndex = target);
    }
  }

  List<BottomNavigationBarItem> _buildItems(BuildContext context) {
    final items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(CupertinoIcons.house),
        activeIcon: const Icon(CupertinoIcons.house_fill),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: const Icon(CupertinoIcons.square_stack),
        activeIcon: const Icon(CupertinoIcons.square_stack_fill),
        label: 'Explore',
      ),
      if (widget.isAdd)
        BottomNavigationBarItem(
          icon: Transform.translate(
            offset: const Offset(0, 8),
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF2C92), Color(0xFF7B5CFF)],
                ),
              ),
              child: const Center(
                child: Icon(Icons.add, size: 30, color: Colors.white),
              ),
            ),
          ),
          label: '',
        ),
      BottomNavigationBarItem(
        icon: const Icon(CupertinoIcons.folder),
        activeIcon: const Icon(CupertinoIcons.folder_fill),
        label: 'My Ideas',
      ),
      BottomNavigationBarItem(
        icon: const Icon(CupertinoIcons.settings),
        activeIcon: const Icon(CupertinoIcons.settings_solid),
        label: 'Settings',
      ),
    ];

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildItems(context);

    return Scaffold(
      backgroundColor: MHThemeColors.pageBackground,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: MHColorStyles.white,
            boxShadow: [
              BoxShadow(
                color: MHColorStyles.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            bottom: true,
            child: BottomNavigationBar(
              backgroundColor: MHColorStyles.white,
              currentIndex: _navCurrentIndex(widget.isAdd, _selectedIndex),
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: MHThemeColors.iconColor,
              unselectedItemColor: MHColorStyles.gray2Dark,
              items: items,
              onTap: _onTap,
            ),
          ),
        ),
      ),
    );
  }
}
