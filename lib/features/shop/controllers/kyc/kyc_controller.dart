import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/kyc_model.dart';
import '../../../../data/abstract/base_data_table_controller.dart';

class KYCController extends BaakasBaseController<KYCModel> {
  static KYCController get instance => Get.find();

  // Variables
  final RxList<KYCModel> _pendingKYC = <KYCModel>[].obs;
  @override
  final TextEditingController searchTextController = TextEditingController();

  // Getters
  List<KYCModel> get pendingKYC => _pendingKYC;

  @override
  void onInit() {
    Get.log('KYCController initialized');
    fetchPendingKYC();
    super.onInit();
  }

  // Fetch pending KYC applications
  Future<void> fetchPendingKYC() async {
    try {
      Get.log('Fetching pending KYC applications...');
      isLoading.value = true;
      
      final querySnapshot = await FirebaseFirestore.instance
          .collection('sellers')
          .where('kyc.status', isEqualTo: KYCStatus.pending)
          .get();

      Get.log('Found ${querySnapshot.docs.length} pending KYC applications');
      
      _pendingKYC.value = querySnapshot.docs
          .map((doc) {
            Get.log('Processing document: ${doc.id}');
            return KYCModel.fromFirestore(doc);
          })
          .toList();
          
      Get.log('KYC list updated with ${_pendingKYC.length} items');
      
      // Update the base controller's lists
      allItems.assignAll(_pendingKYC);
      filteredItems.assignAll(_pendingKYC);
      selectedRows.assignAll(List.generate(_pendingKYC.length, (index) => false));
    } catch (e) {
      Get.log('Error fetching KYC applications: $e', isError: true);
      Get.snackbar('Error', 'Failed to fetch KYC applications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update KYC status
  Future<void> updateKYCStatus(String sellerId, String status) async {
    try {
      Get.log('Updating KYC status for seller $sellerId to $status');
      isLoading.value = true;
      
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(sellerId)
          .update({
        'kyc.status': status,
      });
      
      Get.log('KYC status updated successfully');
      
      // Refresh the list
      await fetchPendingKYC();
      
      Get.snackbar('Success', 'KYC status updated successfully');
    } catch (e) {
      Get.log('Error updating KYC status: $e', isError: true);
      Get.snackbar('Error', 'Failed to update KYC status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<List<KYCModel>> fetchItems() async {
    return _pendingKYC;
  }

  @override
  Future<void> deleteItem(KYCModel item) async {
    // Not implemented for KYC
  }

  @override
  bool containsSearchQuery(KYCModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase()) ||
           item.bankDetails.bankName.toLowerCase().contains(query.toLowerCase());
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
} 