import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../mh.core.dart';

const _loadingDelay = Duration(seconds: 2);

class MHLoading extends StatefulWidget {
  const MHLoading({super.key});

  @override
  State<MHLoading> createState() => _MHLoadingState();
}

class _MHLoadingState extends State<MHLoading> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!kReleaseMode) await Future.delayed(_loadingDelay);
      if (!mounted) return;

      if (MHOnBoardingHelper.showOnBoarding) {
        context.go('/onboarding');
      } else {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MHCore.splashPage;
  }
}
