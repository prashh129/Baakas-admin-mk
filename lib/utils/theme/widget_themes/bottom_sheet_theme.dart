import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class BaakasBottomSheetTheme {
  BaakasBottomSheetTheme._();

  static BottomSheetThemeData lightBaakasBottomSheetTheme =
      BottomSheetThemeData(
        showDragHandle: true,
        backgroundColor: BaakasColors.white,
        modalBackgroundColor: BaakasColors.white,
        constraints: const BoxConstraints(minWidth: double.infinity),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );

  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: BaakasColors.black,
    modalBackgroundColor: BaakasColors.black,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
