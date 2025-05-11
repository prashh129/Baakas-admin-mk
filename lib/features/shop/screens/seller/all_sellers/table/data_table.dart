import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../controllers/seller/seller_controller.dart';
import 'table_source.dart';

class SellerTable extends StatelessWidget {
  const SellerTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellerController());
    return Obx(
      () {
        // Categories & Selected Rows are Hidden => Just to update the UI => Obx => [ProductRows]
        Visibility(
            visible: false,
            child: Text(controller.filteredItems.length.toString()));
        Visibility(
            visible: false,
            child: Text(controller.selectedRows.length.toString()));

        final lgTable = controller.filteredItems.any((element) =>
            element.sellerCategories != null &&
            element.sellerCategories!.length > 2);
        // Table
        return BaakasPaginatedDataTable(
          minWidth: 700,
          dataRowHeight: lgTable ? 96 : 64,
          tableHeight: lgTable ? 96 * 11.5 : 760,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          columns: [
            DataColumn2(
                label: const Text('Seller'),
                fixedWidth:
                    BaakasDeviceUtils.isMobileScreen(Get.context!) ? null : 180,
                onSort: (columnIndex, ascending) =>
                    controller.sortByName(columnIndex, ascending)),
            const DataColumn2(label: Text('Seller Name')),
            DataColumn2(
                label: const Text('Featured'),
                fixedWidth: BaakasDeviceUtils.isMobileScreen(Get.context!)
                    ? null
                    : 120),
            DataColumn2(
                label: const Text('Date'),
                fixedWidth: BaakasDeviceUtils.isMobileScreen(Get.context!)
                    ? null
                    : 120),
            DataColumn2(
                label: const Text('Action'),
                fixedWidth: BaakasDeviceUtils.isMobileScreen(Get.context!)
                    ? null
                    : 120),
          ],
          source: SellerRows(),
        );
      },
    );
  }
}
