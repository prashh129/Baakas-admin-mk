import 'package:baakas_admin/features/shop/controllers/category/category_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
import '../../../../features/shop/models/product_model.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';

class EditProductController extends GetxController {
  // Singleton instance
  static EditProductController get instance => Get.find();

  // Observables for loading state and product details
  final isLoading = false.obs;
  final selectedCategoriesLoader = false.obs;
  final productType = ProductType.single.obs;
  final productVisibility = ProductVisibility.hidden.obs;

  // Controllers and keys
  final variationsController = Get.put(ProductVariationController());
  final attributesController = Get.put(ProductAttributesController());
  final imagesController = Get.put(ProductImagesController());
  final productRepository = Get.put(ProductRepository());
  final stockPriceFormKey = GlobalKey<FormState>();
  final titleDescriptionFormKey = GlobalKey<FormState>();

  // Text editing controllers for input fields
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController sellerTextField = TextEditingController();

  // Rx observables for selected seller and categories
  final Rx<SellerModel?> selectedSeller = Rx<SellerModel?>(null);
  final RxList<CategoryModel> selectedCategories = <CategoryModel>[].obs;
  final List<CategoryModel> alreadyAddedCategories = <CategoryModel>[];

  // Flags for tracking different tasks
  RxBool thumbnailUploader = true.obs;
  RxBool productDataUploader = false.obs;
  RxBool additionalImagesUploader = true.obs;
  RxBool categoriesRelationshipUploader = false.obs;

  // Initialize Product Data
  void initProductData(ProductModel product) {
    try {
      isLoading.value = true; // Set loading state while initializing data

      // Basic Information
      title.text = product.name;
      description.text = ''; // No description in simplified model
      productType.value = ProductType.single; // Default to single type

      // Stock & Pricing
      stock.text = '0'; // No stock in simplified model
      price.text = product.price.toString();
      salePrice.text = '0'; // No sale price in simplified model

      // Product Seller
      selectedSeller.value = null; // No seller in simplified model
      sellerTextField.text = '';

      // Product Thumbnail and Images
      imagesController.selectedThumbnailImageUrl.value = '';
      imagesController.additionalProductImagesUrls.clear();

      // Product Attributes & Variations
      attributesController.productAttributes.clear();
      variationsController.productVariations.clear();
      variationsController.initializeVariationControllers([]);

      isLoading.value = false; // Set loading state back to false after initialization

      update();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<List<CategoryModel>> loadSelectedCategories(String productId) async {
    selectedCategoriesLoader.value = true;
    // Product Categories
    final productCategories = await productRepository.getProductCategories(
      productId,
    );
    final categoriesController = Get.put(CategoryController());
    if (categoriesController.allItems.isEmpty) {
      await categoriesController.fetchItems();
    }

    final categoriesIds = productCategories.map((e) => e.categoryId).toList();
    final categories =
        categoriesController.allItems
            .where((element) => categoriesIds.contains(element.id))
            .toList();
    selectedCategories.assignAll(categories);
    alreadyAddedCategories.assignAll(categories);
    selectedCategoriesLoader.value = false;
    return categories;
  }

  // Function to edit a product
  Future<void> editProduct(ProductModel product) async {
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

      // Create updated product with new values
      final updatedProduct = ProductModel(
        id: product.id,
        name: title.text.trim(),
        category: product.category,
        price: double.tryParse(price.text.trim()) ?? 0,
        status: product.status, description: '',
      );

      // Call Repository to Update Product
      productDataUploader.value = true;
      await ProductRepository.instance.updateProduct(updatedProduct);

      // Update Product List
      ProductController.instance.updateItemFromLists(updatedProduct);

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
      builder:
          (context) => PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text('Updating Product'),
              content: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      BaakasImages.creatingProductIllustration,
                      height: 200,
                      width: 200,
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    buildCheckbox('Thumbnail Image', thumbnailUploader),
                    buildCheckbox(
                      'Additional Images',
                      additionalImagesUploader,
                    ),
                    buildCheckbox(
                      'Product Data, Attributes & Variations',
                      productDataUploader,
                    ),
                    buildCheckbox(
                      'Product Categories',
                      categoriesRelationshipUploader,
                    ),
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
          child:
              value.value
                  ? const Icon(
                    CupertinoIcons.checkmark_alt_circle_fill,
                    color: Colors.blue,
                  )
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
            child: const Text('Go to Products'),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              BaakasImages.productsIllustration,
              height: 200,
              width: 200,
            ),
            const SizedBox(height: BaakasSizes.spaceBtwItems),
            Text(
              'Congratulations',
              style: Theme.of(Get.context!).textTheme.headlineSmall,
            ),
            const SizedBox(height: BaakasSizes.spaceBtwItems),
            const Text('Your Product has been Created'),
          ],
        ),
      ),
    );
  }
}
