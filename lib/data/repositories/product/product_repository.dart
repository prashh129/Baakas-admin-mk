// 

import 'package:baakas_admin/features/shop/models/product_category_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/shop/models/product_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import 'package:baakas_admin/features/shop/models/seller_model.dart';

/// Repository for managing product-related data and operations.
class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /* ---------------------------- CORE FUNCTIONS ---------------------------------*/

  Future<String> createProduct(ProductModel product) async {
    try {
      final result = await _db.collection('Products').add(product.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<String> createProductCategory(ProductCategoryModel productCategory) async {
    try {
      final result =
          await _db.collection("ProductCategory").add(productCategory.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _db.collection('Products').doc(product.id).update(product.toJson());
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateProductSpecificValue(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection('Products').doc(id).update(data);
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await _db.collection('Products').get();
      return snapshot.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw 'Something went wrong while fetching products. Please try again.';
    }
  }

  Future<List<ProductCategoryModel>> getProductCategories(String productId) async {
    try {
      final snapshot = await _db
          .collection('ProductCategory')
          .where('productId', isEqualTo: productId)
          .get();
      return snapshot.docs
          .map((querySnapshot) =>
              ProductCategoryModel.fromSnapshot(querySnapshot))
          .toList();
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> removeProductCategory(String productId, String categoryId) async {
    try {
      final result = await _db
          .collection("ProductCategory")
          .where('productId', isEqualTo: productId)
          .where('categoryId', isEqualTo: categoryId)
          .get();

      for (final doc in result.docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _db.collection('Products').doc(productId).delete();
    } catch (e) {
      throw 'Something went wrong while deleting product. Please try again.';
    }
  }

  /* ---------------------------- ADMIN FEATURES ---------------------------------*/

  Future<void> updateProductStatus(String productId, String status, {String? reason}) async {
    try {
      await _db.collection('Products').doc(productId).update({
        'status': status,
        'RejectionReason': reason,
        'UpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Something went wrong while updating product status. Please try again.';
    }
  }

  Future<void> updateProductFeaturedStatus(String productId, bool isFeatured) async {
    try {
      await _db.collection('Products').doc(productId).update({
        'isFeatured': isFeatured,
      });
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to update featured status';
    }
  }

  Future<void> updateProductField(String productId, String field, dynamic value) async {
    try {
      await _db.collection('Products').doc(productId).update({
        field: value,
      });
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to update $field';
    }
  }

  Future<List<ProductModel>> getProductsByApprovalStatus(String status) async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('status', isEqualTo: status)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } catch (e) {
      throw 'Error getting $status products';
    }
  }

  /* ---------------------------- CATEGORY MANAGEMENT ----------------------------*/

  /// Add Category to Product
  Future<void> addCategoryToProduct(String productId, String categoryId) async {
    try {
      await _db.collection('ProductCategory').add({
        'productId': productId,
        'categoryId': categoryId,
      });
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to add category to product';
    }
  }

  /// Remove Category from Product
  Future<void> removeCategoryFromProduct(String productId, String categoryId) async {
    try {
      final result = await _db
          .collection("ProductCategory")
          .where('productId', isEqualTo: productId)
          .where('categoryId', isEqualTo: categoryId)
          .get();

      for (final doc in result.docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to remove category from product';
    }
  }

  /// Get Categories for a Product
  Future<List<ProductCategoryModel>> getCategoriesForProduct(String productId) async {
    try {
      final snapshot = await _db
          .collection('ProductCategory')
          .where('productId', isEqualTo: productId)
          .get();
      return snapshot.docs
          .map((doc) => ProductCategoryModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch categories for product';
    }
  }

  /// Update seller information in all products
  Future<void> updateSellerInProducts(SellerModel seller) async {
    try {
      final productsSnapshot = await _db
          .collection("Products")
          .where('Seller.Id', isEqualTo: seller.id)
          .get();

      for (var doc in productsSnapshot.docs) {
        await _db.collection("Products").doc(doc.id).update({
          'Seller': seller.toJson(),
        });
      }
    } on FirebaseException catch (e) {
      throw BaakasFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BaakasFormatException();
    } on PlatformException catch (e) {
      throw BaakasPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
