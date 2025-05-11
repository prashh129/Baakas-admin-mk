import 'package:baakas_admin/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/device/device_utility.dart';
import '../../../../controllers/product/product_controller.dart';

class ProductTableHeader extends StatelessWidget {
  const ProductTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Row(
      children: [
        Expanded(
          flex: !BaakasDeviceUtils.isDesktopScreen(context) ? 1 : 3,
          child: Row(
            children: [
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(BaakasRoutes.createProduct),
                  child: const Text('Add Product'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: BaakasDeviceUtils.isDesktopScreen(context) ? 2 : 1,
          child: TextFormField(
            controller: controller.searchTextController,
            onChanged: (query) => controller.searchQuery(query),
            decoration: const InputDecoration(
              hintText: 'Search Products',
              prefixIcon: Icon(Iconsax.search_normal),
            ),
          ),
        ),
      ],
    );
  }
}
