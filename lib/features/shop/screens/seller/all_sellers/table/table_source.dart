import 'package:baakas_admin/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../controllers/seller/seller_controller.dart';

class SellerRows extends DataTableSource {
  final controller = SellerController.instance;

  @override
  DataRow? getRow(int index) {
    final seller = controller.filteredItems[index];
    return DataRow2(
      cells: [
        DataCell(
          Row(
            children: [
              BaakasRoundedImage(
                image: seller.image,
                imageType: ImageType.network,
                width: 35,
                height: 35,
                imageUrl: seller.image,
                isNetworkImage: true,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.toNamed(BaakasRoutes.sellerDetails, arguments: seller),
                  child: Text(
                    seller.name,
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
            seller.shopName ?? 'No Shop Name',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          GestureDetector(
            onTap: () => controller.toggleFeaturedStatus(seller),
            child: Icon(
              seller.isFeatured ? Iconsax.heart5 : Iconsax.heart_slash,
              color: seller.isFeatured ? Colors.red : Colors.grey,
              size: 24,
            ),
          ),
        ),
        DataCell(Text(seller.formattedDate)),
        DataCell(
          BaakasTableActionButtons(
            onEditPressed: () => Get.toNamed(
              BaakasRoutes.editSeller,
              arguments: seller,
            ),
            onDeletePressed: () => controller.confirmAndDeleteItem(seller),
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
  int get selectedRowCount => controller.selectedRows.where((element) => element).length;
}
