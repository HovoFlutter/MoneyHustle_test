import 'dart:ui';

class MHCommonConfig {
  final String appName;

  final Size figmaDesignSize;

  final String appId;

  final String appHudKey;

  final String supportEmail;

  final String supportForm;

  MHCommonConfig({
    required this.appName,
    required this.figmaDesignSize,
    required this.appId,
    required this.appHudKey,
    required this.supportEmail,
    required this.supportForm,
  });

  String get appStoreAppLink => 'https://apps.apple.com/app/id$appId';
}
