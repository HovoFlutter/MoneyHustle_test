import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppleDeviceType { iphoneSe, iphoneBase, ipad }

const _aspectRatioTolerance = 0.01;

//ipad mini
const _ipadMinWidth = 744;

class MHUIHelper {
  final BuildContext context;
  final MediaQueryData _mediaQuery;

  MHUIHelper._internal(this.context) : _mediaQuery = MediaQuery.of(context) {
    switch (deviceType) {
      case AppleDeviceType.iphoneSe:
      case AppleDeviceType.iphoneBase:
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      case AppleDeviceType.ipad:
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
    }
  }

  static MHUIHelper of(BuildContext context) => MHUIHelper._internal(context);

  double get screenWidth => _mediaQuery.size.width;

  double get screenHeight => _mediaQuery.size.height;

  double get shortestSide => _mediaQuery.size.shortestSide;

  double get longestSide => _mediaQuery.size.longestSide;

  Orientation get orientation => _mediaQuery.orientation;

  double get aspectRatio => _mediaQuery.size.aspectRatio;

  AppleDeviceType get deviceType {
    final width = shortestSide;

    if (width >= _ipadMinWidth) {
      return AppleDeviceType.ipad;
    }

    if (isAspectRatio9by16) {
      return AppleDeviceType.iphoneSe;
    }

    return AppleDeviceType.iphoneBase;
  }

  bool get isAspectRatio9by16 {
    const targetRatio = 9 / 16;

    return (aspectRatio - targetRatio).abs() <= _aspectRatioTolerance;
  }

  bool get isIpad => deviceType == AppleDeviceType.ipad;
  bool get isIphoneSe => deviceType == AppleDeviceType.iphoneSe;
  bool get isBaseIphone => deviceType == AppleDeviceType.iphoneBase;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;
}
