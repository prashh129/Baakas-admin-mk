import 'package:baakas_admin/features/shop/models/seller_category_model.dart';
import 'package:baakas_admin/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/sellers/seller_repository.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';
import '../../models/seller_model.dart';
import '../../models/category_model.dart';
import '../seller/seller_controller.dart';

class CreateSellerController extends GetxController {
  static CreateSellerController get instance => Get.find();

  final loading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final List<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  /// Toggle Category Selection
  void toggleSelection(CategoryModel category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }

    update();
  }

  /// Method to reset fields
  void resetFields() {
    name.clear();
    loading(false);
    isFeatured(false);
    imageURL.value = '';
    selectedCategories.clear();
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

  /// Register new Seller
  Future<void> createSeller() async {
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

      // Map Data
      final newRecord = SellerModel(
        id: '',
        productsCount: 0,
        image: imageURL.value,
        name: name.text.trim(),
        createdAt: DateTime.now(),
        isFeatured: isFeatured.value,
      );

      // Call Repository to Create New Seller
      newRecord.id = await SellerRepository.instance.createSeller(newRecord);

      // Register seller categories if any
      if (selectedCategories.isNotEmpty) {
        if (newRecord.id.isEmpty) {
          throw 'Error storing relational data. Try again';
        }

        // Loop selected Seller Categories
        for (var category in selectedCategories) {
          // Map Data
          final sellerCategory = SellerCategoryModel(
            sellerId: newRecord.id,
            categoryId: category.id,
          );
          await SellerRepository.instance.createSellerCategory(sellerCategory);
        }

        newRecord.sellerCategories ??= [];
        newRecord.sellerCategories!.addAll(selectedCategories);
      }

      // Update All Data list
      SellerController.instance.addItemToLists(newRecord);

      // Update UI Listeners
      update();

      // Reset Form
      resetFields();

      // Remove Loader
      BaakasFullScreenLoader.stopLoading();

      // Success Message & Redirect
      BaakasLoaders.successSnackBar(
        title: 'Congratulations',
        message: 'New Record has been added.',
      );
    } catch (e) {
      BaakasFullScreenLoader.stopLoading();
      BaakasLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
