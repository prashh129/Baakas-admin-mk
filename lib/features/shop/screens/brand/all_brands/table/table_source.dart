import 'package:baakas_admin/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:baakas_admin/utils/device/device_utility.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/brand/brand_controller.dart';

class BrandRows extends DataTableSource {
  final controller = BrandController.instance;

  @override
  DataRow? getRow(int index) {
    final brand = controller.filteredItems[index];
    return DataRow2(
      selected: controller.selectedRows[index],
      onSelectChanged:
          (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Row(
            children: [
              BaakasRoundedImage(
                width: 50,
                height: 50,
                padding: BaakasSizes.sm,
                image: brand.image,
                imageType: ImageType.network,
                borderRadius: BaakasSizes.borderRadiusMd,
                backgroundColor: BaakasColors.primaryBackground,
              ),
              const SizedBox(width: BaakasSizes.spaceBtwItems),
              Expanded(
                child: Text(
                  brand.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    Get.context!,
                  ).textTheme.bodyLarge!.apply(color: BaakasColors.primary),
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: BaakasSizes.sm),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: BaakasSizes.xs,
                direction:
                    BaakasDeviceUtils.isMobileScreen(Get.context!)
                        ? Axis.vertical
                        : Axis.horizontal,
                children:
                    brand.brandCategories != null
                        ? brand.brandCategories!
                            .map(
                              (e) => Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      BaakasDeviceUtils.isMobileScreen(
                                            Get.context!,
                                          )
                                          ? 0
                                          : BaakasSizes.xs,
                                ),
                                child: Chip(
                                  label: Text(e.name),
                                  padding: const EdgeInsets.all(BaakasSizes.xs),
                                ),
                              ),
                            )
                            .toList()
                        : [const SizedBox()],
              ),
            ),
          ),
        ),
        DataCell(
          brand.isFeatured
              ? const Icon(Iconsax.heart5, color: BaakasColors.primary)
              : const Icon(Iconsax.heart),
        ),
        DataCell(Text(brand.createdAt != null ? brand.formattedDate : '')),
        DataCell(
          BaakasTableActionButtons(
            onEditPressed:
                () => Get.toNamed(BaakasRoutes.editBrand, arguments: brand),
            onDeletePressed: () => controller.confirmAndDeleteItem(brand),
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
