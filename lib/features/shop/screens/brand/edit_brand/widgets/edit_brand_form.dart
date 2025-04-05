import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/chips/rounded_choice_chips.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../controllers/brand/edit_brand_controller.dart';
import '../../../../controllers/category/category_controller.dart';
import '../../../../models/brand_model.dart';

class EditBrandForm extends StatelessWidget {
  const EditBrandForm({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditBrandController());
    controller.init(brand);
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
            Text('Update Brand',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: BaakasSizes.spaceBtwSections),

            // Name Text Field
            TextFormField(
              controller: controller.name,
              validator: (value) =>
                  BaakasValidator.validateEmptyText('Name', value),
              decoration: const InputDecoration(
                  labelText: 'Brand Name', prefixIcon: Icon(Iconsax.category)),
            ),

            const SizedBox(height: BaakasSizes.spaceBtwInputFields),

            Text('Select Categories',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: BaakasSizes.spaceBtwInputFields / 2),
            Obx(() => Wrap(
                  spacing: BaakasSizes.sm,
                  children: CategoryController.instance.allItems
                      .map(
                        (element) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: BaakasSizes.sm),
                          child: BaakasChoiceChip(
                            text: element.name,
                            selected:
                                controller.selectedCategories.contains(element),
                            onSelected: (value) =>
                                controller.toggleSelection(element),
                          ),
                        ),
                      )
                      .toList(),
                )),

            const SizedBox(height: BaakasSizes.spaceBtwInputFields * 2),

            // Image Uploader & Featured Checkbox
            Obx(
              () => BaakasImageUploader(
                width: 80,
                height: 80,
                image: controller.imageURL.value.isNotEmpty
                    ? controller.imageURL.value
                    : BaakasImages.defaultImage,
                imageType: controller.imageURL.value.isNotEmpty
                    ? ImageType.network
                    : ImageType.asset,
                onIconButtonPressed: () => controller.pickImage(),
              ),
            ),
            const SizedBox(height: BaakasSizes.spaceBtwInputFields),
            Obx(
              () => CheckboxMenuButton(
                value: controller.isFeatured.value,
                onChanged: (value) =>
                    controller.isFeatured.value = value ?? false,
                child: const Text('Featured'),
              ),
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
                            onPressed: () => controller.updateBrand(brand),
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
