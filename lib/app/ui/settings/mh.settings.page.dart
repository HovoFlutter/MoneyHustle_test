import 'package:apphud_helper/apphud_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_hustle/app/ui/premium/mh.main_paywall.page.dart';
import 'package:money_hustle/app/ui/premium/widgets/mh.premium_banner.dart';
import 'package:money_hustle/style/mh.color.style.dart';
import 'package:money_hustle/style/mh.text.style.dart';

import '../../../core/mh.core.dart';
import 'widgets/mh.settings_section.dart';
import 'widgets/mh.settings_tile.dart';

class MHSettingsPage extends StatelessWidget {
  static Route route() => CupertinoPageRoute(builder: (_) => MHSettingsPage());

  const MHSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MHColorStyles.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text('Settings', style: ThemeTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.all(16).r,
          children: [
            MHAutoHiddablePremiumBanner(),
            SizedBox(height: 8.r),
            MHSettingsSection(
              children: [
                StreamBuilder<bool>(
                  stream: ApphudHelper.service.hasPremiumStream,
                  builder: (context, snapshot) {
                    return MHSettingsTile(
                      title: 'Current plan',
                      status: snapshot.data == true ? 'Premium' : 'Basic',
                      onTap: () {
                        //todo your router. for stage 2
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).push(MHMainPaywallPage.route());
                      },
                    );
                  },
                ),

                MHSettingsTile(
                  title: 'Current version',
                  onTap: () => showAppVersion(context),
                ),
                Builder(
                  builder: (context) {
                    return MHSettingsTile(
                      title: 'Share App',
                      onTap: () {
                        final box = context.findRenderObject() as RenderBox?;
                        shareApp(box!.localToGlobal(Offset.zero) & box.size);
                      },
                    );
                  },
                ),
                MHSettingsTile(title: 'Rate App', onTap: openRateApp),
              ],
            ),
            SizedBox(height: 8.r),
            SizedBox(height: 8.r),

            MHSettingsSection(
              children: [
                MHSettingsTile(
                  title: 'Support',
                  onTap: () {
                    // [contactUs()];
                    [openSupport()];
                  },
                ),
              ],
            ),
            SizedBox(height: 16.r),
            MHSettingsSection(
              children: [
                MHSettingsTile(
                  title: 'App update',
                  onTap: () => checkAppUpdate(
                    context,
                    updateDialogTitle: 'New Update Available',
                    updateDialogContent:
                        'A new version of the app is available. Would you like to update now?',
                    updateDialogCancelButton: 'Later',
                    updateDialogAgreeButton: 'Update',
                    noUpdatesDialogTitle: 'No Updates',
                    noUpdatesDialogContent:
                        'You are currently running the latest version of the app.',
                    noUpdatesDialogCancelButton: 'OK',
                  ),
                ),

                MHSettingsTile(
                  title: 'Privacy Policy',
                  onTap: () => openPrivacyPolicy(context),
                ),
                MHSettingsTile(
                  title: 'Terms of Use',
                  onTap: () => openTermsOfUse(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
