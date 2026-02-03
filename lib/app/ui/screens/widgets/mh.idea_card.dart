import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_hustle/style/mh.color.style.dart';
import 'package:money_hustle/style/mh.text.style.dart';
import 'package:money_hustle/app/data/models/mh.idea.dart';
import 'mh.category_chip.dart';

class MHIdeaCard extends StatelessWidget {
  final MHIdea idea;
  final bool isSaved;
  final int? progress;
  final VoidCallback? onTap;
  final VoidCallback? onSave;

  const MHIdeaCard({
    super.key,
    required this.idea,
    this.isSaved = false,
    this.progress,
    this.onTap,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.r),
        decoration: BoxDecoration(
          color: MHColorStyles.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: MHColorStyles.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      idea.title,
                      style: MHTextStyles.headlineRegular,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onSave != null)
                    GestureDetector(
                      onTap: onSave,
                      child: Icon(
                        isSaved
                            ? CupertinoIcons.bookmark_fill
                            : CupertinoIcons.bookmark,
                        color: isSaved
                            ? MHColorStyles.primary
                            : MHColorStyles.gray2Dark,
                        size: 22.r,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.r),
              Text(
                idea.preview,
                style: MHTextStyles.subheadlineRegular.copyWith(
                  color: MHColorStyles.color6,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.r),
              Row(
                children: [
                  MHCategoryChip(category: idea.category),
                  SizedBox(width: 8.r),
                  _InvestmentLabel(investment: idea.investmentType),
                  const Spacer(),
                  Icon(
                    CupertinoIcons.time,
                    size: 14.r,
                    color: MHColorStyles.gray2Dark,
                  ),
                  SizedBox(width: 4.r),
                  Text(
                    '${idea.readMinutes} min',
                    style: MHTextStyles.caption1Regular.copyWith(
                      color: MHColorStyles.gray2Dark,
                    ),
                  ),
                ],
              ),
              if (progress != null) ...[
                SizedBox(height: 12.r),
                _ProgressBar(progress: progress!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InvestmentLabel extends StatelessWidget {
  final MHInvestmentType investment;

  const _InvestmentLabel({required this.investment});

  IconData get _icon {
    switch (investment) {
      case MHInvestmentType.none:
        return CupertinoIcons.checkmark_circle;
      case MHInvestmentType.upTo100:
        return CupertinoIcons.money_dollar_circle;
      case MHInvestmentType.equipmentRequired:
        return CupertinoIcons.hammer;
    }
  }

  Color get _color {
    switch (investment) {
      case MHInvestmentType.none:
        return MHColorStyles.green;
      case MHInvestmentType.upTo100:
        return MHColorStyles.orange;
      case MHInvestmentType.equipmentRequired:
        return MHColorStyles.pink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_icon, size: 14.r, color: _color),
        SizedBox(width: 4.r),
        Text(
          investment.label,
          style: MHTextStyles.caption1Regular.copyWith(color: _color),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: MHTextStyles.caption1Regular.copyWith(
                color: MHColorStyles.gray2Dark,
              ),
            ),
            Text(
              '$progress%',
              style: MHTextStyles.caption1Emphasized.copyWith(
                color: MHColorStyles.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.r),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: MHColorStyles.fillsTertiary,
            valueColor: AlwaysStoppedAnimation<Color>(MHColorStyles.primary),
            minHeight: 6.r,
          ),
        ),
      ],
    );
  }
}
