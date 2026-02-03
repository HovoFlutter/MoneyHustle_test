import 'package:flutter/material.dart';

class MHHomeIndicatorSpace extends StatelessWidget {
  const MHHomeIndicatorSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).viewPadding.bottom);
  }
}
