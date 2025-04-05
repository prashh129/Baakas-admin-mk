import 'package:baakas_admin/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../controllers/media_controller.dart';
import '../widgets/media_content.dart';
import '../widgets/media_uploader.dart';

class MediaDesktopScreen extends StatelessWidget {
  const MediaDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Breadcrumbs
                  const BaakasBreadcrumbsWithHeading(
                    heading: 'Media',
                    breadcrumbItems: ['Media'],
                  ),
                  SizedBox(
                    width: BaakasSizes.buttonWidth * 1.5,
                    child: ElevatedButton.icon(
                      onPressed:
                          () =>
                              controller.showImagesUploaderSection.value =
                                  !controller.showImagesUploaderSection.value,
                      icon: const Icon(Iconsax.cloud_add),
                      label: const Text('Upload Images'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: BaakasSizes.spaceBtwSections),

              /// Upload Area
              MediaUploader(),

              /// Media
              MediaContent(),
            ],
          ),
        ),
      ),
    );
  }
}
