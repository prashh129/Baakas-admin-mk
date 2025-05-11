import 'package:baakas_admin/features/shop/controllers/order/order_controller.dart';
import 'package:baakas_admin/utils/constants/sizes.dart';
import 'package:baakas_admin/utils/helpers/helper_functions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../../../../utils/device/device_utility.dart';
import 'table_source.dart';

class DashboardOrderTable extends StatelessWidget {
  const DashboardOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderController.instance;
    BaakasHelperFunctions.isDarkMode(context);

    return Obx(() {
      // Orders & Selected Rows are Hidden => Just to update the UI => Obx => [OrderRows]
      Visibility(
        visible: false,
        child: Text(controller.filteredItems.length.toString()),
      );
      Visibility(
        visible: false,
        child: Text(controller.selectedRows.length.toString()),
      );

      // Table
      return Column(
        children: [
          // Search Header
          Row(
            children: [
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
          ),
          const SizedBox(height: BaakasSizes.spaceBtwItems),
          
          // Table
          BaakasPaginatedDataTable(
            minWidth: 600,
            sortAscending: controller.sortAscending.value,
            sortColumnIndex: controller.sortColumnIndex.value,
            columns: [
              const DataColumn2(
                label: Text('Order ID'),
                size: ColumnSize.L,
              ),
              const DataColumn2(
                label: Text('Items'),
                size: ColumnSize.S,
              ),
              const DataColumn2(
                label: Text('Buyer'),
                size: ColumnSize.L,
              ),
              const DataColumn2(
                label: Text('Seller'),
                size: ColumnSize.L,
              ),
              const DataColumn2(
                label: Text('Status'),
                size: ColumnSize.M,
              ),
              const DataColumn2(
                label: Text('Amount'),
                size: ColumnSize.S,
              ),
              const DataColumn2(
                label: Text('Date'),
                size: ColumnSize.L,
              ),
              const DataColumn2(
                label: Text('Action'),
                size: ColumnSize.S,
                fixedWidth: 100,
              ),
            ],
            source: OrderRows(),
          ),
        ],
      );
    });
  }
}
