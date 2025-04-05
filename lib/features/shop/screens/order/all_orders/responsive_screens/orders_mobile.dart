import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/order/order_controller.dart';
import '../table/data_table.dart';
import '../widgets/table_header.dart';

class OrdersMobileScreen extends StatelessWidget {
  const OrdersMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BaakasBreadcrumbsWithHeading(
                  heading: 'Orders', breadcrumbItems: ['Orders']),
              const SizedBox(height: BaakasSizes.spaceBtwSections),
              // Table Body
              Obx(() {
                if (controller.isLoading.value) {
                  return const BaakasLoaderAnimation();
                }
                return const BaakasRoundedContainer(
                  child: Column(
                    children: [
                      // Table Header
                      OrderTableHeader(),
                      SizedBox(height: BaakasSizes.spaceBtwItems),

                      // Table
                      OrderTable(),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
