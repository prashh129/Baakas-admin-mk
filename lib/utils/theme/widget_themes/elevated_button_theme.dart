import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Elevated Button Themes -- */
class BaakasElevatedButtonTheme {
  BaakasElevatedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: BaakasColors.light,
      backgroundColor: BaakasColors.primary,
      disabledForegroundColor: BaakasColors.darkGrey,
      disabledBackgroundColor: BaakasColors.buttonDisabled,
      side: const BorderSide(color: BaakasColors.primary),
      padding: const EdgeInsets.symmetric(vertical: BaakasSizes.buttonHeight),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BaakasSizes.buttonRadius)),
      textStyle: const TextStyle(
          fontSize: 16,
          color: BaakasColors.textWhite,
          fontWeight: FontWeight.w500,
          fontFamily: 'Urbanist'),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: BaakasColors.light,
      backgroundColor: BaakasColors.primary,
      disabledForegroundColor: BaakasColors.darkGrey,
      disabledBackgroundColor: BaakasColors.darkerGrey,
      side: const BorderSide(color: BaakasColors.primary),
      padding: const EdgeInsets.symmetric(vertical: BaakasSizes.buttonHeight),
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
