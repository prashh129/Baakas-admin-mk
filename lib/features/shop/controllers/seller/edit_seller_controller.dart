import 'package:baakas_admin/data/repositories/product/product_repository.dart';
import 'package:baakas_admin/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baakas_admin/utils/constants/enums.dart';

import '../../../../data/repositories/sellers/seller_repository.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';
import '../../models/seller_category_model.dart';
import '../../models/seller_model.dart';
import '../../models/category_model.dart';
import '../seller/seller_controller.dart';

class EditSellerController extends GetxController {
  static EditSellerController get instance => Get.find();

  final loading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  
  // Basic Info
  final name = TextEditingController();
  
  // Contact Information
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final businessAddress = TextEditingController();
  final website = TextEditingController();
  final socialMediaLinks = <String, String>{}.obs;
  
  // Business Details
  final businessRegistrationNumber = TextEditingController();
  final businessType = TextEditingController();
  final businessDescription = TextEditingController();
  final yearsInBusiness = TextEditingController();
  final businessHours = <String, String>{}.obs;
  
  // Bank Details
  final bankAccountNumber = TextEditingController();
  final bankName = TextEditingController();
  final bankBranch = TextEditingController();
  final accountHolder = TextEditingController();
  final ifscCode = TextEditingController();
  final accountType = TextEditingController();
  final businessPanNumber = TextEditingController();
  
  // Document Management
  RxString citizenshipImageURL = ''.obs;
  RxString businessPanImageURL = ''.obs;
  Rx<DateTime?> citizenshipExpiryDate = Rx<DateTime?>(null);
  Rx<DateTime?> panExpiryDate = Rx<DateTime?>(null);
  RxString documentVerificationStatus = 'pending'.obs;
  RxList<Map<String, dynamic>> documentHistory = <Map<String, dynamic>>[].obs;
  
  final formKey = GlobalKey<FormState>();
  final repository = Get.put(SellerRepository());
  final List<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  /// Init Data
  void init(SellerModel seller) {
    // Basic Info
    name.text = seller.name;
    imageURL.value = seller.image;
    isFeatured.value = seller.isFeatured;
    
    // Contact Information
    phoneNumber.text = seller.phoneNumber ?? '';
    email.text = seller.email ?? '';
    businessAddress.text = seller.businessAddress ?? '';
    website.text = seller.website ?? '';
    socialMediaLinks.value = seller.socialMediaLinks ?? {};
    
    // Business Details
    businessRegistrationNumber.text = seller.businessRegistrationNumber ?? '';
    businessType.text = seller.businessType ?? '';
    businessDescription.text = seller.businessDescription ?? '';
    yearsInBusiness.text = seller.yearsInBusiness?.toString() ?? '';
    businessHours.value = seller.businessHours ?? {};
    
    // Bank Details
    bankAccountNumber.text = seller.bankAccountNumber ?? '';
    bankName.text = seller.bankName ?? '';
    bankBranch.text = seller.bankBranch ?? '';
    accountHolder.text = seller.accountHolder ?? '';
    ifscCode.text = seller.ifscCode ?? '';
    accountType.text = seller.accountType ?? '';
    businessPanNumber.text = seller.businessPanNumber ?? '';
    
    // Document Management
    citizenshipImageURL.value = seller.citizenshipImage ?? '';
    businessPanImageURL.value = seller.businessPanImage ?? '';
    citizenshipExpiryDate.value = seller.citizenshipExpiryDate;
    panExpiryDate.value = seller.panExpiryDate;
    documentVerificationStatus.value = seller.documentVerificationStatus ?? 'pending';
    documentHistory.value = seller.documentHistory ?? [];
    
    if (seller.sellerCategories != null) {
      selectedCategories.addAll(seller.sellerCategories ?? []);
    }
  }

  /// Toggle Category Selection
  void toggleSelection(CategoryModel category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  /// Method to reset fields
  void resetFields() {
    // Basic Info
    name.clear();
    loading(false);
    isFeatured(false);
    imageURL.value = '';
    
    // Contact Information
    phoneNumber.clear();
    email.clear();
    businessAddress.clear();
    website.clear();
    socialMediaLinks.clear();
    
    // Business Details
    businessRegistrationNumber.clear();
    businessType.clear();
    businessDescription.clear();
    yearsInBusiness.clear();
    businessHours.clear();
    
    // Bank Details
    bankAccountNumber.clear();
    bankName.clear();
    bankBranch.clear();
    accountHolder.clear();
    ifscCode.clear();
    accountType.clear();
    businessPanNumber.clear();
    
    // Document Management
    citizenshipImageURL.value = '';
    businessPanImageURL.value = '';
    citizenshipExpiryDate.value = null;
    panExpiryDate.value = null;
    documentVerificationStatus.value = 'pending';
    documentHistory.clear();
    
    selectedCategories.clear();
  }

  /// Pick Thumbnail Image from Media
  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      imageURL.value = selectedImage.url;
    }
  }

  /// Pick Citizenship Image from Media
  void pickCitizenshipImage() async {
    final controller = Get.put(MediaController());
    controller.selectedPath.value = MediaCategory.sellerDocuments;
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      citizenshipImageURL.value = selectedImage.url;
      
      // Add to document history
      documentHistory.add({
        'type': 'citizenship',
        'url': selectedImage.url,
        'uploadedAt': DateTime.now(),
        'status': 'pending',
      });
    }
  }

  /// Pick Business PAN Image from Media
  void pickBusinessPanImage() async {
    final controller = Get.put(MediaController());
    controller.selectedPath.value = MediaCategory.sellerDocuments;
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      businessPanImageURL.value = selectedImage.url;
      
      // Add to document history
      documentHistory.add({
        'type': 'pan',
        'url': selectedImage.url,
        'uploadedAt': DateTime.now(),
        'status': 'pending',
      });
    }
  }

  /// Update Seller
  Future<void> updateSeller(SellerModel seller) async {
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

      // Validate required documents
      if (citizenshipImageURL.value.isEmpty) {
        BaakasFullScreenLoader.stopLoading();
        BaakasLoaders.warningSnackBar(
          title: 'Missing Document',
          message: 'Please upload citizenship document',
        );
        return;
      }

      if (businessPanImageURL.value.isEmpty) {
        BaakasFullScreenLoader.stopLoading();
        BaakasLoaders.warningSnackBar(
          title: 'Missing Document',
          message: 'Please upload business PAN document',
        );
        return;
      }

      // Update seller details
      seller.name = name.text.trim();
      seller.image = imageURL.value;
      seller.isFeatured = isFeatured.value;
      
      // Contact Information
      seller.phoneNumber = phoneNumber.text.trim();
      seller.email = email.text.trim();
      seller.businessAddress = businessAddress.text.trim();
      seller.website = website.text.trim();
      seller.socialMediaLinks = socialMediaLinks;
      
      // Business Details
      seller.businessRegistrationNumber = businessRegistrationNumber.text.trim();
      seller.businessType = businessType.text.trim();
      seller.businessDescription = businessDescription.text.trim();
      seller.yearsInBusiness = int.tryParse(yearsInBusiness.text);
      seller.businessHours = businessHours;
      
      // Bank Details
      seller.bankAccountNumber = bankAccountNumber.text.trim();
      seller.bankName = bankName.text.trim();
      seller.bankBranch = bankBranch.text.trim();
      seller.accountHolder = accountHolder.text.trim();
      seller.ifscCode = ifscCode.text.trim();
      seller.accountType = accountType.text.trim();
      seller.businessPanNumber = businessPanNumber.text.trim();
      
      // Document Management
      seller.citizenshipImage = citizenshipImageURL.value;
      seller.businessPanImage = businessPanImageURL.value;
      seller.citizenshipExpiryDate = citizenshipExpiryDate.value;
      seller.panExpiryDate = panExpiryDate.value;
      seller.documentVerificationStatus = documentVerificationStatus.value;
      seller.documentHistory = documentHistory;
      
      seller.updatedAt = DateTime.now();

      // Call Repository to Update
      await repository.updateSeller(seller);

      // Update Seller Data in Products
      await updateSellerInProducts(seller);

      // Update All Data list
      SellerController.instance.updateItemFromLists(seller);

      // Update UI Listeners
      update();

      // Remove Loader
      BaakasFullScreenLoader.stopLoading();

      // Show Success Message
      BaakasLoaders.successSnackBar(
          title: 'Success', message: 'Seller details updated successfully');

      // Navigate back
      Get.back();
    } catch (e) {
      BaakasFullScreenLoader.stopLoading();
      BaakasLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Update Seller Categories
  Future<void> updateSellerCategories(SellerModel seller) async {
    try {
      // Delete existing categories
      final existingCategories = await repository.getCategoriesOfSpecificSeller(seller.id);
      for (var category in existingCategories) {
        await repository.deleteSellerCategory(category);
      }

      // Add new categories
      for (var category in selectedCategories) {
        final sellerCategory = SellerCategoryModel(
          sellerId: seller.id,
          categoryId: category.id,
        );
        await repository.createSellerCategory(sellerCategory);
      }

      seller.sellerCategories = selectedCategories;
    } catch (e) {
      throw 'Failed to update seller categories: ${e.toString()}';
    }
  }

  /// Update Seller in Products
  Future<void> updateSellerInProducts(SellerModel seller) async {
    try {
      final productRepository = Get.put(ProductRepository());
      await productRepository.updateSellerInProducts(seller);
    } catch (e) {
      throw 'Failed to update seller in products: ${e.toString()}';
    }
  }
}
