import 'package:flutter/material.dart';
import 'package:money_hustle/style/mh.color.style.dart';
import 'package:money_hustle/style/mh.text.style.dart';

class MHHomeScreen extends StatefulWidget {
  const MHHomeScreen({super.key});

  @override
  State<MHHomeScreen> createState() => _MHHomeScreenState();
}

class _MHHomeScreenState extends State<MHHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MHColorStyles.onbBackground,
      appBar: AppBar(
        backgroundColor: MHColorStyles.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text('Home', style: ThemeTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: Column(children: [
        ],
      ),
    );
  }
}
