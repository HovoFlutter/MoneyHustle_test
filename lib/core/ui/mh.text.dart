import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension MHTextResize on TextStyle {
  TextStyle get rz {
    if (fontSize == null) return this;
    return copyWith(fontSize: fontSize!.spMin, height: height?.spMin);
  }
}
