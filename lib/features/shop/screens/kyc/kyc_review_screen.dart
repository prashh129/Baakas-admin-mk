import 'package:baakas_admin/features/shop/controllers/kyc/kyc_controller.dart';
import 'package:baakas_admin/features/shop/models/kyc_model.dart';
import 'package:baakas_admin/features/shop/screens/kyc/widgets/status_badge.dart';
import 'package:baakas_admin/utils/constants/colors.dart';
import 'package:baakas_admin/utils/constants/sizes.dart';
import 'package:baakas_admin/utils/device/device_utility.dart';
import 'package:baakas_admin/utils/helpers/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../common/widgets/layouts/templates/site_layout.dart';

class KYCReviewScreen extends StatelessWidget {
  const KYCReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaakasSiteTemplate(
      desktop: KYCReviewDesktopScreen(),
      tablet: KYCReviewTabletScreen(),
      mobile: KYCReviewMobileScreen(),
    );
  }
}

class KYCReviewDesktopScreen extends StatelessWidget {
  const KYCReviewDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = KYCController.instance;
    BaakasHelperFunctions.isDarkMode(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumbs
            const BaakasBreadcrumbsWithHeading(
          
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

class KYCReviewTabletScreen extends StatelessWidget {
  const KYCReviewTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const KYCReviewDesktopScreen();
  }
}

class KYCReviewMobileScreen extends StatelessWidget {
  const KYCReviewMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const KYCReviewDesktopScreen();
  }
}

class KYCRows extends DataTableSource {
  final controller = KYCController.instance;

  void _showImagePreview(BuildContext context, String imageUrl) {
    if (imageUrl.isEmpty) {
      Get.snackbar('Error', 'No image available');
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              errorWidget: (context, url, error) => const Center(
                child: Text('Failed to load image'),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  DataRow? getRow(int index) {
    if (controller.filteredItems.isEmpty) {
      return DataRow2(
        cells: [
          const DataCell(Text('No pending applications')),
          const DataCell(Text('')),
          const DataCell(Text('')),
          const DataCell(Text('')),
          const DataCell(Text('')),
          const DataCell(Text('')),
        ],
      );
    }

    final kyc = controller.filteredItems[index];
    return DataRow2(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(Text(
          kyc.name,
          style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: BaakasColors.primary),
        )),
        DataCell(
          GestureDetector(
            onTap: () => _showImagePreview(Get.context!, kyc.panImageUrl),
            child: kyc.panImageUrl.isEmpty
                ? const Icon(Icons.image_not_supported)
                : CachedNetworkImage(
                    imageUrl: kyc.panImageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
          ),
        ),
        DataCell(
          Row(
            children: [
              GestureDetector(
                onTap: () => _showImagePreview(Get.context!, kyc.citizenshipFrontUrl),
                child: kyc.citizenshipFrontUrl.isEmpty
                    ? const Icon(Icons.image_not_supported)
                    : CachedNetworkImage(
                        imageUrl: kyc.citizenshipFrontUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showImagePreview(Get.context!, kyc.citizenshipBackUrl),
                child: kyc.citizenshipBackUrl.isEmpty
                    ? const Icon(Icons.image_not_supported)
                    : CachedNetworkImage(
                        imageUrl: kyc.citizenshipBackUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
              ),
            ],
          ),
        ),
        DataCell(Text(
          '${kyc.bankDetails.bankName}\n${kyc.bankDetails.accountNumber}'
        )),
        DataCell(KYCStatusBadge(status: kyc.status)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: () => controller.updateKYCStatus(kyc.sellerId, KYCStatus.verified),
              ),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () => controller.updateKYCStatus(kyc.sellerId, KYCStatus.declined),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.isEmpty ? 1 : controller.filteredItems.length;

  @override
  int get selectedRowCount => controller.selectedRows.where((selected) => selected).length;
}
