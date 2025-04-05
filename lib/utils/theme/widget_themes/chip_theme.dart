import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class BaakasChipTheme {
  BaakasChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    checkmarkColor: BaakasColors.white,
    selectedColor: BaakasColors.primary,
    disabledColor: BaakasColors.grey.withOpacity(0.4),
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    labelStyle:
        const TextStyle(color: BaakasColors.black, fontFamily: 'Urbanist'),
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    checkmarkColor: BaakasColors.white,
    selectedColor: BaakasColors.primary,
    disabledColor: BaakasColors.darkerGrey,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    labelStyle: TextStyle(color: BaakasColors.white, fontFamily: 'Urbanist'),
  );
}
