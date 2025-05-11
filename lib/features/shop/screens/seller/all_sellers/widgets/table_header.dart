import 'package:baakas_admin/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/device/device_utility.dart';
import '../../../../controllers/seller/seller_controller.dart';

class SellerTableHeader extends StatelessWidget {
  const SellerTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellerController());
    return Row(
      children: [
        Expanded(
          flex: !BaakasDeviceUtils.isDesktopScreen(context) ? 1 : 3,
          child: Row(
            children: [
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(BaakasRoutes.createSeller),
                  child: const Text('Create New Seller'),
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
              hintText: 'Search Sellers',
              prefixIcon: Icon(Iconsax.search_normal),
            ),
          ),
        ),
      ],
    );
  }
}
