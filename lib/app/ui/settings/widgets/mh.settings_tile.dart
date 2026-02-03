import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_hustle/style/mh.color.style.dart';
import 'package:money_hustle/style/mh.text.style.dart';

class MHSettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? status;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final VoidCallback? onTap;
  final bool showChevron;
  final Color? statusColor;

  const MHSettingsTile({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.status,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.showChevron = true,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12).r,
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 30.r,
                  height: 30.r,
                  decoration: BoxDecoration(
                    color:
                        iconBackgroundColor ??
                        MHColorStyles.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6).r,
                  ),
                  child: Icon(
                    icon,
                    size: 18.r,
                    color: iconColor ?? MHColorStyles.primary,
                  ),
                ),
                SizedBox(width: 12.r),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: MHTextStyles.bodyRegular.copyWith(
                        color: MHColorStyles.primaryTxt,
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: EdgeInsets.only(top: 2.r),
                        child: Text(
                          subtitle!,
                          style: MHTextStyles.footnoteRegular.copyWith(
                            color: MHColorStyles.gray2Dark,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (status?.isNotEmpty ?? false) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ).r,
                      decoration: BoxDecoration(
                        color: (statusColor ?? MHColorStyles.primary).withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(12).r,
                      ),
                      child: Text(
                        status!,
                        style: MHTextStyles.caption1Emphasized.copyWith(
                          color: statusColor ?? MHColorStyles.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.r),
                  ],
                  if (showChevron)
                    Icon(
                      CupertinoIcons.chevron_right,
                      color: MHColorStyles.gray2Dark,
                      size: 16.r,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
