import 'package:baakas_admin/features/personalization/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

class ImageAndMeta extends StatelessWidget {
  const ImageAndMeta({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;
    return BaakasRoundedContainer(
      padding: const EdgeInsets.symmetric(
        vertical: BaakasSizes.lg,
        horizontal: BaakasSizes.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              // User Image
              Obx(
                () => BaakasImageUploader(
                  image: controller.settings.value.appLogo.isNotEmpty
                      ? controller.settings.value.appLogo
                      : BaakasImages.defaultImage,
                  imageType: controller.settings.value.appLogo.isNotEmpty
                      ? ImageType.network
                      : ImageType.asset,
                  onImageSelected: (image) => controller.updateAppLogo(),
                ),
              ),
              const SizedBox(height: BaakasSizes.spaceBtwItems),
              Obx(
                () => Text(
                  controller.settings.value.appName,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: BaakasSizes.spaceBtwSections),
            ],
          ),
        ],
      ),
    );
  }
}
