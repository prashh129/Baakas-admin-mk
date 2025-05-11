import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/product_images_controller.dart';

class ProductThumbnailImage extends StatelessWidget {
  const ProductThumbnailImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProductImagesController controller =
        Get.put(ProductImagesController());

    return BaakasRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Thumbnail Text
          Text('Product Thumbnail',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: BaakasSizes.spaceBtwItems),

          // Container for Product Thumbnail
          BaakasRoundedContainer(
            height: 300,
            backgroundColor: BaakasColors.primaryBackground,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Thumbnail Image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Obx(
                          () => BaakasRoundedImage(
                            width: 220,
                            height: 220,
                            image: controller.selectedThumbnailImageUrl.value ??
                                BaakasImages.defaultSingleImageIcon,
                            imageType:
                                controller.selectedThumbnailImageUrl.value ==
                                        null
                                    ? ImageType.asset
                                    : ImageType.network,
                            imageUrl: controller.selectedThumbnailImageUrl.value ??
                                BaakasImages.defaultSingleImageIcon,
                            isNetworkImage: controller.selectedThumbnailImageUrl.value != null,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Add Thumbnail Button
                  SizedBox(
                    width: 200,
                    child: OutlinedButton(
                      onPressed: () => controller.selectThumbnailImage(),
                      child: const Text('Add Thumbnail'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
