import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/coupon_model.dart';

class CouponController extends GetxController {
  static CouponController get instance => Get.find();

  // Variables
  final RxString _searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<CouponModel> _allCoupons = <CouponModel>[].obs;
  final RxList<CouponModel> _filteredCoupons = <CouponModel>[].obs;
  final TextEditingController searchTextController = TextEditingController();
  final TextEditingController couponCodeController = TextEditingController();
  final TextEditingController discountValueController = TextEditingController();
  final TextEditingController minPurchaseController = TextEditingController();
  final TextEditingController maxDiscountController = TextEditingController();
  final RxBool isPercentage = true.obs;
  final Rx<DateTime> validFrom = DateTime.now().obs;
  final Rx<DateTime> expiresOn = DateTime.now().add(const Duration(days: 30)).obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool sortAscending = true.obs;
  final RxInt sortColumnIndex = 0.obs;

  // Getters
  String get currentSearchQuery => _searchQuery.value;
  bool get isCouponLoading => isLoading.value;
  List<CouponModel> get filteredCoupons => _filteredCoupons;

  @override
  void onInit() {
    super.onInit();
    fetchAllCoupons();
  }

  // Fetch all coupons
  Future<void> fetchAllCoupons() async {
    try {
      isLoading.value = true;
      final snapshot = await FirebaseFirestore.instance.collection('Coupons').get();
      _allCoupons.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return CouponModel.fromJson(data);
      }).toList();
      _filteredCoupons.value = _allCoupons;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch coupons: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Search functionality
  void searchQuery(String query) {
    _searchQuery.value = query;
    if (query.isEmpty) {
      _filteredCoupons.value = _allCoupons;
    } else {
      _filteredCoupons.value = _allCoupons.where((coupon) {
        return coupon.code.toLowerCase().contains(query.toLowerCase()) ||
               coupon.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  // Delete coupon
  Future<void> deleteCoupon(String couponId) async {
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance.collection('Coupons').doc(couponId).delete();
      _allCoupons.removeWhere((coupon) => coupon.id == couponId);
      _filteredCoupons.value = _allCoupons;
      Get.snackbar('Success', 'Coupon deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete coupon: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Create coupon
  Future<void> createCoupon() async {
    if (!formKey.currentState!.validate()) return;

    try {
      setLoading(true);
      final couponData = {
        'couponCode': couponCodeController.text.trim(),
        'discountType': isPercentage.value ? 'percentage' : 'fixed',
        'discountValue': double.parse(discountValueController.text.trim()),
        'minimumPurchase': double.parse(minPurchaseController.text.trim()),
        'maximumDiscount': maxDiscountController.text.isNotEmpty
            ? double.parse(maxDiscountController.text.trim())
            : null,
        'validFrom': validFrom.value.toIso8601String(),
        'expirationDate': expiresOn.value.toIso8601String(),
        'usageLimit': 100,
        'usageLimitPerUser': 1,
        'applicableOn': 'all',
        'eligibleUsers': 'all',
        'selectedUsers': [],
        'usedBy': [],
        'isFeatured': false,
        'isActive': true
      };

      await FirebaseFirestore.instance.collection('Coupons').add(couponData);
      Get.back();
      Get.snackbar('Success', 'Coupon created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create coupon: $e');
    } finally {
      setLoading(false);
    }
  }

  // Loading state
  void setLoading(bool value) {
    isLoading.value = value;
  }

  // Initialize with data
  void initialize(List<CouponModel> coupons) {
    _allCoupons.value = coupons;
    _filteredCoupons.value = coupons;
  }

  @override
  void onClose() {
    searchTextController.dispose();
    couponCodeController.dispose();
    discountValueController.dispose();
    minPurchaseController.dispose();
    maxDiscountController.dispose();
    super.onClose();
  }
} 