import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../style/mh.style.dart';

class MHSettingsSection extends StatelessWidget {
  final List<Widget> children;

  const MHSettingsSection({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18).r,
      child: Material(
        borderRadius: BorderRadius.circular(18).r,
        color: MHColorStyles.white,
        child: Column(
          children:
              children
                  .expand(
                    (e) => [
                      e,
                      Divider(
                        indent: 16.r,
                        endIndent: 16.r,
                        height: 1,
                        thickness: 1,
                        color: MHColorStyles.primaryWithOpacity,
                      ),
                    ],
                  )
                  .toList()
                ..removeLast(),
        ),
      ),
    );
  }
}
