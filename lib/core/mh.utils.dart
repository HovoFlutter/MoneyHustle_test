import 'dart:convert';
import 'dart:math';

import 'package:apphud_helper/core/utils/cast.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_hustle/app/ui/settings/widgets/mh.app_update_dialog.dart';
import 'mh.extensions.dart';
import 'package:http/http.dart' as http;

import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:share_plus/share_plus.dart';

import 'ui/mh.privacy_policy.page.dart';
import 'ui/mh.terms_of_use.page.dart';
import 'mh.core.dart';

Future<void> openPrivacyPolicy(BuildContext context) =>
    showCupertinoSheet(context: context, builder: (_) => MHPrivacyPolicyPage());

Future<void> openTermsOfUse(BuildContext context) =>
    showCupertinoSheet(context: context, builder: (_) => MHTermsOfUsePage());

Future<void> openRateApp() async {
  return InAppReview.instance.openStoreListing(appStoreId: MHCore.config.appId);
}

Future<ShareResult?> shareApp(
  Rect? sharePosition, {
  Rect fallabackSharePosition = const Rect.fromLTWH(0, 0, 1, 1),
}) async {
  try {
    return await SharePlus.instance.share(
      ShareParams(
        uri: Uri.parse(MHCore.config.appStoreAppLink),
        sharePositionOrigin: sharePosition,
      ),
    );
  } on PlatformException catch (e) {
    if (e.message?.contains('sharePositionOrigin') ?? false) {
      return SharePlus.instance.share(
        ShareParams(
          uri: Uri.parse(MHCore.config.appStoreAppLink),
          sharePositionOrigin: fallabackSharePosition,
        ),
      );
    } else {
      rethrow;
    }
  }
}

Future<void> openSupport() async {
  if (await canLaunchUrlString(MHCore.config.supportForm)) {
    await launchUrlString(MHCore.config.supportForm);
  }
}

Future<void> contactUs() async {
  var url = Uri.encodeFull(
    'mailto:${MHCore.config.supportEmail}?subject=${MHCore.config.appName}&body=Hello!',
  );
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  }
}

Future<void> showAppVersion(BuildContext context) async {
  final packageInfo = await PackageInfo.fromPlatform();

  if (!context.mounted) return;
  return showAdaptiveDialog(
    context: context,
    builder: (_) => AlertDialog.adaptive(
      content: Text('App version: ${packageInfo.version}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.maybePop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> checkAppUpdate(
  BuildContext context, {
  required String? updateDialogTitle,
  required String? updateDialogContent,

  required String? updateDialogCancelButton,
  required String updateDialogAgreeButton,

  required String? noUpdatesDialogTitle,
  required String? noUpdatesDialogContent,
  required String noUpdatesDialogCancelButton,
}) async {
  (bool needUpdate, String appstore)? check = await checkStoreVersion(
    MHCore.config.appId,
  );

  if (!context.mounted) return;

  if (check?.$1 ?? false) {
    return MHAppUpdateDialog.showUpdateDialog(
      context: context,
      appStoreUrl: check!.$2,
      title: updateDialogTitle,
      content: updateDialogContent,
      cancelButton: updateDialogCancelButton,
      agreeButton: updateDialogAgreeButton,
    );
  } else {
    return MHAppUpdateDialog.showNoUpdatesDialog(
      context: context,
      title: noUpdatesDialogTitle,
      content: noUpdatesDialogContent,
      cancelButton: noUpdatesDialogCancelButton,
    );
  }
}

Future<(bool needUpdate, String appstoreLink)?> checkStoreVersion(
  String appId,
) async {
  final packageInfo = await PackageInfo.fromPlatform();
  var uri = Uri.https("itunes.apple.com", "/lookup", {
    "id": appId,
    "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
  });
  final response = await http.get(uri).catchError((_) {
    return http.Response('', 418);
  });

  if (response.statusCode != 200) {
    return null;
  }

  final json = jsonDecode(response.body);
  final List results = json['results'];
  if (results.isEmpty) {
    return null;
  }

  return (
    compareStringVersions(json['results'][0]['version'], packageInfo.version) ==
        1,
    cast<String>(json['results'][0]['trackViewUrl']) ?? '',
  );
}

int compareStringVersions(String a, String b) {
  var aList = a.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  var bList = b.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  var len = max(aList.length, bList.length);
  for (var i = 0; i < len; i++) {
    if (aList.tryIndex(i) > bList.tryIndex(i)) {
      return 1;
    } else if (aList.tryIndex(i) < bList.tryIndex(i)) {
      return -1;
    }
  }
  return 0;
}
