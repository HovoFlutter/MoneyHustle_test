import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MHFilledButton extends StatefulWidget {
  final FutureOr<void> Function()? onPressed;
  final Widget child;
  const MHFilledButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<MHFilledButton> createState() => _MHFilledButtonState();
}

class _MHFilledButtonState extends State<MHFilledButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: handleOnPressed,
      child: isLoading ? CircularProgressIndicator.adaptive() : widget.child,
    );
  }

  Future<void> handleOnPressed() async {
    if (isLoading) return;
    HapticFeedback.mediumImpact();
    try {
      var result = widget.onPressed?.call();

      if (result is! Future) {
        return result;
      }

      switchState(true);
      await result;

      switchState(false);
    } catch (_) {
      switchState(false);
      rethrow;
    }
  }

  void switchState(bool loading) {
    if (isLoading == loading) return;
    if (!mounted) return;
    setState(() {
      isLoading = loading;
    });
  }
}
