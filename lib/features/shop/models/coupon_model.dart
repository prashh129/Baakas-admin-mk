import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  final String id;
  final String code;
  final String description;
  final String discountType;
  final double discountValue;
  final double minimumPurchase;
  final double? maximumDiscount;
  final DateTime validFrom;
  final DateTime expiresOn;
  final int usageLimit;
  final int usageLimitPerUser;
  final String applicableOn;
  final String eligibleUsers;
  final List<String> selectedUsers;
  final List<String> usedBy;
  final bool isFeatured;
  final bool isActive;

  CouponModel({
    required this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.minimumPurchase,
    this.maximumDiscount,
    required this.validFrom,
    required this.expiresOn,
    required this.usageLimit,
    required this.usageLimitPerUser,
    required this.applicableOn,
    required this.eligibleUsers,
    required this.selectedUsers,
    required this.usedBy,
    required this.isFeatured,
    required this.isActive,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] ?? '',
      code: json['couponCode'] ?? '',
      description: json['description'] ?? '',
      discountType: json['discountType'] ?? 'percentage',
      discountValue: (json['discountValue'] ?? 0).toDouble(),
      minimumPurchase: (json['minimumPurchase'] ?? 0).toDouble(),
      maximumDiscount: json['maximumDiscount']?.toDouble(),
      validFrom: json['validFrom'] is String 
          ? DateTime.parse(json['validFrom'])
          : (json['validFrom'] as Timestamp).toDate(),
      expiresOn: json['expirationDate'] is String
          ? DateTime.parse(json['expirationDate'])
          : (json['expirationDate'] as Timestamp).toDate(),
      usageLimit: json['usageLimit'] ?? 100,
      usageLimitPerUser: json['usageLimitPerUser'] ?? 1,
      applicableOn: json['applicableOn'] ?? 'all',
      eligibleUsers: json['eligibleUsers'] ?? 'all',
      selectedUsers: List<String>.from(json['selectedUsers'] ?? []),
      usedBy: List<String>.from(json['usedBy'] ?? []),
      isFeatured: json['isFeatured'] ?? false,
      isActive: json['isActive'] ?? true,
    );
  }
} 