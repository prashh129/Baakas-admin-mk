import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../../utils/constants/colors.dart';
import '../controllers/product/product_controller.dart';

class ProductsTable extends StatelessWidget {
  final String status;
  const ProductsTable({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Obx(
      () {
        final filtered = controller.allItems.where((p) => p.status.toLowerCase() == status).toList();
        // Track state changes
        filtered.length;
        controller.selectedRows.length;

        return SizedBox(
          width: double.infinity,
          child: BaakasPaginatedDataTable(
            minWidth: 700,
            dataRowHeight: 64,
            tableHeight: 760,
            sortAscending: controller.sortAscending.value,
            sortColumnIndex: controller.sortColumnIndex.value,
            columns: [
              DataColumn2(
                label: const Text('Product'),
                fixedWidth: BaakasDeviceUtils.isMobileScreen(Get.context!) ? null : 180,
                onSort: (columnIndex, ascending) => controller.sortByName(columnIndex, ascending),
              ),
              DataColumn2(
                label: const Text('Category'),
                fixedWidth: BaakasDeviceUtils.isMobileScreen(Get.context!) ? null : 120,
              ),
              DataColumn2(
                label: const Text('Price'),
                fixedWidth: BaakasDeviceUtils.isMobileScreen(Get.context!) ? null : 120,
                onSort: (columnIndex, ascending) => controller.sortByPrice(columnIndex, ascending),
              ),
              DataColumn2(
                label: const Text('Status'),
                fixedWidth: BaakasDeviceUtils.isMobileScreen(Get.context!) ? null : 120,
                onSort: (columnIndex, ascending) => controller.sortByApprovalStatus(columnIndex, ascending),
              ),
              DataColumn2(
                label: const Text('Actions'),
                fixedWidth: BaakasDeviceUtils.isMobileScreen(Get.context!) ? null : 120,
              ),
            ],
            source: ProductRows(filtered),
          ),
        );
      },
    );
  }
}

class ProductRows extends DataTableSource {
  final List<dynamic> filtered;
  final controller = ProductController.instance;
  ProductRows(this.filtered);

  @override
  DataRow? getRow(int index) {
    final product = filtered[index];
    return DataRow2(
      cells: [
        DataCell(
          Row(
            children: [
              if (product.thumbnail.isNotEmpty)
                BaakasRoundedImage(
                  image: product.thumbnail,
                  imageType: ImageType.network,
                  width: 35,
                  height: 35,
                  imageUrl: product.thumbnail,
                  isNetworkImage: true,
                ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.toNamed(BaakasRoutes.editProduct, arguments: product),
                  child: Text(
                    product.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(
                      color: BaakasColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            product.category,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: Theme.of(Get.context!).textTheme.bodyLarge,
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(product.status),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              product.status,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(
          BaakasTableActionButtons(
            onEditPressed: () => Get.toNamed(
              BaakasRoutes.editProduct,
              arguments: product,
            ),
            onDeletePressed: () => controller.confirmAndDeleteItem(product),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filtered.length;

  @override
  int get selectedRowCount => controller.selectedRows.where((element) => element).length;
} 