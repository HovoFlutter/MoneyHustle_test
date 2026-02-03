import 'package:apphud_helper/apphud_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/mh.core.dart';
import '../../../core/services/mh.ui.helper.dart';
import '../../../core/ui/mh.home_indicator_space.dart';
import '../../../gen/assets.gen.dart';
import '../../../style/mh.style.dart';
import '../../mh.app.dart';
import '../common/mh.filled_button.dart';
import 'widgets/mh.terms_policy_section.dart';

class MHOnBoardingPage extends StatefulWidget {
  const MHOnBoardingPage({super.key});

  @override
  State<MHOnBoardingPage> createState() => _MHOnBoardingPageState();
}

class _MHOnBoardingPageState extends State<MHOnBoardingPage> {
  late final CupertinoTabController _controller;

  @override
  void initState() {
    _controller = CupertinoTabController(initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> pages;
    switch (uiHelper.deviceType) {
      case AppleDeviceType.iphoneSe:
        pages = [
          Assets.images.onboarding.onb1Se.path,
          Assets.images.onboarding.onb2Se.path,
          Assets.images.onboarding.onb3Se.path,
          Assets.images.onboarding.onb4Se.path,
        ];
      case AppleDeviceType.iphoneBase:
        pages = [
          Assets.images.onboarding.onb1.path,
          Assets.images.onboarding.onb2.path,
          Assets.images.onboarding.onb3.path,
          Assets.images.onboarding.onb4.path,
        ];
      case AppleDeviceType.ipad:
        if (uiHelper.isLandscape) {
          pages = [
            Assets.images.onboarding.onb1Album.path,
            Assets.images.onboarding.onb2Album.path,
            Assets.images.onboarding.onb3Album.path,
            Assets.images.onboarding.onb4Album.path,
          ];
        } else {
          pages = [
            Assets.images.onboarding.onb1Ipad.path,
            Assets.images.onboarding.onb2Ipad.path,
            Assets.images.onboarding.onb3Ipad.path,
            Assets.images.onboarding.onb4Ipad.path,
          ];
        }
    }

    /// Strings from your figma design
    final firstTitles = ['User Choice', 'We value', 'Use'];
    final secondTitles = [
      'Math Brain Booster',
      'Your Feedback',
      MHCore.config.appName,
      // 'Arithmetic Adventure',
    ];
    final descriptions = [
      'Exercise your brain, learn some quick\ncomputational know-how for fast computations',
      'Share your opinion about\n${MHCore.config.appName}',
      'Practice with lots of fun challenges\nand track your progress',
    ];

    final cloudText = [
      'Subscribe to unlimited exercise',
      'Unlock all practice',
      'Access to custom exercise editor',
    ];

    ///

    final lastPageNumber = pages.length - 1;

    return CupertinoPageScaffold(
      backgroundColor: MHColorStyles.white,
      child: Stack(
        children: [
          Positioned.fill(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (_, _) => IndexedStack(
                index: _controller.index,
                children: pages
                    .map(
                      (p) => Image.asset(
                        p,
                        fit: BoxFit.cover,
                        alignment: Alignment(0, -0.4),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14).r,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListenableBuilder(
                    listenable: _controller,
                    builder: (_, _) {
                      var pageNumber = _controller.index;

                      Widget page;

                      Widget titleSection;

                      final pageIndicator = SizedBox(
                        height: 26.r,
                        child: AnimatedSmoothIndicator(
                          effect: ExpandingDotsEffect(
                            dotColor: MHColorStyles.primaryWithOpacity,
                            activeDotColor: MHColorStyles.primary,
                            dotHeight: 6.r,
                            dotWidth: 6.r,
                            expansionFactor: 4,
                            spacing: 4.r,
                          ),
                          activeIndex: pageNumber,
                          count: pages.length,
                        ),
                      );

                      ///build title
                      ///last page - onboarding paywall
                      if (pageNumber == lastPageNumber) {
                        titleSection = PaywallTitle(
                          titleBuilder: (title) {
                            //because at design we have two colors for title
                            final titles = title.split('\n');
                            return Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: titles.first),
                                  if (titles.length > 1) TextSpan(text: '\n'),
                                  if (titles.length > 1)
                                    TextSpan(
                                      text: titles.last,
                                      style: TextStyle(
                                        color: MHColorStyles.primary,
                                      ),
                                    ),
                                ],
                              ),
                              style: MHTextStyles.onboarding,
                              textAlign: TextAlign.center,
                            );
                          },
                        );
                      } else {
                        titleSection = Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: firstTitles[pageNumber]),
                              TextSpan(text: '\n'),
                              TextSpan(
                                text: secondTitles[pageNumber],
                                style: TextStyle(color: MHColorStyles.primary),
                              ),
                            ],
                          ),
                          style: MHTextStyles.onboarding,
                          textAlign: TextAlign.center,
                        );
                      }

                      Widget descriptionSection;

                      ///build description
                      ///last page - onboarding paywall
                      if (pageNumber == lastPageNumber) {
                        descriptionSection = OnBoardingPaywallActiveProductInfo(
                          infoBuilder:
                              (
                                String subInfo,
                                String? limitedButton,
                                VoidCallback? onLimitedTap,
                              ) {
                                return Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: subInfo),
                                      if (limitedButton != null)
                                        TextSpan(text: '\n'),
                                      if (limitedButton != null)
                                        TextSpan(
                                          text: limitedButton,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = onLimitedTap,
                                        ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  style: MHTextStyles.subheadlineRegular
                                      .copyWith(
                                        color: MHColorStyles.labelsTertiary,
                                      ),
                                );
                              },
                        );
                      } else {
                        descriptionSection = Text(
                          descriptions[pageNumber],
                          textAlign: TextAlign.center,
                          style: MHTextStyles.subheadlineRegular.copyWith(
                            color: MHColorStyles.labelsTertiary,
                          ),
                        );
                      }

                      Widget button;

                      ///build button
                      ///last page - onboarding paywall
                      if (pageNumber == lastPageNumber) {
                        button = PurchaseButtonBuilder(
                          buttonBuilder: (buttonText, onPressed) {
                            return MHFilledButton(
                              onPressed: onPressed,
                              child: Center(child: Text(buttonText)),
                            );
                          },
                        );
                      } else {
                        button = MHFilledButton(
                          onPressed: () {
                            _controller.index = pageNumber + 1;
                          },
                          child: Center(child: Text('Continue')),
                        );
                      }

                      Widget cloud;

                      if (pageNumber == lastPageNumber) {
                        cloud = OnBoardingPaywallTrialSwitchBuilder(
                          switchBuilder:
                              (bool hide, bool? value, String? text, onChange) {
                                return Container(
                                  height: 48.spMin,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100).r,
                                    color: hide
                                        ? null
                                        : MHColorStyles.bgSecondary,
                                  ),

                                  child: hide
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(
                                                12.0.spMin,
                                              ),
                                              child: Text(
                                                text ?? '',
                                                style: MHTextStyles
                                                    .subheadlineRegular
                                                    .copyWith(
                                                      color:
                                                          MHColorStyles.black,
                                                    ),
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: 10.spMin,
                                              ),
                                              child: Switch.adaptive(
                                                value: value ?? false,
                                                onChanged: (_) =>
                                                    onChange?.call(),
                                              ),
                                            ),
                                          ],
                                        ),
                                );
                              },
                        );
                      } else {
                        if (cloudText.length <= pageNumber ||
                            cloudText[pageNumber].isEmpty) {
                          cloud = Container(height: 48.spMin);
                        } else {
                          cloud = Container(
                            height: 48.spMin,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100).r,
                              color: MHColorStyles.bgSecondary,
                            ),

                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12.0.spMin),
                                  child: Text(
                                    cloudText[pageNumber],
                                    style: MHTextStyles.subheadlineRegular
                                        .copyWith(color: MHColorStyles.black),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }

                      ///build page
                      page = Column(
                        children: [
                          pageIndicator,
                          SizedBox(height: 8.r),
                          titleSection,

                          SizedBox(height: 12.r),
                          descriptionSection,
                          SizedBox(height: 8.r),
                          cloud,
                          SizedBox(height: 6.r),
                          button,
                        ],
                      );

                      ///last page - onboarding paywall
                      ///wrap it with special wrapper
                      if (pageNumber == lastPageNumber) {
                        page = PaywallWrapper(
                          onSkipPaywallCallback: () {
                            MHOnBoardingHelper.markOnBoardingAsWatched();

                            //TODO your router. for stage 2
                            context.go('/home');
                          },
                          onSuccessPurchaseCallback: () {
                            MHOnBoardingHelper.markOnBoardingAsWatched();

                            //TODO your router. for stage 2
                            context.go('/home');
                          },
                          paywallType: PaywallType.onboarding,
                          paywallPage: page,
                        );
                      }

                      return page;
                    },
                  ),
                  MHTermsAndPolicySection(),
                  MHHomeIndicatorSpace(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
