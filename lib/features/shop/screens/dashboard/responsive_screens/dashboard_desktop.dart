import 'package:baakas_admin/common/widgets/texts/page_heading.dart';
import 'package:baakas_admin/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/dashboard/dashboard_controller.dart';
import '../table/data_table.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/order_status_graph.dart';
import '../widgets/weekly_sales.dart';

class DashboardDesktopScreen extends StatelessWidget {
  const DashboardDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BaakasPageHeading(heading: 'Dashboard'),
              const SizedBox(height: BaakasSizes.spaceBtwSections),

              // Card Stats
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => BaakasDashboardCard(
                        headingIcon: Iconsax.note,
                        headingIconColor: Colors.blue,
                        headingIconBgColor: Colors.blue.withOpacity(0.1),
                        stats: 25,
                        context: context,
                        title: 'Sales total',
                        subTitle:
                            '\$${controller.orderController.allItems.fold(0.0, (previousValue, element) => previousValue + element.totalAmount).toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: BaakasSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => BaakasDashboardCard(
                        headingIcon: Iconsax.external_drive,
                        headingIconColor: Colors.green,
                        headingIconBgColor: Colors.green.withOpacity(0.1),
                        stats: 15,
                        context: context,
                        title: 'Average Order Value',
                        subTitle:
                            '\$${(controller.orderController.allItems.fold(0.0, (previousValue, element) => previousValue + element.totalAmount) / controller.orderController.allItems.length).toStringAsFixed(2)}',
                        icon: Iconsax.arrow_down,
                        color: BaakasColors.error,
                      ),
                    ),
                  ),
                  const SizedBox(width: BaakasSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => BaakasDashboardCard(
                        headingIcon: Iconsax.box,
                        headingIconColor: Colors.deepPurple,
                        headingIconBgColor: Colors.deepPurple.withOpacity(0.1),
                        stats: 44,
                        context: context,
                        title: 'Total Orders',
                        subTitle:
                            '\$${controller.orderController.allItems.length}',
                      ),
                    ),
                  ),
                  const SizedBox(width: BaakasSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => BaakasDashboardCard(
                        headingIcon: Iconsax.user,
                        headingIconColor: Colors.deepOrange,
                        headingIconBgColor: Colors.deepOrange.withOpacity(0.1),
                        context: context,
                        title: 'Visitors',
                        subTitle:
                            controller.customerController.allItems.length
                                .toString(),
                        stats: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: BaakasSizes.spaceBtwSections),

              // Graphs
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Weekly Sales Graph
                        const BaakasWeeklySalesGraph(),
                        const SizedBox(height: BaakasSizes.spaceBtwSections),

                        // Orders
                        BaakasRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  BaakasCircularIcon(
                                    icon: Iconsax.box,
                                    backgroundColor: Colors.deepPurple
                                        .withOpacity(0.1),
                                    color: Colors.deepPurple,
                                    size: BaakasSizes.md,
                                  ),
                                  const SizedBox(
                                    width: BaakasSizes.spaceBtwItems,
                                  ),
                                  Text(
                                    'Recent Orders',
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: BaakasSizes.spaceBtwSections,
                              ),
                              const DashboardOrderTable(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: BaakasSizes.spaceBtwSections),
                  Expanded(
                    child: BaakasRoundedContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              BaakasCircularIcon(
                                icon: Iconsax.status,
                                backgroundColor: Colors.amber.withOpacity(0.1),
                                color: Colors.amber,
                                size: BaakasSizes.md,
                              ),
                              const SizedBox(width: BaakasSizes.spaceBtwItems),
                              Text(
                                'Orders Status',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: BaakasSizes.spaceBtwSections),
                          const OrderStatusPieChart(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
