import 'package:money_hustle/app/ui/onboarding/mh.onboarding.page.dart';
import 'package:money_hustle/app/ui/premium/mh.main_paywall.page.dart';
import 'package:money_hustle/app/ui/root/mh.main.page.dart';
import 'package:money_hustle/app/ui/settings/mh.settings.page.dart';
import 'package:money_hustle/core/ui/mh.launch.wrapper.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> appRoutes = [
  GoRoute(path: '/', builder: (context, state) => const MHLoading()),
  GoRoute(path: '/paywall', builder: (context, state) => MHMainPaywallPage()),
  GoRoute(path: '/settings', builder: (context, state) => MHSettingsPage()),
  GoRoute(
    path: '/onboarding',
    builder: (context, state) => const MHOnBoardingPage(),
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) {
      final extras = state.extra as Map<String, dynamic>? ?? {};
      final selectedIndex = extras['selectedIndex'] as int?;
      return MHMainPage(
        selectedIndex: selectedIndex,
        isAdd: false,
        onAddPressed: () {
          context.push('/create');
        },
      );
    },
  ),
];
