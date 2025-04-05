import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

/// Widget for displaying different layouts based on screen size
class BaakasResponsiveWidget extends StatelessWidget {
  const BaakasResponsiveWidget(
      {super.key,
      required this.desktop,
      required this.tablet,
      required this.mobile});

  /// Widget for desktop layout
  final Widget desktop;

  /// Widget for tablet layout
  final Widget tablet;

  /// Widget for mobile layout
  final Widget mobile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth >= BaakasSizes.desktopScreenSize) {
          return desktop;
        } else if (constraints.maxWidth < BaakasSizes.desktopScreenSize &&
            constraints.maxWidth >= BaakasSizes.tabletScreenSize) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
