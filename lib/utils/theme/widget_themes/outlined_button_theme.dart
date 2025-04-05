import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Outlined Button Themes -- */
class BaakasOutlinedButtonTheme {
  BaakasOutlinedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: BaakasColors.dark,
      side: const BorderSide(color: BaakasColors.borderPrimary),
      padding: const EdgeInsets.symmetric(
          vertical: BaakasSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BaakasSizes.buttonRadius)),
      textStyle: const TextStyle(
          fontSize: 16,
          color: BaakasColors.black,
          fontWeight: FontWeight.w600,
          fontFamily: 'Urbanist'),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: BaakasColors.light,
      side: const BorderSide(color: BaakasColors.borderPrimary),
      padding: const EdgeInsets.symmetric(
          vertical: BaakasSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BaakasSizes.buttonRadius)),
      textStyle: const TextStyle(
          fontSize: 16,
          color: BaakasColors.textWhite,
          fontWeight: FontWeight.w600,
          fontFamily: 'Urbanist'),
    ),
  );
}
