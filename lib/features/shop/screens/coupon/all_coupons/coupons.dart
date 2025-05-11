
import 'package:baakas_admin/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/helpers/helper_functions.dart';


class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaakasSiteTemplate(
      desktop: CouponsDesktopScreen(),
      tablet: CouponsTabletScreen(),
      mobile: CouponsMobileScreen(),
    );
  }
}

class CouponsDesktopScreen extends StatelessWidget {
  const CouponsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CouponController.instance;
    final isDark = BaakasHelperFunctions.isDarkMode(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumbs
            const BaakasBreadcrumbsWithHeading(
             
              heading: 'Coupons',
              breadcrumbItems: [BaakasRoutes.coupons,],
            ),
            const SizedBox(height: BaakasSizes.spaceBtwSections),

      

            // Table Body
            Obx(() {
              if (controller.isCouponLoading) {
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
                                hintText: 'Search Coupons',
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
                          label: Text('Coupon Code'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('Discount'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('Min Purchase'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('Max Discount'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('Valid From'),
                          size: ColumnSize.M,
                        ),
                        DataColumn2(
                          label: Text('Expires On'),
                          size: ColumnSize.M,
                        ),
                        DataColumn2(
                          label: Text('Used By'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('Actions'),
                          size: ColumnSize.S,
                          fixedWidth: 100,
                        ),
                      ],
                      source: CouponRows(),
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

class CouponsTabletScreen extends StatelessWidget {
  const CouponsTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CouponsDesktopScreen();
  }
}

class CouponsMobileScreen extends StatelessWidget {
  const CouponsMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CouponsDesktopScreen();
  }
}

class CouponRows extends DataTableSource {
  final controller = CouponController.instance;

  @override
  DataRow? getRow(int index) {
    if (controller.filteredCoupons.isEmpty) {
      return DataRow2(
        cells: [
          const DataCell(Text('No coupons found')),
          const DataCell(Text('')),
          const DataCell(Text('')),
          const DataCell(Text('')),
          const DataCell(Text('')),
          const DataCell(Text('')),
          const DataCell(Text('')),
          const DataCell(Text('')),
        ],
      );
    }

    final coupon = controller.filteredCoupons[index];
    return DataRow2(
      cells: [
        DataCell(Text(coupon.code)),
        DataCell(Text(
          coupon.discountType == 'percentage'
              ? "${coupon.discountValue}%"
              : "Rs ${coupon.discountValue}",
        )),
        DataCell(Text("Rs ${coupon.minimumPurchase}")),
        DataCell(Text(coupon.maximumDiscount != null ? "Rs ${coupon.maximumDiscount}" : "-")),
        DataCell(Text(_formatDate(coupon.validFrom))),
        DataCell(Text(_formatDate(coupon.expiresOn))),
        DataCell(Text(coupon.usedBy.length.toString())),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () => controller.deleteCoupon(coupon.id),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredCoupons.isEmpty ? 1 : controller.filteredCoupons.length;

  @override
  int get selectedRowCount => 0;
}
