import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_hustle/style/mh.color.style.dart';
import 'package:money_hustle/style/mh.text.style.dart';
import 'package:money_hustle/app/data/models/mh.idea.dart';

class MHCategoryChip extends StatelessWidget {
  final MHIdeaCategory category;
  final bool selected;
  final VoidCallback? onTap;

  const MHCategoryChip({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
  });

  Color get _backgroundColor {
    if (selected) return MHColorStyles.indigo;
    switch (category) {
      case MHIdeaCategory.onlineWork:
        return MHColorStyles.cyanWithOpacity;
      case MHIdeaCategory.offlineGigs:
        return MHColorStyles.orangeWithOpacity;
      case MHIdeaCategory.hobbyIncome:
        return MHColorStyles.pinkWithOpacity;
      case MHIdeaCategory.seasonal:
        return MHColorStyles.yellowWithOpacity;
      case MHIdeaCategory.skillsFreelance:
        return MHColorStyles.greenWithOpacity;
      case MHIdeaCategory.sellingReselling:
        return MHColorStyles.indigoWithOpacity;
    }
  }

  Color get _textColor {
    if (selected) return MHColorStyles.white;
    switch (category) {
      case MHIdeaCategory.onlineWork:
        return MHColorStyles.cyan;
      case MHIdeaCategory.offlineGigs:
        return MHColorStyles.orange;
      case MHIdeaCategory.hobbyIncome:
        return MHColorStyles.pink;
      case MHIdeaCategory.seasonal:
        return MHColorStyles.yellowDark;
      case MHIdeaCategory.skillsFreelance:
        return MHColorStyles.green;
      case MHIdeaCategory.sellingReselling:
        return MHColorStyles.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 4.r),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          category.label,
          style: MHTextStyles.caption1Emphasized.copyWith(color: _textColor),
        ),
      ),
    );
  }
}

class MHInvestmentChip extends StatelessWidget {
  final MHInvestmentType investment;
  final bool selected;
  final VoidCallback? onTap;

  const MHInvestmentChip({
    super.key,
    required this.investment,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 4.r),
        decoration: BoxDecoration(
          color: selected ? MHColorStyles.indigo : MHColorStyles.fillsTertiary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          investment.label,
          style: MHTextStyles.caption1Emphasized.copyWith(
            color: selected ? MHColorStyles.white : MHColorStyles.primaryTxt,
          ),
        ),
      ),
    );
  }
}
