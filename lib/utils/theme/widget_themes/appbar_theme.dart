import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class BaakasAppBarTheme {
  BaakasAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    iconTheme: IconThemeData(
        color: BaakasColors.iconPrimary, size: BaakasSizes.iconMd),
    actionsIconTheme: IconThemeData(
        color: BaakasColors.iconPrimary, size: BaakasSizes.iconMd),
    titleTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: BaakasColors.black,
        fontFamily: 'Urbanist'),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: BaakasColors.dark,
    surfaceTintColor: BaakasColors.dark,
    iconTheme:
        IconThemeData(color: BaakasColors.black, size: BaakasSizes.iconMd),
    actionsIconTheme:
        IconThemeData(color: BaakasColors.white, size: BaakasSizes.iconMd),
    titleTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: BaakasColors.white,
        fontFamily: 'Urbanist'),
  );
}
