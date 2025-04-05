import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../theme/widget_themes/appbar_theme.dart';
import '../theme/widget_themes/bottom_sheet_theme.dart';
import '../theme/widget_themes/checkbox_theme.dart';
import '../theme/widget_themes/chip_theme.dart';
import '../theme/widget_themes/elevated_button_theme.dart';
import '../theme/widget_themes/outlined_button_theme.dart';
import '../theme/widget_themes/text_field_theme.dart';
import '../theme/widget_themes/text_theme.dart';

class BaakasAppTheme {
  BaakasAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    disabledColor: BaakasColors.grey,
    brightness: Brightness.light,
    primaryColor: BaakasColors.primary,
    textTheme: BaakasTextTheme.lightTextTheme,
    chipTheme: BaakasChipTheme.lightChipTheme,
    appBarTheme: BaakasAppBarTheme.lightAppBarTheme,
    checkboxTheme: BaakasCheckboxTheme.lightCheckboxTheme,
    scaffoldBackgroundColor: BaakasColors.primaryBackground,
    bottomSheetTheme: BaakasBottomSheetTheme.lightBaakasBottomSheetTheme,
    elevatedButtonTheme: BaakasElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: BaakasOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: BaakasTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    disabledColor: BaakasColors.grey,
    brightness: Brightness.dark,
    primaryColor: BaakasColors.primary,
    textTheme: BaakasTextTheme.darkTextTheme,
    chipTheme: BaakasChipTheme.darkChipTheme,
    appBarTheme: BaakasAppBarTheme.darkAppBarTheme,
    checkboxTheme: BaakasCheckboxTheme.darkCheckboxTheme,
    scaffoldBackgroundColor: BaakasColors.primary.withOpacity(0.1),
    bottomSheetTheme: BaakasBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: BaakasElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: BaakasOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: BaakasTextFormFieldTheme.darkInputDecorationTheme,
  );
}
