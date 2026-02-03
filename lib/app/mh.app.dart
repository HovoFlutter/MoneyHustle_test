import 'package:flutter/material.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_hustle/app/ui/router/mh.router.dart';
import 'package:go_router/go_router.dart';

import '../core/mh.core.dart';
import '../core/services/mh.ui.helper.dart';
import '../style/mh.style.dart';

late MHUIHelper uiHelper;
final GoRouter appRouter = GoRouter(initialLocation: '/', routes: appRoutes);

class MoneyHustle extends StatelessWidget {
  const MoneyHustle({super.key});

  @override
  Widget build(BuildContext context) {
    uiHelper = MHUIHelper.of(context);
    return ScreenUtilInit(
      designSize: MHCore.config.figmaDesignSize,
      minTextAdapt: false,
      useInheritedMediaQuery: true,
      builder: (context, _) {
        ///or CupertinoApp without appThemeBuilder
        return MaterialApp.router(
          title: MHCore.config.appName,
          debugShowCheckedModeBanner: false,
          theme: appThemeBuilder(context),
          locale: const Locale('en'),
          builder: (context, child) => KeyboardDismissOnTap(
            child: Material(
              type: MaterialType.transparency,
              child: child ?? Container(),
            ),
          ),
          routerConfig: appRouter,

          /// all routes from core:
          // initialRoute: '/',
          // routes: {
          //   '/': (_) => Loading(),
          //   '/onboarding': (_) => Boarding(),
          //   '/home': (_) => Home(),
          // },
        );
      },
    );
  }
}
