import 'package:apphud_helper/apphud_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_hustle/app/ui/premium/mh.main_paywall.page.dart';
import 'package:money_hustle/gen/assets.gen.dart';

import '../../../../style/mh.style.dart';

class MHAutoHiddablePremiumBanner extends StatelessWidget {
  final EdgeInsets? margin;
  final VoidCallback? onTap;

  const MHAutoHiddablePremiumBanner({
    super.key,
    this.onTap,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ApphudHelper.service.hasPremiumStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != false) return Container();
        return PremiumBanner(
          margin: margin,
          onTap: () {
            if (onTap != null) return onTap?.call();
            //TODO your router for state 2
            Navigator.of(
              context,
              rootNavigator: true,
            ).push(MHMainPaywallPage.route());
          },
        );
      },
    );
  }
}

class PremiumBanner extends StatelessWidget {
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  const PremiumBanner({super.key, this.onTap, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin?.r,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18).r,

        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(18).r,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18).r,
            child: Stack(
              children: [
                Ink(
                  padding: EdgeInsets.all(16).r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18).r,
                    color: MHColorStyles.primary,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: 'Upgrade '),
                                TextSpan(
                                  text: 'to Premium!',
                                  style: TextStyle(
                                    color: MHColorStyles.yellowDark,
                                  ),
                                ),
                              ],
                            ),
                            style: MHTextStyles.title3Emphasized.copyWith(
                              color: MHColorStyles.white,
                            ),
                          ),
                          SizedBox(height: 4.r),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: 'Get unlimited access'),
                                TextSpan(text: '\n'),
                                TextSpan(text: 'to all application features'),
                              ],
                            ),
                            style: MHTextStyles.footnoteRegular.copyWith(
                              color: MHColorStyles.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: -10,
                  bottom: -10,
                  right: 0,
                  child: Image.asset(
                    Assets.images.premium.premiumBannerImage.path,
                    width: 200.spMin,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
