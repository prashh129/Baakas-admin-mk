import 'package:baakas_admin/features/shop/controllers/kyc/kyc_controller.dart';
import 'package:baakas_admin/features/shop/screens/kyc/kyc_review_screen.dart';
import 'package:baakas_admin/utils/constants/sizes.dart';
import 'package:baakas_admin/utils/device/device_utility.dart';
import 'package:baakas_admin/utils/helpers/helper_functions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';

class KYCReviewDesktopScreen extends StatelessWidget {
  const KYCReviewDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = KYCController.instance;
    final isDark = BaakasHelperFunctions.isDarkMode(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumbs
            const BaakasBreadcrumbsWithHeading(
              returnToPreviousScreen: true,
              heading: 'KYC Review',
              breadcrumbItems: ['KYC Review'],
            ),
            const SizedBox(height: BaakasSizes.spaceBtwSections),

            // Table Body
            Obx(() {
              if (controller.isLoading.value) {
                return const BaakasLoaderAnimation();
              }

              return BaakasRoundedContainer(
                child: Column(
                  children: [
                    // Search Header
                    Padding(
                      padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
                      child: Row(
                        children: [
                          Expanded(
                            flex: BaakasDeviceUtils.isDesktopScreen(context) ? 2 : 1,
                            child: TextFormField(
                              controller: controller.searchTextController,
                              onChanged: (query) => controller.searchQuery(query),
                              decoration: const InputDecoration(
                                hintText: 'Search KYC Applications',
                                prefixIcon: Icon(Iconsax.search_normal),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Data Table
                    BaakasPaginatedDataTable(
                      minWidth: 800,
                      sortAscending: controller.sortAscending.value,
                      sortColumnIndex: controller.sortColumnIndex.value,
                      columns: const [
                        DataColumn2(
                          label: Text('Seller Name'),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('PAN'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('Citizenship'),
                          size: ColumnSize.M,
                        ),
                        DataColumn2(
                          label: Text('Bank Info'),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('Status'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('Actions'),
                          size: ColumnSize.S,
                          fixedWidth: 100,
                        ),
                      ],
                      source: KYCRows(),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
} 