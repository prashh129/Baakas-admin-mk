import 'package:cloud_firestore/cloud_firestore.dart';

class SellerCategoryModel {
  String? id;
  final String sellerId;
  final String categoryId;

  SellerCategoryModel({
    this.id,
    required this.sellerId,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'sellerId': sellerId,
      'categoryId': categoryId,
    };
  }

  factory SellerCategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return SellerCategoryModel(
      id: snapshot.id,
      sellerId: data['sellerId'] as String,
      categoryId: data['categoryId'] as String,
    );
  }
}
