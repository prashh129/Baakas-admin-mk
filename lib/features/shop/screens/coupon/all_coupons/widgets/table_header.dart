import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/device/device_utility.dart';
import '../../../../controllers/coupon/coupon_controller.dart';

class CouponTableHeader extends StatelessWidget {
  const CouponTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CouponController());
    return Row(
      children: [
        Expanded(
          flex: BaakasDeviceUtils.isDesktopScreen(context) ? 2 : 1,
          child: TextFormField(
            controller: controller.searchTextController,
            onChanged: (query) => controller.searchQuery(query),
            decoration: const InputDecoration(
              hintText: 'Search Coupons',
              prefixIcon: Icon(Iconsax.search_normal),
            ),
          ),
        ),
      ],
    );
  }
}
