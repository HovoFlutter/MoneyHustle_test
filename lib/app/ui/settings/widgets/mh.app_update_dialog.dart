import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MHAppUpdateDialog {
  static Future<void> showUpdateDialog({
    required BuildContext context,
    required String appStoreUrl,
    String? title,
    String? content,
    String? cancelButton,
    required String agreeButton,
  }) async {
    if (!context.mounted) return;

    return showAdaptiveDialog(
      context: context,
      barrierDismissible: cancelButton == null,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              try {
                await launchUrl(Uri.parse(appStoreUrl));
              } catch (_) {}

              if (!dialogContext.mounted) return;
              Navigator.of(dialogContext, rootNavigator: true).pop();
            },
            child: Text(agreeButton),
          ),
          if (cancelButton != null)
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(dialogContext, rootNavigator: true).pop();
              },
              child: Text(cancelButton),
            ),
        ],
      ),
    );
  }

  static Future<void> showNoUpdatesDialog({
    required BuildContext context,
    String? title,
    String? content,
    required String cancelButton,
  }) async {
    if (!context.mounted) return;

    return showAdaptiveDialog(
      context: context,
      builder: (dialogContext) => AlertDialog.adaptive(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext, rootNavigator: true).pop();
            },
            child: Text(cancelButton),
          ),
        ],
      ),
    );
  }
}
