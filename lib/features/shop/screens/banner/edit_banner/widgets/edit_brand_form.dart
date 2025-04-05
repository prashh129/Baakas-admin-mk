import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/banner/edit_banner_controller.dart';
import '../../../../models/banner_model.dart';

class EditBannerForm extends StatelessWidget {
  const EditBannerForm({super.key, required this.banner});

  final BannerModel banner;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditBannerController());
    controller.init(banner);
    return BaakasRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: BaakasSizes.sm),
            Text('Update Banner',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: BaakasSizes.spaceBtwSections),

            // Image Uploader & Featured Checkbox
            Column(
              children: [
                Obx(
                  () => BaakasRoundedImage(
                    width: 400,
                    height: 200,
                    backgroundColor: BaakasColors.primaryBackground,
                    image: controller.imageURL.value.isNotEmpty
                        ? controller.imageURL.value
                        : BaakasImages.defaultImage,
                    imageType: controller.imageURL.value.isNotEmpty
                        ? ImageType.network
                        : ImageType.asset,
                  ),
                ),
                const SizedBox(height: BaakasSizes.spaceBtwItems),
                TextButton(
                    onPressed: () => controller.pickImage(),
                    child: const Text('Select Image')),
              ],
            ),
            const SizedBox(height: BaakasSizes.spaceBtwInputFields),

            Text('Make your Banner Active or InActive',
                style: Theme.of(context).textTheme.bodyMedium),
            Obx(
              () => CheckboxMenuButton(
                value: controller.isActive.value,
                onChanged: (value) =>
                    controller.isActive.value = value ?? false,
                child: const Text('Active'),
              ),
            ),
            const SizedBox(height: BaakasSizes.spaceBtwInputFields),

            // Dropdown Menu Screens
            Obx(
              () {
                return DropdownButton<String>(
                  value: controller.targetScreen.value,
                  onChanged: (String? newValue) =>
                      controller.targetScreen.value = newValue!,
                  items: AppScreens.allAppScreenItems
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: BaakasSizes.spaceBtwInputFields * 2),
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: controller.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () => controller.updateBanner(banner),
                            child: const Text('Update')),
                      ),
              ),
            ),
            const SizedBox(height: BaakasSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
