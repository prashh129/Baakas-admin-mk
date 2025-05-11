import 'package:baakas_admin/features/shop/controllers/order/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/device/device_utility.dart';


class DashboardTableHeader extends StatelessWidget {
  const DashboardTableHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OrderController.instance;
    return Row(
      children: [
        Expanded(
          flex: !BaakasDeviceUtils.isDesktopScreen(context) ? 0 : 3,
          child: const SizedBox(),
        ),
        Expanded(
          flex: BaakasDeviceUtils.isDesktopScreen(context) ? 2 : 1,
          child: TextFormField(
            controller: controller.searchTextController,
            onChanged: (query) => controller.searchQuery(query),
            decoration: const InputDecoration(
              hintText: 'Search Orders',
              prefixIcon: Icon(Iconsax.search_normal),
            ),
          ),
        ),
      ],
    );
  }
} 