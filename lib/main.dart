import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:apphud_helper/apphud_helper.dart';

import 'app/data/providers/mh.ideas.provider.dart';
import 'app/mh.app.dart';
import 'app/ui/onboarding/mh.onboarding.page.dart';
import 'app/ui/root/mh.main.page.dart';
import 'app/ui/mh.splash.page.dart';
import 'core/mh.core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MHCore.init(
    //TODO fill the config
    config: MHCommonConfig(
      appName: 'MoneyHustle',

      ///base iphone size
      figmaDesignSize: Size(375, 812),
      appId: '111111111',
      appHudKey: 'app_HorEUWWedWd1V683fWnwZwZFLfvZEr',
      supportEmail: 'support@email.com',
      supportForm: 'https://forms.gle/EH8YUddXBzfSxVR26',
    ),
    home: MHMainPage(),
    splash: MHSplashPage(),
    onBoarding: MHOnBoardingPage(),
  );
  ApphudHelper.configure(
    ApphudHelperConfig(
      apiKey: MHCore.config.appHudKey,
      productTexts: ProductTexts(),
      dialogs: DialogTexts(),

      fallbacks: CommonFallbackTexts(restoreButtonText: 'Restore'),
      mainPaywallSettings: MainPaywallSettings(),
      onBoardingPaywallSettings: OnBoardingPaywallSettings(),
    ),
    helperType: HelperType.fallbackBased,
  );
  final ideasProvider = MHIdeasProvider();
  await ideasProvider.init();

  runApp(
    ChangeNotifierProvider.value(
      value: ideasProvider,
      child: DevicePreview(
        enabled: kReleaseMode,
        builder: (context) {
          return const MoneyHustle();
        },
      ),
    ),
  );
}
