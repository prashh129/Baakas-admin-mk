import 'package:cloud_firestore/cloud_firestore.dart';

class CouponRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new coupon
  Future<String> createCoupon(Map<String, dynamic> couponData) async {
    try {
      final result = await _db.collection('Coupons').add(couponData);
      return result.id; // Return the coupon ID after creation
    } catch (e) {
      throw 'Error creating coupon: $e';
    }
  }

  // Get all active coupons (with ID included)
  Future<List<Map<String, dynamic>>> getActiveCoupons() async {
    try {
      final snapshot = await _db
          .collection('Coupons')
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Include Firestore document ID
        return data;
      }).toList();
    } catch (e) {
      throw 'Error fetching coupons: $e';
    }
  }

  // Get all coupons (active and inactive)
  Future<List<Map<String, dynamic>>> getAllCoupons() async {
    try {
      final snapshot = await _db.collection('Coupons').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw 'Error fetching coupons: $e';
    }
  }

  // Validate a coupon by code and user ID
  Future<Map<String, dynamic>?> validateCoupon(
      String couponCode, String userId) async {
    try {
      final snapshot = await _db
          .collection('Coupons')
          .where('couponCode', isEqualTo: couponCode)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        data['id'] = doc.id; // Include Firestore document ID
        return data;
      }

      return null; // No valid coupon found
    } catch (e) {
      throw 'Error validating coupon: $e';
    }
  }

  // Update a coupon
  Future<void> updateCoupon(
      String couponId, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection('Coupons').doc(couponId).update(updatedData);
    } catch (e) {
      throw 'Error updating coupon: $e';
    }
  }

  // Delete a coupon
  Future<void> deleteCoupon(String couponId) async {
    try {
      await _db.collection('Coupons').doc(couponId).delete();
    } catch (e) {
      throw 'Error deleting coupon: $e';
    }
  }

  // Send a notification about a coupon
  Future<void> sendCouponNotification(String message) async {
    try {
      await _db.collection('Notifications').add({
        'type': 'coupon',
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Error sending coupon notification: $e';
    }
  }
}
