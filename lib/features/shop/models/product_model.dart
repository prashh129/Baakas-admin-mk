import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'seller_model.dart';

class ProductModel {
  String id;
  final String name;
  final String description;
  final String category;
  final double price;
  String status;
  final String thumbnail;
  final SellerModel? seller;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final String? rejectionReason;
  final List<String> additionalImages;
  final Map<String, dynamic>? specifications;
  final int stockQuantity;
  final String? sku;
  final String? brand;
  final String? condition;
  final double? salePrice;
  final DateTime? saleStartDate;
  final DateTime? saleEndDate;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    this.thumbnail = '',
    this.seller,
    DateTime? createdAt,
    this.updatedAt,
    this.isActive = true,
    this.rejectionReason,
    this.additionalImages = const [],
    this.specifications,
    this.stockQuantity = 0,
    this.sku,
    this.brand,
    this.condition,
    this.salePrice,
    this.saleStartDate,
    this.saleEndDate,
  }) : createdAt = createdAt ?? DateTime.now();

  String get formattedDate => DateFormat('MMM d, y').format(createdAt);
  String get formattedUpdatedDate => updatedAt != null ? DateFormat('MMM d, y').format(updatedAt!) : '';

  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    String? categories,
    double? price,
    String? status,
    String? thumbnail,
    SellerModel? seller,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? rejectionReason,
    List<String>? additionalImages,
    Map<String, dynamic>? specifications,
    int? stockQuantity,
    String? sku,
    String? brand,
    String? condition,
    double? salePrice,
    DateTime? saleStartDate,
    DateTime? saleEndDate,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      status: status ?? this.status,
      thumbnail: thumbnail ?? this.thumbnail,
      seller: seller ?? this.seller,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      additionalImages: additionalImages ?? this.additionalImages,
      specifications: specifications ?? this.specifications,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      sku: sku ?? this.sku,
      brand: brand ?? this.brand,
      condition: condition ?? this.condition,
      salePrice: salePrice ?? this.salePrice,
      saleStartDate: saleStartDate ?? this.saleStartDate,
      saleEndDate: saleEndDate ?? this.saleEndDate,
    );
  }

  static ProductModel empty() => ProductModel(
    id: '',
    name: '',
    description: '',
    category: '',
    price: 0,
    status: 'pending',
    thumbnail: '',
    createdAt: DateTime.now(),
  );

  /// From Firestore snapshot (DocumentSnapshot)
  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProductModel(
      id: document.id,
      name: data['title'] ?? '',
      description: data['Description'] ?? '',
      category: data['categories'] ?? '',
      price: double.parse((data['price'] ?? 0.0).toString()),
      status: data['status']?.toString().toLowerCase() ?? 'pending',
      thumbnail: data['Thumbnail'] ?? '',
      seller: data['Seller'] != null ? SellerModel.fromJson(data['Seller']) : null,
      createdAt: data['CreatedAt'] != null 
          ? (data['CreatedAt'] as Timestamp).toDate() 
          : DateTime.now(),
      updatedAt: data['UpdatedAt'] != null 
          ? (data['UpdatedAt'] as Timestamp).toDate() 
          : null,
      isActive: data['IsActive'] ?? true,
      rejectionReason: data['RejectionReason'],
      additionalImages: List<String>.from(data['AdditionalImages'] ?? []),
      specifications: data['Specifications'],
      stockQuantity: data['StockQuantity'] ?? 0,
      sku: data['SKU'],
      brand: data['Brand'],
      condition: data['Condition'],
      salePrice: data['SalePrice']?.toDouble(),
      saleStartDate: data['SaleStartDate'] != null 
          ? (data['SaleStartDate'] as Timestamp).toDate() 
          : null,
      saleEndDate: data['SaleEndDate'] != null 
          ? (data['SaleEndDate'] as Timestamp).toDate() 
          : null,
    );
  }

  /// From Firestore snapshot (QueryDocumentSnapshot)
  factory ProductModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return ProductModel(
      id: document.id,
      name: data['title'] ?? '',
      description: data['Description'] ?? '',
      category: data['categories'] ?? '',
      price: double.parse((data['price'] ?? 0.0).toString()),
      status: data['status']?.toString().toLowerCase() ?? 'pending',
      thumbnail: data['Thumbnail'] ?? '',
      seller: data['Seller'] != null ? SellerModel.fromJson(data['Seller']) : null,
      createdAt: data['CreatedAt'] != null 
          ? (data['CreatedAt'] as Timestamp).toDate() 
          : DateTime.now(),
      updatedAt: data['UpdatedAt'] != null 
          ? (data['UpdatedAt'] as Timestamp).toDate() 
          : null,
      isActive: data['IsActive'] ?? true,
      rejectionReason: data['RejectionReason'],
      additionalImages: List<String>.from(data['AdditionalImages'] ?? []),
      specifications: data['Specifications'],
      stockQuantity: data['StockQuantity'] ?? 0,
      sku: data['SKU'],
      brand: data['Brand'],
      condition: data['Condition'],
      salePrice: data['SalePrice']?.toDouble(),
      saleStartDate: data['SaleStartDate'] != null 
          ? (data['SaleStartDate'] as Timestamp).toDate() 
          : null,
      saleEndDate: data['SaleEndDate'] != null 
          ? (data['SaleEndDate'] as Timestamp).toDate() 
          : null,
    );
  }

  // Convert model to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'thumbnail': thumbnail,
      'seller': seller?.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isActive': isActive,
      'rejectionReason': rejectionReason,
      'additionalImages': additionalImages,
      'specifications': specifications,
      'stockQuantity': stockQuantity,
      'sku': sku,
      'brand': brand,
      'condition': condition,
      'salePrice': salePrice,
      'saleStartDate': saleStartDate != null ? Timestamp.fromDate(saleStartDate!) : null,
      'saleEndDate': saleEndDate != null ? Timestamp.fromDate(saleEndDate!) : null,
    };
  }
}
