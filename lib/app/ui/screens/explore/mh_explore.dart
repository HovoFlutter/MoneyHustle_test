import 'package:flutter/material.dart';
import 'package:money_hustle/style/mh.color.style.dart';
import 'package:money_hustle/style/mh.text.style.dart';

class MHExploreScreen extends StatefulWidget {
  const MHExploreScreen({super.key});

  @override
  State<MHExploreScreen> createState() => _MHExploreScreenState();
}

class _MHExploreScreenState extends State<MHExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MHColorStyles.onbBackground,
      appBar: AppBar(
        backgroundColor: MHColorStyles.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text('Templates', style: ThemeTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: Column(children: [
        ],
      ),
    );
  }
}
