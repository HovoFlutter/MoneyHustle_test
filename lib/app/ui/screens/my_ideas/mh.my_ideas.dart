import 'package:flutter/material.dart';
import 'package:money_hustle/style/mh.color.style.dart';
import 'package:money_hustle/style/mh.text.style.dart';

class MHMyIdeasScreen extends StatefulWidget {
  const MHMyIdeasScreen({super.key});

  @override
  State<MHMyIdeasScreen> createState() => _MHMyIdeasScreenState();
}

class _MHMyIdeasScreenState extends State<MHMyIdeasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MHColorStyles.onbBackground,
      appBar: AppBar(
        backgroundColor: MHColorStyles.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text('Projects', style: ThemeTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: Column(children: [
        ],
      ),
    );
  }
}
