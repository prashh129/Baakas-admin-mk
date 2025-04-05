import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../controllers/category/category_controller.dart';
import '../../../../controllers/category/edit_category_controller.dart';
import '../../../../models/category_model.dart';

class EditCategoryForm extends StatelessWidget {
  const EditCategoryForm({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final editController = Get.put(EditCategoryController());
    editController.init(category);
    final categoryController = Get.put(CategoryController());
    return BaakasRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
      child: Form(
        key: editController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: BaakasSizes.sm),
            Text('Update Category',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: BaakasSizes.spaceBtwSections),

            // Name Text Field
            TextFormField(
              controller: editController.name,
              validator: (value) =>
                  BaakasValidator.validateEmptyText('Name', value),
              decoration: const InputDecoration(
                  labelText: 'Category Name',
                  prefixIcon: Icon(Iconsax.category)),
            ),

            const SizedBox(height: BaakasSizes.spaceBtwInputFields),
            Obx(
              () => DropdownButtonFormField<CategoryModel>(
                decoration: const InputDecoration(
                    hintText: 'Parent Category',
                    labelText: 'Parent Category',
                    prefixIcon: Icon(Iconsax.bezier)),
                value: editController.selectedParent.value.id.isNotEmpty
                    ? editController.selectedParent.value
                    : null,
                onChanged: (newValue) =>
                    editController.selectedParent.value = newValue!,
                items: categoryController.allItems
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [Text(item.name)]),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: BaakasSizes.spaceBtwInputFields * 2),

            // Image Uploader & Featured Checkbox
            Obx(
              () => BaakasImageUploader(
                width: 80,
                height: 80,
                image: editController.imageURL.value.isNotEmpty
                    ? editController.imageURL.value
                    : BaakasImages.defaultImage,
                imageType: editController.imageURL.value.isNotEmpty
                    ? ImageType.network
                    : ImageType.asset,
                onIconButtonPressed: () => editController.pickImage(),
              ),
            ),
            const SizedBox(height: BaakasSizes.spaceBtwInputFields),
            Obx(
              () => CheckboxMenuButton(
                value: editController.isFeatured.value,
                onChanged: (value) =>
                    editController.isFeatured.value = value ?? false,
                child: const Text('Featured'),
              ),
            ),
            const SizedBox(height: BaakasSizes.spaceBtwInputFields * 2),
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: editController.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () =>
                                editController.updateCategory(category),
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
