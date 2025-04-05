import 'package:flutter/material.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';

class BaakasLoginHeader extends StatelessWidget {
  const BaakasLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Image(
            width: 80,
            height: 80,
            image: AssetImage(BaakasImages.darkAppLogo),
          ),
          const SizedBox(height: BaakasSizes.spaceBtwSections),
          Text(
            BaakasTexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: BaakasSizes.sm),
          Text(
            BaakasTexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
