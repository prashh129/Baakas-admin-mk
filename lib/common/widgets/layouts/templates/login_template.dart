import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../styles/spacing_styles.dart';

/// Template for the login page layout
class BaakasLoginTemplate extends StatelessWidget {
  const BaakasLoginTemplate({super.key, required this.child});

  /// The widget to be displayed inside the login template
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 550,
        child: SingleChildScrollView(
          child: Container(
            padding: BaakasSpacingStyle.paddingWithAppBarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BaakasSizes.cardRadiusLg),
              color: BaakasHelperFunctions.isDarkMode(context) ? BaakasColors.black : Colors.white,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}