import 'package:baakas_admin/utils/constants/image_strings.dart';
import 'package:baakas_admin/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

/// A circular loader widget with customizable foreground and background colors.
class BaakasLoaderAnimation extends StatelessWidget {
  const BaakasLoaderAnimation({super.key, this.height = 300, this.width = 300});

  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image(
            image: const AssetImage(BaakasImages.ridingIllustration),
            height: height,
            width: width,
          ),
          const SizedBox(height: BaakasSizes.spaceBtwItems),
          const Text('Loading your data...'),
        ],
      ),
    );
  }
}
