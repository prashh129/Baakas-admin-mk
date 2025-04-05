import 'package:baakas_admin/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/banner/banner_controller.dart';

class BannersRows extends DataTableSource {
  final controller = BannerController.instance;

  @override
  DataRow? getRow(int index) {
    final banner = controller.filteredItems[index];
    return DataRow2(
      selected: controller.selectedRows[index],
      onTap: () => Get.toNamed(BaakasRoutes.editBanner, arguments: banner),
      onSelectChanged:
          (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          BaakasRoundedImage(
            width: 180,
            height: 100,
            padding: BaakasSizes.sm,
            image: banner.imageUrl,
            imageType: ImageType.network,
            borderRadius: BaakasSizes.borderRadiusMd,
            backgroundColor: BaakasColors.primaryBackground,
          ),
        ),
        DataCell(Text(controller.formatRoute(banner.targetScreen))),
        DataCell(
          banner.active
              ? const Icon(Iconsax.eye, color: BaakasColors.primary)
              : const Icon(Iconsax.eye_slash),
        ),
        DataCell(
          BaakasTableActionButtons(
            onEditPressed:
                () => Get.toNamed(BaakasRoutes.editBanner, arguments: banner),
            onDeletePressed: () => controller.confirmAndDeleteItem(banner),
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
