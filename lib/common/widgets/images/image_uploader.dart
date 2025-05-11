import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import '../../../../features/media/controllers/media_controller.dart';
import '../../../../features/media/models/image_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';

/// Widget for uploading images with optional editing functionality
class BaakasImageUploader extends StatelessWidget {
  const BaakasImageUploader({
    super.key,
    required this.image,
    required this.imageType,
    this.onImageSelected,
  });

  final String? image;
  final ImageType imageType;
  final Function(String)? onImageSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final controller = Get.put(MediaController());
        List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

        if (selectedImages != null && selectedImages.isNotEmpty) {
          ImageModel selectedImage = selectedImages.first;
          if (onImageSelected != null) {
            onImageSelected!(selectedImage.url);
          }
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: BaakasColors.primary),
          borderRadius: BorderRadius.circular(BaakasSizes.borderRadiusMd),
        ),
        child: image != null && image!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(BaakasSizes.borderRadiusMd),
                child: imageType == ImageType.network
                    ? Image.network(image!, fit: BoxFit.cover)
                    : Image.asset(image!, fit: BoxFit.cover),
              )
            : const Center(
                child: Icon(Iconsax.image, color: BaakasColors.primary),
              ),
      ),
    );
  }
}
