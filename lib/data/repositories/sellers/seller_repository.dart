import 'dart:io';

import 'package:baakas_admin/features/shop/models/seller_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/shop/models/seller_category_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class SellerRepository extends GetxController {
  static SellerRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all sellers from the 'Sellers' collection
  Future<List<SellerModel>> getAllSellers() async {
    try {
      final snapshot = await _db.collection("Users")
          .where('role', isEqualTo: 'seller')
          .get();
      final result = snapshot.docs.map((e) => SellerModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Get all seller categories from the 'SellerCategory' collection
  Future<List<SellerCategoryModel>> getAllSellerCategories() async {
    try {
      final sellerCategoryQuery = await _db.collection('SellerCategory').get();
      final sellerCategories = sellerCategoryQuery.docs
          .map((doc) => SellerCategoryModel.fromSnapshot(doc))
          .toList();
      return sellerCategories;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Get specific seller categories for a given seller ID
  Future<List<SellerCategoryModel>> getCategoriesOfSpecificSeller(
      String sellerId) async {
    try {
      final sellerCategoryQuery = await _db
          .collection('SellerCategory')
          .where('sellerId', isEqualTo: sellerId)
          .get();
      final sellerCategories = sellerCategoryQuery.docs
          .map((doc) => SellerCategoryModel.fromSnapshot(doc))
          .toList();
      return sellerCategories;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Create a new seller document in the 'Users' collection
  Future<String> createSeller(SellerModel seller) async {
    try {
      // Add role field to the seller data
      final sellerData = seller.toJson();
      sellerData['role'] = 'seller';  // Add role field
      
      final result = await _db.collection("Users").add(sellerData);
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

  // Create a new seller category document in the 'SellerCategory' collection
  Future<String> createSellerCategory(SellerCategoryModel sellerCategory) async {
    try {
      final result =
          await _db.collection("SellerCategory").add(sellerCategory.toJson());
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

  // Update an existing seller document in the 'Users' collection
  Future<void> updateSeller(SellerModel seller) async {
    try {
      await _db.collection("Users").doc(seller.id).update(seller.toJson());
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

  // Delete an existing seller document and its associated seller categories
  Future<void> deleteSeller(SellerModel seller) async {
    try {
      await _db.runTransaction((transaction) async {
        final sellerRef = _db.collection("Users").doc(seller.id);
        final sellerSnap = await transaction.get(sellerRef);

        if (!sellerSnap.exists) {
          throw Exception("Seller not found");
        }

        final sellerCategoriesSnapshot = await _db
            .collection('SellerCategory')
            .where('sellerId', isEqualTo: seller.id)
            .get();
        final sellerCategories = sellerCategoriesSnapshot.docs
            .map((e) => SellerCategoryModel.fromSnapshot(e));

        if (sellerCategories.isNotEmpty) {
          for (var sellerCategory in sellerCategories) {
            transaction
                .delete(_db.collection('SellerCategory').doc(sellerCategory.id));
          }
        }

        transaction.delete(sellerRef);
      });
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

  /// Delete a seller category document from the 'SellerCategory' collection
  Future<void> deleteSellerCategory(SellerCategoryModel sellerCategory) async {
    try {
      await _db.collection("SellerCategory").doc(sellerCategory.id).delete();
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
