import 'package:baakas_admin/common/widgets/loaders/animation_loader.dart';
import 'package:baakas_admin/features/shop/controllers/customer/customer_detail_controller.dart';
import 'package:baakas_admin/features/shop/screens/customer/customer_detail/table/data_table.dart';
import 'package:baakas_admin/utils/constants/colors.dart';
import 'package:baakas_admin/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerDetailController.instance;
    controller.getCustomerOrders();
    return BaakasRoundedContainer(
      padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
      child: Obx(() {
        if (controller.ordersLoading.value) {
          return const BaakasLoaderAnimation();
        }
        if (controller.allCustomerOrders.isEmpty) {
          return const BaakasAnimationLoaderWidget(
            text: 'No Orders Found',
            animation: BaakasImages.tableIllustration,
          );
        }

        final totalAmount = controller.allCustomerOrders.fold(
          0.0,
          (previousValue, element) => previousValue + element.totalAmount,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Orders',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Total Spent '),
                      TextSpan(
                        text: 'Rs ${totalAmount.toString()}',
                        style: Theme.of(context).textTheme.bodyLarge!.apply(
                          color: BaakasColors.primary,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' on ${controller.allCustomerOrders.length} Orders',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: BaakasSizes.spaceBtwItems),
            TextFormField(
              controller: controller.searchTextController,
              onChanged: (query) => controller.searchQuery(query),
              decoration: const InputDecoration(
                hintText: 'Search Orders',
                prefixIcon: Icon(Iconsax.search_normal),
              ),
            ),
            const SizedBox(height: BaakasSizes.spaceBtwSections),
            const CustomerOrderTable(),
          ],
        );
      }),
    );
  }
}
