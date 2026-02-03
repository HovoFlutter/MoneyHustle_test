import 'package:apphud_helper/apphud_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/mh.core.dart';
import '../../../../style/mh.style.dart';

class MHTermsAndPolicySection extends StatelessWidget {
  const MHTermsAndPolicySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              openTermsOfUse(context);
            },
            child: Ink(
              height: 42.spMin,
              padding: EdgeInsets.symmetric(horizontal: 8.r),
              child: Center(
                child: Text(
                  'Terms of Use',
                  style: MHTextStyles.footnoteRegular,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              openPrivacyPolicy(context);
            },
            child: Ink(
              height: 42.spMin,
              padding: EdgeInsets.symmetric(horizontal: 8.r),
              child: Center(
                child: Text(
                  'Privacy Policy',
                  style: MHTextStyles.footnoteRegular,
                ),
              ),
            ),
          ),
          SeparateRestorePurchaseButtonBuilder(
            buttonBuilder: (buttonText, onPressed) {
              return InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onPressed.call();
                },
                child: Ink(
                  height: 42.spMin,
                  padding: EdgeInsets.symmetric(horizontal: 8.r),
                  child: Center(
                    child: Text(
                      buttonText,
                      style: MHTextStyles.footnoteRegular,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
