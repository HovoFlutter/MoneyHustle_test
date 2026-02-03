import 'package:flutter/widgets.dart';

import 'entities/mh.config.dart';
import 'services/mh.boarding.helper.dart';
import 'services/mh.path.dart';

export 'mh.utils.dart';
export 'services/mh.boarding.helper.dart';
export 'services/mh.path.dart';
export 'entities/mh.config.dart';

export 'ui/mh.launch.wrapper.dart';

class MHCore {
  static late final MHCommonConfig config;

  static bool _initialized = false;

  static late final Widget homePage;

  static late final Widget splashPage;

  static late final Widget boardingPage;

  static Future<void> init({
    required MHCommonConfig config,
    required Widget home,
    required Widget splash,
    required Widget onBoarding,
  }) async {
    if (_initialized) return;
    MHCore.config = config;
    MHCore.homePage = home;
    MHCore.splashPage = splash;
    MHCore.boardingPage = onBoarding;
    await initDirPath();
    await MHOnBoardingHelper.init();
    _initialized = true;
  }
}
