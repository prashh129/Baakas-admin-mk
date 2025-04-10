import 'package:baakas_admin/routes/routes.dart';
import 'package:baakas_admin/utils/constants/enums.dart' show ImageType;
import 'package:baakas_admin/utils/constants/image_strings.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart'
    show BaakasRoundedImage;
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/product_controller.dart';

class ProductsRows extends DataTableSource {
  final controller = ProductController.instance;

  @override
  DataRow? getRow(int index) {
    final product = controller.filteredItems[index];
    return DataRow2(
      selected: controller.selectedRows[index],
      onTap: () => Get.toNamed(BaakasRoutes.editProduct, arguments: product),
      onSelectChanged:
          (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Row(
            children: [
              BaakasRoundedImage(
                width: 50,
                height: 50,
                padding: BaakasSizes.xs,
                image: product.thumbnail,
                imageType: ImageType.network,
                borderRadius: BaakasSizes.borderRadiusMd,
                backgroundColor: BaakasColors.primaryBackground,
              ),
              const SizedBox(width: BaakasSizes.spaceBtwItems),
              Flexible(
                child: Text(
                  product.title,
                  style: Theme.of(
                    Get.context!,
                  ).textTheme.bodyLarge!.apply(color: BaakasColors.primary),
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(controller.getProductStockTotal(product))),
        DataCell(Text(controller.getProductSoldQuantity(product))),
        DataCell(
          Row(
            children: [
              BaakasRoundedImage(
                width: 35,
                height: 35,
                padding: BaakasSizes.xs,
                borderRadius: BaakasSizes.borderRadiusMd,
                backgroundColor: BaakasColors.primaryBackground,
                imageType:
                    product.brand != null ? ImageType.network : ImageType.asset,
                image:
                    product.brand != null
                        ? product.brand!.image
                        : BaakasImages.defaultImage,
              ),
              const SizedBox(width: BaakasSizes.spaceBtwItems),
              Flexible(
                child: Text(
                  product.brand != null ? product.brand!.name : '',
                  style: Theme.of(
                    Get.context!,
                  ).textTheme.bodyLarge!.apply(color: BaakasColors.primary),
                ),
              ),
            ],
          ),
        ),
        DataCell(Text('Rs ${controller.getProductPrice(product)}')),
        DataCell(Text(product.formattedDate)),
        DataCell(
          BaakasTableActionButtons(
            onEditPressed:
                () => Get.toNamed(BaakasRoutes.editProduct, arguments: product),
            onDeletePressed: () => controller.confirmAndDeleteItem(product),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
