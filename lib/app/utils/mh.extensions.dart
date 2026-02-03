import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension MHCapitalize on String {
  String get capitalizeFirst {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension WAColorfulSvg on SvgPicture {
  SvgPicture get whiteColor => withColor(Colors.white);

  SvgPicture withColor(Color color) {
    return SvgPicture(
      bytesLoader,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      matchTextDirection: matchTextDirection,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
    );
  }
}
