import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/product/product_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/product_model.dart';
import '../order/order_controller.dart';

class ProductController extends BaakasBaseController<ProductModel> {
  static ProductController get instance => Get.find();

  final _productRepository = Get.put(ProductRepository());
  
  // Add current tab tracking
  final RxString currentTab = 'pending'.obs;

  // Variables
  final isLoading = false.obs;
  final searchTextController = TextEditingController();
  final filteredItems = <ProductModel>[].obs;
  final allItems = <ProductModel>[].obs;
  final selectedRows = <bool>[].obs;
  final sortColumnIndex = 0.obs;
  final sortAscending = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Fetch all products
  Future<void> fetchProducts({String? status}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      
      final products = status != null 
          ? await _productRepository.getProductsByApprovalStatus(status)
          : await _productRepository.getAllProducts();
      
      if (products.isEmpty) {
        BaakasLoaders.warningSnackBar(
          title: 'No Products',
          message: 'No products found in the database.',
        );
      }
      
      allItems.assignAll(products);
      filteredItems.assignAll(products);
      
      // Initialize selected rows
      selectedRows.assignAll(List.generate(products.length, (index) => false));
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      BaakasLoaders.errorSnackBar(
        title: 'Error Loading Products',
        message: 'Failed to load products: ${e.toString()}',
      );
      // Initialize with empty lists to prevent null errors
      allItems.clear();
      filteredItems.clear();
      selectedRows.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Filter products by status
  void filterByApprovalStatus(String status) {
    try {
      if (status.isEmpty) {
        fetchProducts();
      } else {
        fetchProducts(status: status);
      }
    } catch (e) {
      BaakasLoaders.errorSnackBar(
        title: 'Error Filtering Products',
        message: 'Failed to filter products: ${e.toString()}',
      );
    }
  }

  // Search products
  void searchQuery(String query) {
    try {
      if (query.isEmpty) {
        filteredItems.assignAll(allItems);
      } else {
        filteredItems.assignAll(
          allItems.where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.category.toLowerCase().contains(query.toLowerCase()) ||
            (product.seller?.name ?? '').toLowerCase().contains(query.toLowerCase()),
          ).toList(),
        );
      }
      // Update selected rows for filtered items
      selectedRows.assignAll(List.generate(filteredItems.length, (index) => false));
    } catch (e) {
      BaakasLoaders.errorSnackBar(
        title: 'Error Searching Products',
        message: 'Failed to search products: ${e.toString()}',
      );
    }
  }

  // Update product status
  Future<void> updateProductStatus(String productId, String status, {String? reason}) async {
    try {
      isLoading.value = true;
      await _productRepository.updateProductStatus(productId, status, reason: reason);
      await fetchProducts(); // Refresh the list
      BaakasLoaders.successSnackBar(
        title: 'Success',
        message: 'Product status updated successfully',
      );
    } catch (e) {
      BaakasLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      isLoading.value = true;
      await _productRepository.deleteProduct(productId);
      await fetchProducts(); // Refresh the list
      BaakasLoaders.successSnackBar(
        title: 'Success',
        message: 'Product deleted successfully',
      );
    } catch (e) {
      BaakasLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Sort by name
  void sortByName(int columnIndex, bool ascending) {
    try {
      sortColumnIndex.value = columnIndex;
      sortAscending.value = ascending;
      filteredItems.sort((a, b) => ascending
          ? a.name.compareTo(b.name)
          : b.name.compareTo(a.name));
    } catch (e) {
      BaakasLoaders.errorSnackBar(
        title: 'Error Sorting Products',
        message: 'Failed to sort products: ${e.toString()}',
      );
    }
  }

  // Sort by price
  void sortByPrice(int columnIndex, bool ascending) {
    try {
      sortColumnIndex.value = columnIndex;
      sortAscending.value = ascending;
      filteredItems.sort((a, b) => ascending
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price));
    } catch (e) {
      BaakasLoaders.errorSnackBar(
        title: 'Error Sorting Products',
        message: 'Failed to sort products: ${e.toString()}',
      );
    }
  }

  // Sort by approval status
  void sortByApprovalStatus(int columnIndex, bool ascending) {
    try {
      sortColumnIndex.value = columnIndex;
      sortAscending.value = ascending;
      filteredItems.sort((a, b) => ascending
          ? a.status.compareTo(b.status)
          : b.status.compareTo(a.status));
    } catch (e) {
      BaakasLoaders.errorSnackBar(
        title: 'Error Sorting Products',
        message: 'Failed to sort products: ${e.toString()}',
      );
    }
  }

  @override
  bool containsSearchQuery(ProductModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase()) ||
        item.category.toLowerCase().contains(query.toLowerCase()) ||
        item.price.toString().contains(query);
  }

  @override
  Future<void> deleteItem(ProductModel item) async {
    try {
      final orderController = Get.put(OrderController());

      if (orderController.allItems.isEmpty) {
        await orderController.fetchItems();
      }

      final orderExists = orderController.allItems.any((element) =>
          element.items.any((element) => element.productId == item.id));

      if (orderExists) {
        BaakasLoaders.warningSnackBar(
            title: 'Dependents Exist',
            message:
                'In order to Delete this Product, Delete dependent Orders first.');
        return;
      }
      await _productRepository.deleteProduct(item.id);
    } catch (e) {
      BaakasLoaders.errorSnackBar(
        title: 'Error Deleting Product',
        message: 'Failed to delete product: ${e.toString()}',
      );
    }
  }

  String getProductPrice(ProductModel product) {
    return product.price.toString();
  }

  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  String getProductStockTotal(ProductModel product) {
    return product.stockQuantity.toString();
  }

  String getProductSoldQuantity(ProductModel product) {
    return '0'; // No soldQuantity field in simplified model
  }

  String getProductStockStatus(ProductModel product) {
    if (product.stockQuantity <= 0) return 'Out of Stock';
    if (product.stockQuantity < 10) return 'Low Stock';
    return 'In Stock';
  }

  @override
  Future<List<ProductModel>> fetchItems() async {
    await fetchProducts();
    return allItems;
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
