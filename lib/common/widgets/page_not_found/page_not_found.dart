import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../routes/routes.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../layouts/templates/site_layout.dart';

class BaakasPageNotFound extends StatelessWidget {
  const BaakasPageNotFound(
      {super.key,
      this.isFullPage = false,
      this.title = 'Well, This is Awkward...',
      this.subTitle =
          'It seems we couldn’t find any records here. Maybe they’re off on an adventure or just hiding really well. Try again or check back later!'});

  final bool isFullPage;
  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return BaakasSiteTemplate(
      useLayout: !isFullPage,
      desktop: Center(
        child: Padding(
          padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            children: [
              const SizedBox(
                  width: 400,
                  height: 400,
                  child:
                      Image(image: AssetImage(BaakasImages.errorIllustration))),
              const SizedBox(height: BaakasSizes.spaceBtwItems),
              Text(title,
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: BaakasSizes.spaceBtwItems),
              Text(subTitle, textAlign: TextAlign.center),
              const SizedBox(height: BaakasSizes.spaceBtwSections),
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () => Get.offAllNamed(BaakasRoutes.dashboard),
                  label: const Text('Take Me Home!'),
                  icon: const Icon(Iconsax.home),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
