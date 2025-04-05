import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class BaakasTextFormFieldTheme {
  BaakasTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: BaakasColors.darkGrey,
    suffixIconColor: BaakasColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: BaakasSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
        fontSize: BaakasSizes.fontSizeMd,
        color: BaakasColors.textPrimary,
        fontFamily: 'Urbanist'),
    hintStyle: const TextStyle().copyWith(
        fontSize: BaakasSizes.fontSizeSm,
        color: BaakasColors.textSecondary,
        fontFamily: 'Urbanist'),
    errorStyle: const TextStyle()
        .copyWith(fontStyle: FontStyle.normal, fontFamily: 'Urbanist'),
    floatingLabelStyle: const TextStyle()
        .copyWith(color: BaakasColors.textSecondary, fontFamily: 'Urbanist'),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BaakasSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BaakasColors.borderPrimary),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BaakasSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BaakasColors.borderPrimary),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BaakasSizes.inputFieldRadius),
      borderSide:
          const BorderSide(width: 1, color: BaakasColors.borderSecondary),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BaakasSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BaakasColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BaakasSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: BaakasColors.error),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: BaakasColors.darkGrey,
    suffixIconColor: BaakasColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: BaakasSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
        fontSize: BaakasSizes.fontSizeMd,
        color: BaakasColors.white,
        fontFamily: 'Urbanist'),
    hintStyle: const TextStyle().copyWith(
        fontSize: BaakasSizes.fontSizeSm,
        color: BaakasColors.white,
        fontFamily: 'Urbanist'),
    floatingLabelStyle: const TextStyle().copyWith(
        color: BaakasColors.white.withOpacity(0.8), fontFamily: 'Urbanist'),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BaakasSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BaakasColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BaakasSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BaakasColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BaakasSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BaakasColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BaakasSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BaakasColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BaakasSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: BaakasColors.error),
    ),
  );
}
