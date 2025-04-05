import 'package:baakas_admin/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/edit_product_controller.dart';

class ProductStockAndPricing extends StatelessWidget {
  const ProductStockAndPricing({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditProductController.instance;

    return Obx(
      () =>
          controller.productType.value == ProductType.single
              ? Form(
                key: controller.stockPriceFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stock
                    FractionallySizedBox(
                      widthFactor: 0.45,
                      child: TextFormField(
                        controller: controller.stock,
                        decoration: const InputDecoration(labelText: 'Stock'),
                        validator:
                            (value) => BaakasValidator.validateEmptyText(
                              'Stock',
                              value,
                            ),
                      ),
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwInputFields),

                    // Pricing
                    Row(
                      children: [
                        // Price
                        Expanded(
                          child: TextFormField(
                            controller: controller.price,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                              hintText: '\$',
                            ),
                            validator:
                                (value) => BaakasValidator.validateEmptyText(
                                  'Price',
                                  value,
                                ),
                          ),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwItems),

                        // Sale Price
                        Expanded(
                          child: TextFormField(
                            controller: controller.salePrice,
                            decoration: const InputDecoration(
                              labelText: 'Discounted Price',
                              hintText: '\$',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              : const SizedBox.shrink(),
    );
  }
}
