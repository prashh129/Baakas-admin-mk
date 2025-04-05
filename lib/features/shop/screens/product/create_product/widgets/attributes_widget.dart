import 'package:baakas_admin/common/widgets/images/t_rounded_image.dart';
import 'package:baakas_admin/features/shop/controllers/product/create_product_controller.dart';
import 'package:baakas_admin/features/shop/controllers/product/product_attributes_controller.dart';
import 'package:baakas_admin/features/shop/controllers/product/product_variations_controller.dart';
import 'package:baakas_admin/utils/device/device_utility.dart';
import 'package:baakas_admin/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class ProductAttributes extends StatelessWidget {
  ProductAttributes({super.key});

  // Controllers
  final attributeController = Get.put(ProductAttributesController());
  final variationController = Get.put(ProductVariationController());

  @override
  Widget build(BuildContext context) {
    final productController = CreateProductController.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider based on product type
        Obx(
          () =>
              productController.productType.value == ProductType.single
                  ? const Divider(color: BaakasColors.primaryBackground)
                  : const SizedBox.shrink(),
        ),
        Obx(
          () =>
              productController.productType.value == ProductType.single
                  ? const SizedBox(height: BaakasSizes.spaceBtwSections)
                  : const SizedBox.shrink(),
        ),

        Text(
          'Add Product Attributes',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: BaakasSizes.spaceBtwItems),

        // Form to add new attribute
        Form(
          key: attributeController.attributesFormKey,
          child:
              BaakasDeviceUtils.isDesktopScreen(context)
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildAttributeName(attributeController)),
                      const SizedBox(width: BaakasSizes.spaceBtwItems),
                      Expanded(
                        flex: 2,
                        child: _buildAttributes(attributeController),
                      ),
                      const SizedBox(width: BaakasSizes.spaceBtwItems),
                      _buildAddAttributeButton(attributeController),
                    ],
                  )
                  : Column(
                    children: [
                      _buildAttributeName(attributeController),
                      const SizedBox(height: BaakasSizes.spaceBtwItems),
                      _buildAttributes(attributeController),
                      const SizedBox(height: BaakasSizes.spaceBtwItems),
                      _buildAddAttributeButton(attributeController),
                    ],
                  ),
        ),
        const SizedBox(height: BaakasSizes.spaceBtwSections),

        // List of added attributes
        Text(
          'All Attributes',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: BaakasSizes.spaceBtwItems),

        // Display added attributes in a rounded container
        BaakasRoundedContainer(
          backgroundColor: BaakasColors.primaryBackground,
          child: Obx(
            () =>
                attributeController.productAttributes.isNotEmpty
                    ? ListView.separated(
                      shrinkWrap: true,
                      itemCount: attributeController.productAttributes.length,
                      separatorBuilder:
                          (_, __) =>
                              const SizedBox(height: BaakasSizes.spaceBtwItems),
                      itemBuilder: (_, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: BaakasColors.white,
                            borderRadius: BorderRadius.circular(
                              BaakasSizes.borderRadiusLg,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              attributeController
                                      .productAttributes[index]
                                      .name ??
                                  '',
                            ),
                            subtitle: Text(
                              attributeController
                                  .productAttributes[index]
                                  .values!
                                  .map((e) => e.trim())
                                  .toString(),
                            ),
                            trailing: IconButton(
                              onPressed:
                                  () => attributeController.removeAttribute(
                                    index,
                                    context,
                                  ),
                              icon: const Icon(
                                Iconsax.trash,
                                color: BaakasColors.error,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                    : const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BaakasRoundedImage(
                              width: 150,
                              height: 80,
                              imageType: ImageType.asset,
                              image:
                                  BaakasImages.defaultAttributeColorsImageIcon,
                            ),
                          ],
                        ),
                        SizedBox(height: BaakasSizes.spaceBtwItems),
                        Text('There are no attributes added for this product'),
                      ],
                    ),
          ),
        ),

        const SizedBox(height: BaakasSizes.spaceBtwSections),

        // Generate Variations Button
        Obx(
          () =>
              productController.productType.value == ProductType.variable &&
                      variationController.productVariations.isEmpty
                  ? Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton.icon(
                        icon: const Icon(Iconsax.activity),
                        label: const Text('Generate Variations'),
                        onPressed:
                            () => variationController
                                .generateVariationsConfirmation(context),
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // Build button to add a new attribute
  SizedBox _buildAddAttributeButton(ProductAttributesController controller) {
    return SizedBox(
      width: 100,
      child: ElevatedButton.icon(
        onPressed: () => controller.addNewAttribute(),
        icon: const Icon(Iconsax.add),
        style: ElevatedButton.styleFrom(
          foregroundColor: BaakasColors.black,
          backgroundColor: BaakasColors.secondary,
          side: const BorderSide(color: BaakasColors.secondary),
        ),
        label: const Text('Add'),
      ),
    );
  }

  // Build text form field for attribute name
  TextFormField _buildAttributeName(ProductAttributesController controller) {
    return TextFormField(
      controller: controller.attributeName,
      validator:
          (value) => BaakasValidator.validateEmptyText('Attribute Name', value),
      decoration: const InputDecoration(
        labelText: 'Attribute Name',
        hintText: 'Colors, Sizes, Material',
      ),
    );
  }

  // Build text form field for attribute values
  SizedBox _buildAttributes(ProductAttributesController controller) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        expands: true,
        maxLines: null,
        textAlign: TextAlign.start,
        controller: controller.attributes,
        keyboardType: TextInputType.multiline,
        textAlignVertical: TextAlignVertical.top,
        validator:
            (value) =>
                BaakasValidator.validateEmptyText('Attributes Field', value),
        decoration: const InputDecoration(
          labelText: 'Attributes',
          hintText:
              'Add attributes separated by |  Example: Green | Blue | Yellow',
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}
