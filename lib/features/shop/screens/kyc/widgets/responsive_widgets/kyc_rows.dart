import 'package:baakas_admin/features/shop/controllers/kyc/kyc_controller.dart';
import 'package:baakas_admin/features/shop/models/kyc_model.dart';
import 'package:baakas_admin/features/shop/screens/kyc/widgets/status_badge.dart';
import 'package:baakas_admin/utils/constants/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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