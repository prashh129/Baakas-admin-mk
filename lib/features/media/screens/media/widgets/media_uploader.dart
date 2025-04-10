import 'dart:typed_data'; 
import 'package:baakas_admin/features/media/models/image_model.dart';
import 'package:baakas_admin/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart'; // Import the logger package

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/media_controller.dart';
import 'folder_dropdown.dart';

class MediaUploader extends StatelessWidget {
  final Logger logger = Logger(); // Create a logger instance

  MediaUploader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaController());
    return Obx(
      () =>
          controller.showImagesUploaderSection.value
              ? Column(
                children: [
                  BaakasRoundedContainer(
                    height: 250,
                    showBorder: true,
                    borderColor: BaakasColors.borderPrimary,
                    backgroundColor: BaakasColors.primaryBackground,
                    padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              DropzoneView(
                                mime: const ['image/jpeg', 'image/png'],
                                cursor: CursorType.Default,
                                operation: DragOperation.copy,
                                onCreated:
                                    (ctrl) =>
                                        controller.dropzoneController = ctrl,
                                onLoaded: () => logger.i('Zone loaded'),
                                onError: (ev) => logger.e('Zone error: $ev'),
                                onHover: () {
                                  logger.d('Zone hovered');
                                },
                                onLeave: () {
                                  logger.d('Zone left');
                                },
                                onDrop: (ev) async {
                                  if (ev is DropzoneFileInterface) { // Check if ev is of the correct type
                                    // Access the file data using the getFileData() method
                                    final bytes = await controller.dropzoneController.getFileData(ev);
                                    
                                    // Create an ImageModel from the DropzoneFileInterface
                                    final image = ImageModel(
                                      url: '',
                                      file: ev.file, // Accessing the file from DropzoneFileInterface
                                      folder: '',
                                      filename: ev.name, // Get the filename
                                      localImageToDisplay: Uint8List.fromList(bytes),
                                    );
                                    controller.selectedImagesToUpload.add(image);
                                  } else if (ev is String) {
                                    logger.w('Zone drop: $ev');
                                  } else {
                                    logger.w(
                                      'Zone unknown type: ${ev.runtimeType}',
                                    );
                                  }
                                },
                                onDropInvalid:
                                    (ev) => logger.w('Zone invalid MIME: $ev'),
                                onDropMultiple: (ev) async {
                                  logger.i('Zone drop multiple: $ev');
                                },
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    BaakasImages.defaultMultiImageIcon,
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(
                                    height: BaakasSizes.spaceBtwItems,
                                  ),
                                  const Text('Drag and Drop Images here'),
                                  const SizedBox(
                                    height: BaakasSizes.spaceBtwItems,
                                  ),
                                  OutlinedButton(
                                    onPressed:
                                        () => controller.selectLocalImages(),
                                    child: const Text('Select Images'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: BaakasSizes.spaceBtwItems),

                  // Show locally selected images
                  if (controller.selectedImagesToUpload.isNotEmpty)
                    BaakasRoundedContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Select Folder',
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineSmall,
                                  ),
                                  const SizedBox(
                                    width: BaakasSizes.spaceBtwItems,
                                  ),
                                  MediaFolderDropdown(
                                    onChanged: (MediaCategory? newValue) {
                                      if (newValue != null) {
                                        controller.selectedPath.value =
                                            newValue;
                                        controller.getMediaImages();
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed:
                                        () =>
                                            controller.selectedImagesToUpload
                                                .clear(),
                                    child: const Text('Remove All'),
                                  ),
                                  const SizedBox(
                                    width: BaakasSizes.spaceBtwItems,
                                  ),
                                  BaakasDeviceUtils.isMobileScreen(context)
                                      ? const SizedBox.shrink()
                                      : SizedBox(
                                        width: BaakasSizes.buttonWidth,
                                        child: ElevatedButton(
                                          onPressed:
                                              () =>
                                                  controller
                                                      .uploadImagesConfirmation(),
                                          child: const Text('Upload'),
                                        ),
                                      ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: BaakasSizes.spaceBtwSections),
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: BaakasSizes.spaceBtwItems / 2,
                            runSpacing: BaakasSizes.spaceBtwItems / 2,
                            children:
                                controller.selectedImagesToUpload
                                    .where(
                                      (image) =>
                                          image.localImageToDisplay != null,
                                    )
                                    .map(
                                      (element) => BaakasRoundedImage(
                                        width: 90,
                                        height: 90,
                                        padding: BaakasSizes.sm,
                                        imageType: ImageType.memory,
                                        memoryImage:
                                            element.localImageToDisplay,
                                        backgroundColor:
                                            BaakasColors.primaryBackground,
                                      ),
                                    )
                                    .toList(),
                          ),
                          const SizedBox(height: BaakasSizes.spaceBtwSections),
                          BaakasDeviceUtils.isMobileScreen(context)
                              ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      () =>
                                          controller.uploadImagesConfirmation(),
                                  child: const Text('Upload'),
                                ),
                              )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  const SizedBox(height: BaakasSizes.spaceBtwSections),
                ],
              )
              : const SizedBox.shrink(),
    );
  }
}

extension on DropzoneFileInterface {
  get file => null;
}
