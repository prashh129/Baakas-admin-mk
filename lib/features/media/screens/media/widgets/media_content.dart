import 'package:baakas_admin/common/widgets/loaders/loader_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/media_controller.dart';
import '../../../models/image_model.dart';
import 'view_image_details.dart';

class MediaContent extends StatelessWidget {
  MediaContent({
    super.key,
    this.allowSelection = false,
    this.allowMultipleSelection = false,
    this.onImagesSelected,
    this.alreadySelectedUrls,
  });

  final bool allowSelection;
  final bool allowMultipleSelection;
  final List<String>? alreadySelectedUrls;
  final List<ImageModel> selectedImages = [];
  final Function(List<ImageModel> selectedImages)? onImagesSelected;

  @override
  Widget build(BuildContext context) {
    bool loadedPreviousSelection = false;
    final controller = Get.put(MediaController());
    return BaakasRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Media Images Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Media Folders',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: BaakasSizes.spaceBtwItems),

                  // Media Dropdown
                  _buildMediaDropdown(controller),
                ],
              ),

              // Add Selected Images Button
              if (allowSelection) buildAddSelectedImagesButton(),
            ],
          ),
          const SizedBox(height: BaakasSizes.spaceBtwSections),

          // Show Media
          Obx(() {
            // Get Selected Folder Images
            List<ImageModel> images = _getSelectedFolderImages(controller);

            // Load Selected Images from the Already Selected Images only once otherwise
            // on Obx() rebuild UI first images will be selected then will auto un check.
            if (!loadedPreviousSelection) {
              if (alreadySelectedUrls != null &&
                  alreadySelectedUrls!.isNotEmpty) {
                // Convert alreadySelectedUrls to a Set for faster lookup
                final selectedUrlsSet = Set<String>.from(alreadySelectedUrls!);

                for (var image in images) {
                  image.isSelected.value = selectedUrlsSet.contains(image.url);
                  if (image.isSelected.value) {
                    selectedImages.add(image);
                  }
                }
              } else {
                // If alreadySelectedUrls is null or empty, set all images to not selected
                for (var image in images) {
                  image.isSelected.value = false;
                }
              }
              loadedPreviousSelection = true;
            }

            // Loader
            if (controller.loading.value && images.isEmpty) {
              return loaderToFetchImages();
            }

            // Empty Widget
            if (images.isEmpty) return _buildEmptyAnimationWidget(context);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: BaakasSizes.spaceBtwItems,
                  runSpacing: BaakasSizes.spaceBtwItems,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children:
                      images
                          .map(
                            (image) => GestureDetector(
                              onTap: () => Get.dialog(ImagePopup(image: image)),
                              child: SizedBox(
                                width: 140,
                                height: 180,
                                child: Column(
                                  children: [
                                    allowSelection
                                        ? _buildListWithCheckbox(image)
                                        : _buildSimpleList(image),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: BaakasSizes.sm,
                                        ),
                                        child: Text(
                                          image.filename,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),

                // Load More Button -> Show when all images loaded
                if (!controller.loading.value)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: BaakasSizes.spaceBtwSections,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: BaakasSizes.buttonWidth,
                          child: ElevatedButton.icon(
                            onPressed: () => controller.loadMoreMediaImages(),
                            label: const Text('Load More'),
                            icon: const Icon(Iconsax.arrow_down),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (controller.loading.value) loaderToFetchImages(),
              ],
            );
          }),
        ],
      ),
    );
  }

  Padding loaderToFetchImages() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: BaakasSizes.defaultSpace * 2),
      child: Column(
        children: [
          BaakasLoaderAnimation(height: 200, width: 200),
          SizedBox(height: BaakasSizes.spaceBtwSections),
          Text('Loading Images....'),
        ],
      ),
    );
  }

  Padding _buildEmptyAnimationWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BaakasSizes.lg * 3),
      child: BaakasAnimationLoaderWidget(
        width: 300,
        height: 300,
        text: 'Select your Desired Folder',
        animation: BaakasImages.mediaIllustration,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  List<ImageModel> _getSelectedFolderImages(MediaController controller) {
    List<ImageModel> images = [];
    if (controller.selectedPath.value == MediaCategory.banners) {
      images =
          controller.allBannerImages
              .where((image) => image.url.isNotEmpty)
              .toList();
    } else if (controller.selectedPath.value == MediaCategory.sellers) {
      images =
          controller.allSellerImages
              .where((image) => image.url.isNotEmpty)
              .toList();
    } else if (controller.selectedPath.value == MediaCategory.categories) {
      images =
          controller.allCategoryImages
              .where((image) => image.url.isNotEmpty)
              .toList();
    } else if (controller.selectedPath.value == MediaCategory.products) {
      images =
          controller.allProductImages
              .where((image) => image.url.isNotEmpty)
              .toList();
    } else if (controller.selectedPath.value == MediaCategory.users) {
      images =
          controller.allUserImages
              .where((image) => image.url.isNotEmpty)
              .toList();
    }
    return images;
  }

  Widget buildAddSelectedImagesButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Close Button
        SizedBox(
          width: 120,
          child: OutlinedButton.icon(
            label: const Text('Close'),
            icon: const Icon(Iconsax.close_circle),
            onPressed: () => Get.back(),
          ),
        ),
        const SizedBox(width: BaakasSizes.spaceBtwItems),
        SizedBox(
          width: 120,
          child: ElevatedButton.icon(
            label: const Text('Add'),
            icon: const Icon(Iconsax.image),
            onPressed: () {
              // if (alreadySelectedUrls != null) alreadySelectedUrls!.clear();
              //
              // // Create a copy of the selected images to send back
              // List<ImageModel> selectedImagesCopy = List.from(selectedImages);
              //
              // for (var image in selectedImages) {
              //   image.isSelected.value = false;
              // }
              //
              // // Before calling Get.back, clear the selectedImages
              // selectedImages.clear();

              // Now call Get.back with the result
              Get.back(result: selectedImages);
            },
          ),
        ),
      ],
    );
  }

  Obx _buildMediaDropdown(MediaController controller) {
    return Obx(
      () => SizedBox(
        width: 180,
        child: DropdownButtonFormField<MediaCategory>(
          isExpanded: true,
          value: controller.selectedPath.value,
          onChanged: (MediaCategory? newValue) {
            if (newValue != null) {
              for (var image in selectedImages) {
                image.isSelected.value = false;
              }
              selectedImages.clear();

              controller.selectedPath.value = newValue;
              controller.getMediaImages();
            }
          },
          items: MediaCategory.values.map((category) {
            return DropdownMenuItem<MediaCategory>(
              value: category,
              child: Text(
                category.name.capitalize.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSimpleList(ImageModel image) {
    return BaakasRoundedImage(
      width: 140,
      height: 140,
      padding: BaakasSizes.sm,
      image: image.url,
      imageType: ImageType.network,
      margin: BaakasSizes.spaceBtwItems / 2,
      backgroundColor: BaakasColors.primaryBackground,
      imageUrl: image.url,
      isNetworkImage: true,
    );
  }

  Widget _buildListWithCheckbox(ImageModel image) {
    return Stack(
      children: [
        BaakasRoundedImage(
          width: 140,
          height: 140,
          padding: BaakasSizes.sm,
          image: image.url,
          imageType: ImageType.network,
          margin: BaakasSizes.spaceBtwItems / 2,
          backgroundColor: BaakasColors.primaryBackground,
          imageUrl: image.url,
          isNetworkImage: true,
        ),
        Positioned(
          top: BaakasSizes.md,
          right: BaakasSizes.md,
          child: Obx(
            () => Checkbox(
              value: image.isSelected.value,
              onChanged: (selected) {
                // If selection is allowed, toggle the selected state
                if (selected != null) {
                  image.isSelected.value = selected;
                  if (image.isSelected.value) {
                    if (!allowMultipleSelection) {
                      // If multiple selection is not allowed, uncheck other checkboxes
                      for (var otherImage in selectedImages) {
                        if (otherImage != image) {
                          otherImage.isSelected.value = false;
                        }
                      }
                      selectedImages.clear();
                    }

                    selectedImages.add(image);
                  } else {
                    selectedImages.remove(image);
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
