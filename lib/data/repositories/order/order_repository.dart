import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/shop/models/order_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class OrderRepository extends GetxController {
  // Singleton instance of the OrderRepository
  static OrderRepository get instance => Get.find();

  // Firebase Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /* ---------------------------- FUNCTIONS ---------------------------------*/

  //Get all orders related to the current user
   Future<List<OrderModel>> getAllOrders() async {
     try {
       final result = await _db
           .collection('Orders')
           .orderBy('orderDate', descending: true)
           .get();
       return result.docs
           .map((documentSnapshot) => OrderModel.fromSnapshot(documentSnapshot))
           .toList();
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
  //       // Get all orders related to the current user
  // Future<List<OrderModel>> getAllOrdersThisWeek() async {
  //   try {
  //     final now = DateTime.now();
  //     final startOfWeek = DateTime(now.year, now.month, now.day)
  //         .subtract(Duration(days: now.weekday - 1)); // Monday

  //     final result = await _db
  //         .collection('Orders')
  //         .where('orderDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
  //         .orderBy('orderDate', descending: true)
  //         .get();

  //     return result.docs
  //         .map((doc) => OrderModel.fromSnapshot(doc))
  //         .toList();
  //   } catch (e) {
  //     // your existing error handling
  //     throw 'Something went wrong. Please try again';
  //   }
  // }


  // Store a new user order
  Future<void> addOrder(OrderModel order) async {
    try {
      await _db.collection('Orders').add(order.toJson());
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

  // Update a specific value of an order instance
  Future<void> updateOrderSpecificValue(
      String orderId, Map<String, dynamic> data) async {
    try {
      await _db.collection('Orders').doc(orderId).update(data);
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

  // Delete an order
  Future<void> deleteOrder(String orderId) async {
    try {
      await _db.collection("Orders").doc(orderId).delete();
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
