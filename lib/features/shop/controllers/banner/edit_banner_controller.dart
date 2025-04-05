import 'package:baakas_admin/features/shop/controllers/banner/banner_controller.dart';
import 'package:baakas_admin/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/banners/banners_repository.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';
import '../../models/banner_model.dart';

class EditBannerController extends GetxController {
  static EditBannerController get instance => Get.find();

  final imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final targetScreen = ''.obs;
  final formKey = GlobalKey<FormState>();
  final repository = Get.put(BannerRepository());

  /// Init Data
  void init(BannerModel banner) {
    imageURL.value = banner.imageUrl;
    isActive.value = banner.active;
    targetScreen.value = banner.targetScreen;
  }

  /// Pick Thumbnail Image from Media
  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    // Handle the selected images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      // Set the selected image to the main image or perform any other action
      ImageModel selectedImage = selectedImages.first;
      // Update the main image using the selectedImage
      imageURL.value = selectedImage.url;
    }
  }

  /// Register new Banner
  Future<void> updateBanner(BannerModel banner) async {
    try {
      // Start Loading
      BaakasFullScreenLoader.popUpCircular();

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        BaakasFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        BaakasFullScreenLoader.stopLoading();
        return;
      }

      // Is Data Updated
      if (banner.imageUrl != imageURL.value ||
          banner.targetScreen != targetScreen.value ||
          banner.active != isActive.value) {
        // Map Data
        banner.imageUrl = imageURL.value;
        banner.targetScreen = targetScreen.value;
        banner.active = isActive.value;

        // Call Repository to Update
        await repository.updateBanner(banner);
      }

      // Update the List
      BannerController.instance.updateItemFromLists(banner);

      // Update UI Listeners
      update();

      // Remove Loader
      BaakasFullScreenLoader.stopLoading();

      // Success Message & Redirect
      BaakasLoaders.successSnackBar(
        title: 'Congratulations',
        message: 'Your Record has been updated.',
      );
    } catch (e) {
      BaakasFullScreenLoader.stopLoading();
      BaakasLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
