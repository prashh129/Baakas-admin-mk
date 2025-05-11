import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import necessary controllers, models, and utility classes
import '../../../../data/repositories/product/product_repository.dart';
import '../../../../features/shop/controllers/product/product_attributes_controller.dart';
import '../../../../features/shop/controllers/product/product_controller.dart';
import '../../../../features/shop/controllers/product/product_images_controller.dart';
import '../../../../features/shop/controllers/product/product_variations_controller.dart';
import '../../../../features/shop/models/seller_model.dart';
import '../../../../features/shop/models/category_model.dart';
import '../../../../features/shop/models/product_category_model.dart';
import '../../../../features/shop/models/product_model.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';

class CreateProductController extends GetxController {
  // Singleton instance
  static CreateProductController get instance => Get.find();

  // Observables for loading state and product details
  final isLoading = false.obs;
  final productType = ProductType.single.obs;
  final productVisibility = ProductVisibility.hidden.obs;

  // Controllers and keys
  final stockPriceFormKey = GlobalKey<FormState>();
  final productRepository = Get.put(ProductRepository());
  final titleDescriptionFormKey = GlobalKey<FormState>();

  // Text editing controllers for input fields
  TextEditingController title = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController sellerTextField = TextEditingController();

  // Rx observables for selected seller and categories
  final Rx<SellerModel?> selectedSeller = Rx<SellerModel?>(null);
  final RxList<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  // Flags for tracking different tasks
  RxBool thumbnailUploader = false.obs;
  RxBool additionalImagesUploader = false.obs;
  RxBool productDataUploader = false.obs;
  RxBool categoriesRelationshipUploader = false.obs;

  // Function to create a new product
  Future<void> createProduct() async {
    try {
      // Show progress dialog
      showProgressDialog();

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        BaakasFullScreenLoader.stopLoading();
        return;
      }

      // Validate title and description form
      if (!titleDescriptionFormKey.currentState!.validate()) {
        BaakasFullScreenLoader.stopLoading();
        return;
      }

      // Validate stock and pricing form if ProductType = Single
      if (productType.value == ProductType.single &&
          !stockPriceFormKey.currentState!.validate()) {
        BaakasFullScreenLoader.stopLoading();
        return;
      }

      // Ensure a seller is selected
      if (selectedSeller.value == null) throw 'Select Seller for this product';

      // Check variation data if ProductType = Variable
      if (productType.value == ProductType.variable &&
          ProductVariationController.instance.productVariations.isEmpty) {
        throw 'There are no variations for the Product Type Variable. Create some variations or change Product type.';
      }
      if (productType.value == ProductType.variable) {
        final variationCheckFailed = ProductVariationController
            .instance.productVariations
            .any((element) =>
                element.price.isNaN ||
                element.price < 0 ||
                element.salePrice.isNaN ||
                element.salePrice < 0 ||
                element.stock.isNaN ||
                element.stock < 0 ||
                element.image.value.isEmpty);

        if (variationCheckFailed) {
          throw 'Variation data is not accurate. Please recheck variations';
        }
      }

      // Upload Product Thumbnail Image
      thumbnailUploader.value = true;
      final imagesController = ProductImagesController.instance;
      if (imagesController.selectedThumbnailImageUrl.value == null) {
        throw 'Select Product Thumbnail Image';
      }

      // Additional Product Images
      additionalImagesUploader.value = true;

      // Product Variation Images
      final variations = ProductVariationController.instance.productVariations;
      if (productType.value == ProductType.single && variations.isNotEmpty) {
        // If admin added variations and then changed the Product Type, remove all variations
        ProductVariationController.instance.resetAllValues();
        variations.value = [];
      }

      // Map Product Data to ProductModel
      final newRecord = ProductModel(
        id: '',
        name: title.text.trim(),
        category: selectedCategories.isNotEmpty ? selectedCategories.first.id : '',
        price: double.tryParse(price.text.trim()) ?? 0,
        status: 'pending',
        description: description.text.trim(),
      );

      // Call Repository to Create New Product
      productDataUploader.value = true;
      newRecord.id = await ProductRepository.instance.createProduct(newRecord);

      // Register product categories if any
      if (selectedCategories.isNotEmpty) {
        if (newRecord.id.isEmpty) throw 'Error storing data. Try again';

        // Loop through selected Product Categories
        categoriesRelationshipUploader.value = true;
        for (var category in selectedCategories) {
          // Map Data
          final productCategory = ProductCategoryModel(
              productId: newRecord.id, categoryId: category.id);
          await ProductRepository.instance
              .createProductCategory(productCategory);
        }
      }

      // Update Product List
      ProductController.instance.addItemToLists(newRecord);

      // Close the Progress Loader
      BaakasFullScreenLoader.stopLoading();

      // Show Success Message Loader
      showCompletionDialog();
    } catch (e) {
      BaakasFullScreenLoader.stopLoading();
      BaakasLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  // Reset form values and flags
  void resetValues() {
    isLoading.value = false;
    productType.value = ProductType.single;
    productVisibility.value = ProductVisibility.hidden;
    stockPriceFormKey.currentState?.reset();
    titleDescriptionFormKey.currentState?.reset();
    title.clear();
    description.clear();
    stock.clear();
    price.clear();
    salePrice.clear();
    sellerTextField.clear();
    selectedSeller.value = null;
    selectedCategories.clear();
    ProductVariationController.instance.resetAllValues();
    ProductAttributesController.instance.resetProductAttributes();

    // Reset Upload Flags
    thumbnailUploader.value = false;
    additionalImagesUploader.value = false;
    productDataUploader.value = false;
    categoriesRelationshipUploader.value = false;
  }

  // Show the progress dialog
  void showProgressDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Creating Product'),
          content: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(BaakasImages.creatingProductIllustration,
                    height: 200, width: 200),
                const SizedBox(height: BaakasSizes.spaceBtwItems),
                buildCheckbox('Thumbnail Image', thumbnailUploader),
                buildCheckbox('Additional Images', additionalImagesUploader),
                buildCheckbox('Product Data, Attributes & Variations',
                    productDataUploader),
                buildCheckbox(
                    'Product Categories', categoriesRelationshipUploader),
                const SizedBox(height: BaakasSizes.spaceBtwItems),
                const Text('Sit Tight, Your product is uploading...'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build a checkbox widget
  Widget buildCheckbox(String label, RxBool value) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child: value.value
              ? const Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.blue)
              : const Icon(CupertinoIcons.checkmark_alt_circle),
        ),
        const SizedBox(width: BaakasSizes.spaceBtwItems),
        Text(label),
      ],
    );
  }

  // Show completion dialog
  void showCompletionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Congratulations'),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text('Go to Products'))
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(BaakasImages.productsIllustration,
                height: 200, width: 200),
            const SizedBox(height: BaakasSizes.spaceBtwItems),
            Text('Congratulations',
                style: Theme.of(Get.context!).textTheme.headlineSmall),
            const SizedBox(height: BaakasSizes.spaceBtwItems),
            const Text('Your Product has been Created'),
          ],
        ),
      ),
    );
  }
}
