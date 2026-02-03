import 'package:flutter/widgets.dart';

import '../../gen/assets.gen.dart';

class MHSplashPage extends StatelessWidget {
  const MHSplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.images.splash.path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
