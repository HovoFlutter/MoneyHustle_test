import 'package:apphud_helper/apphud_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_hustle/core/services/mh.ui.helper.dart';
import 'package:money_hustle/core/ui/mh.home_indicator_space.dart';

import '../../../core/mh.core.dart';
import '../../../gen/assets.gen.dart';
import '../../../style/mh.style.dart';
import '../../mh.app.dart';
import '../common/mh.filled_button.dart';

class MHMainPaywallPage extends StatelessWidget {
  const MHMainPaywallPage({super.key});

  static Route route() => CupertinoPageRoute(
    fullscreenDialog: true,
    builder: (_) => MHMainPaywallPage(),
  );

  @override
  Widget build(BuildContext context) {
    String bg;
    switch (uiHelper.deviceType) {
      case AppleDeviceType.iphoneSe:
        bg = Assets.images.premium.paywallSe.path;
      case AppleDeviceType.iphoneBase:
        bg = Assets.images.premium.paywall.path;
      case AppleDeviceType.ipad:
        if (uiHelper.isLandscape) {
          bg = Assets.images.premium.paywallAlbum.path;
        } else {
          bg = Assets.images.premium.paywallIpad.path;
        }
    }
    return PaywallWrapper(
      onSkipPaywallCallback: () {
        //TODO your router for stage 2
        Navigator.pop(context);
      },
      onSuccessPurchaseCallback: () {
        //TODO your router for stage 2
        Navigator.pop(context, true);
      },
      paywallType: PaywallType.main,
      paywallPage: CupertinoPageScaffold(
        backgroundColor: MHColorStyles.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: Image.asset(bg, fit: BoxFit.cover)),

            Positioned(
              // top: 10,
              right: 10,
              child: SafeArea(
                child: PaywallCloseButton(
                  buttonBuilder: (onClose) => CloseButton(
                    onPressed: onClose,
                    color: MHColorStyles.primaryTxt,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16).r,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PaywallActiveProductInfo(
                      infoBuilder:
                          (String activeProductInfo, String? limitedText, _) {
                            return Text(
                              activeProductInfo,
                              textAlign: TextAlign.center,
                              style: MHTextStyles.footnoteRegular,
                            );
                          },
                    ),
                    PaywallTitle(
                      titleBuilder: (String title) {
                        return Text(
                          title.split('\n').join(' '),
                          style: MHTextStyles.title1Emphasized,
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                    SizedBox(height: 4.r),
                    ProductsTilesBuilder(
                      productTileBuilder:
                          (
                            String productName,
                            String productSubtitle,
                            String productPrice,
                            bool isActive,
                            VoidCallback onTap,
                          ) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4.r),
                              child: Material(
                                type: MaterialType.transparency,
                                borderRadius: BorderRadius.circular(18).r,
                                child: InkWell(
                                  onTap: onTap,
                                  borderRadius: BorderRadius.circular(18).r,
                                  child: Ink(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? MHColorStyles.primaryWithOpacity
                                          : null,
                                      borderRadius: BorderRadius.circular(18).r,
                                      border: Border.all(
                                        width: isActive ? 2 : 0.5,
                                        color: MHColorStyles.primary,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                productName,
                                                style: MHTextStyles
                                                    .subheadlineEmphasized
                                                    .copyWith(
                                                      color:
                                                          MHColorStyles.primary,
                                                    ),
                                              ),
                                              Text(
                                                productSubtitle,
                                                style: MHTextStyles
                                                    .footnoteRegular
                                                    .copyWith(
                                                      color: MHColorStyles
                                                          .primary
                                                          .withAlpha(
                                                            (255 * 0.6).toInt(),
                                                          ),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 38,
                                          width: 0.5,
                                          color: MHColorStyles.primary.withAlpha(
                                            (255 * 0.6).toInt(),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            productPrice,
                                            textAlign: TextAlign.end,
                                            style: MHTextStyles
                                                .subheadlineEmphasized
                                                .copyWith(
                                                  color: MHColorStyles.primary,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                    ),
                    SizedBox(height: 8.r),
                    PurchaseButtonBuilder(
                      buttonBuilder: (String buttonText, AsyncCallback onTap) {
                        return MHFilledButton(
                          onPressed: onTap,
                          child: Text(buttonText),
                        );
                      },
                    ),
                    MainPaywallTermsAndPolicySection(),
                    MHHomeIndicatorSpace(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPaywallTermsAndPolicySection extends StatelessWidget {
  const MainPaywallTermsAndPolicySection({super.key});

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
          RestorePurchaseButtonBuilder(
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
