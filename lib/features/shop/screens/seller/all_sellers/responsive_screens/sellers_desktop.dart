import 'package:baakas_admin/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/seller/seller_controller.dart';
import '../table/data_table.dart';
import '../widgets/table_header.dart';

class SellersDesktopScreen extends StatelessWidget {
  const SellersDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellerController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const BaakasBreadcrumbsWithHeading(
                heading: 'Sellers',
                breadcrumbItems: ['Sellers'],
              ),
              const SizedBox(height: BaakasSizes.spaceBtwSections),

              // Table Body
              Obx(() {
                // Show Loader
                if (controller.isLoading.value) {
                  return const BaakasLoaderAnimation();
                }

                return const BaakasRoundedContainer(
                  child: Column(
                    children: [
                      // Table Header
                      SellerTableHeader(),
                      SizedBox(height: BaakasSizes.spaceBtwItems),

                      // Table
                      SellerTable(),
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
