import 'package:baakas_admin/features/shop/controllers/category/category_controller.dart';
import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/sellers/seller_repository.dart';
import '../../models/seller_model.dart';

class SellerController extends BaakasBaseController<SellerModel> {
  static SellerController get instance => Get.find();

  final _sellerRepository = Get.put(SellerRepository());
  final categoryController = Get.put(CategoryController());

  @override
  Future<List<SellerModel>> fetchItems() async {
    // Fetch sellers
    final fetchedSellers = await _sellerRepository.getAllSellers();

    // Fetch Seller Categories Relational Data
    final fetchedSellerCategories =
        await _sellerRepository.getAllSellerCategories();

    // Fetch All Categories if data does not already exist
    if (categoryController.allItems.isEmpty) {
      await categoryController.fetchItems();
    }

    // Loop all sellers and fetch categories of each
    for (var seller in fetchedSellers) {
      // Extract categoryIds from the documents
      List<String> categoryIds =
          fetchedSellerCategories
              .where((sellerCategory) => sellerCategory.sellerId == seller.id)
              .map((sellerCategory) => sellerCategory.categoryId)
              .toList();

      seller.sellerCategories =
          categoryController.allItems
              .where((category) => categoryIds.contains(category.id))
              .toList();
    }

    return fetchedSellers;
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (SellerModel s) => s.name.toLowerCase(),
    );
  }

  @override
  bool containsSearchQuery(SellerModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(SellerModel item) async {
    await _sellerRepository.deleteSeller(item);
  }

  // Update shipping method for a seller
  Future<void> updateShippingMethod(SellerModel seller, String newMethod) async {
    try {
      seller.shippingMethod = newMethod;
      await _sellerRepository.updateSeller(seller);
      updateItemFromLists(seller);
    } catch (e) {
      throw 'Failed to update shipping method: ${e.toString()}';
    }
  }

  // Toggle featured status for a seller
  Future<void> toggleFeaturedStatus(SellerModel seller) async {
    try {
      seller.isFeatured = !seller.isFeatured;
      await _sellerRepository.updateSeller(seller);
      updateItemFromLists(seller);
    } catch (e) {
      throw 'Failed to update featured status: ${e.toString()}';
    }
  }
}
