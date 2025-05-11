import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/formatters/formatter.dart';
import 'category_model.dart';

class SellerModel {
  String id;
  String name;
  String image;
  bool isFeatured;
  int? productsCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  String shippingMethod;
  String? shopName;
  
  // Contact Information
  String? phoneNumber;
  String? email;
  String? businessAddress;
  String? website;
  Map<String, String>? socialMediaLinks; // e.g., {'facebook': 'url', 'instagram': 'url'}

  // Business Details
  String? businessRegistrationNumber;
  String? businessType; // e.g., 'Sole Proprietorship', 'Partnership', etc.
  String? businessDescription;
  int? yearsInBusiness;
  Map<String, String>? businessHours; // e.g., {'monday': '9:00-17:00', 'tuesday': '9:00-17:00'}

  // Bank Details
  String? bankAccountNumber;
  String? bankName;
  String? bankBranch;
  String? accountHolder;
  String? ifscCode;
  String? accountType; // e.g., 'Savings', 'Current'

  // Document Management
  String? citizenshipImage;
  String? businessPanImage;
  String? businessPanNumber;
  DateTime? citizenshipExpiryDate;
  DateTime? panExpiryDate;
  String? documentVerificationStatus; // e.g., 'pending', 'verified', 'rejected'
  List<Map<String, dynamic>>? documentHistory; // Track document changes

  // Not mapped
  List<CategoryModel>? sellerCategories;

  SellerModel({
    required this.id,
    required this.image,
    required this.name,
    this.isFeatured = false,
    this.productsCount,
    this.createdAt,
    this.updatedAt,
    this.sellerCategories,
    this.shippingMethod = 'drop_off',
    this.shopName,
    
    // Contact Information
    this.phoneNumber,
    this.email,
    this.businessAddress,
    this.website,
    this.socialMediaLinks,
    
    // Business Details
    this.businessRegistrationNumber,
    this.businessType,
    this.businessDescription,
    this.yearsInBusiness,
    this.businessHours,
    
    // Bank Details
    this.bankAccountNumber,
    this.bankName,
    this.bankBranch,
    this.accountHolder,
    this.ifscCode,
    this.accountType,
    
    // Document Management
    this.citizenshipImage,
    this.businessPanImage,
    this.businessPanNumber,
    this.citizenshipExpiryDate,
    this.panExpiryDate,
    this.documentVerificationStatus = 'pending',
    this.documentHistory,
  });

  /// Empty Helper Function
  static SellerModel empty() => SellerModel(id: '', image: '', name: '');

  String get formattedDate => BaakasFormatter.formatDate(createdAt);

  String get formattedUpdatedAtDate => BaakasFormatter.formatDate(updatedAt);

  /// Convert model to Json structure so that you can store data in Firebase
  toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'CreatedAt': createdAt,
      'IsFeatured': isFeatured,
      'ProductsCount': productsCount ?? 0,
      'UpdatedAt': updatedAt ?? DateTime.now(),
      'ShippingMethod': shippingMethod,
      'ShopName': shopName,
      
      // Contact Information
      'PhoneNumber': phoneNumber,
      'Email': email,
      'BusinessAddress': businessAddress,
      'Website': website,
      'SocialMediaLinks': socialMediaLinks,
      
      // Business Details
      'BusinessRegistrationNumber': businessRegistrationNumber,
      'BusinessType': businessType,
      'BusinessDescription': businessDescription,
      'YearsInBusiness': yearsInBusiness,
      'BusinessHours': businessHours,
      
      // Bank Details
      'BankAccountNumber': bankAccountNumber,
      'BankName': bankName,
      'BankBranch': bankBranch,
      'AccountHolder': accountHolder,
      'IfscCode': ifscCode,
      'AccountType': accountType,
      
      // Document Management
      'CitizenshipImage': citizenshipImage,
      'BusinessPanImage': businessPanImage,
      'BusinessPanNumber': businessPanNumber,
      'CitizenshipExpiryDate': citizenshipExpiryDate,
      'PanExpiryDate': panExpiryDate,
      'DocumentVerificationStatus': documentVerificationStatus,
      'DocumentHistory': documentHistory,
    };
  }

  /// Map Json oriented document snapshot from Firebase to UserModel
  factory SellerModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return SellerModel.empty();
    return SellerModel(
      id: data['Id'] ?? '',
      name: data['Name'] ?? '',
      image: data['Image'] ?? '',
      isFeatured: data['IsFeatured'] ?? false,
      productsCount: int.parse((data['ProductsCount'] ?? 0).toString()),
      createdAt: data.containsKey('CreatedAt') ? data['CreatedAt']?.toDate() : null,
      updatedAt: data.containsKey('UpdatedAt') ? data['UpdatedAt']?.toDate() : null,
      shippingMethod: data['ShippingMethod'] ?? 'drop_off',
      shopName: data['ShopName'],
      
      // Contact Information
      phoneNumber: data['PhoneNumber'],
      email: data['Email'],
      businessAddress: data['BusinessAddress'],
      website: data['Website'],
      socialMediaLinks: Map<String, String>.from(data['SocialMediaLinks'] ?? {}),
      
      // Business Details
      businessRegistrationNumber: data['BusinessRegistrationNumber'],
      businessType: data['BusinessType'],
      businessDescription: data['BusinessDescription'],
      yearsInBusiness: data['YearsInBusiness'],
      businessHours: Map<String, String>.from(data['BusinessHours'] ?? {}),
      
      // Bank Details
      bankAccountNumber: data['BankAccountNumber'],
      bankName: data['BankName'],
      bankBranch: data['BankBranch'],
      accountHolder: data['AccountHolder'],
      ifscCode: data['IfscCode'],
      accountType: data['AccountType'],
      
      // Document Management
      citizenshipImage: data['CitizenshipImage'],
      businessPanImage: data['BusinessPanImage'],
      businessPanNumber: data['BusinessPanNumber'],
      citizenshipExpiryDate: data.containsKey('CitizenshipExpiryDate') ? data['CitizenshipExpiryDate']?.toDate() : null,
      panExpiryDate: data.containsKey('PanExpiryDate') ? data['PanExpiryDate']?.toDate() : null,
      documentVerificationStatus: data['DocumentVerificationStatus'] ?? 'pending',
      documentHistory: List<Map<String, dynamic>>.from(data['DocumentHistory'] ?? []),
    );
  }

  /// Map Json oriented document snapshot from Firebase to UserModel
  factory SellerModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      // Map JSON Record to the Model
      return SellerModel(
        id: document.id,
        name: data['Name'] ?? data['name'] ?? '',
        image: data['Image'] ?? data['image'] ?? '',
        isFeatured: data['IsFeatured'] ?? data['isFeatured'] ?? false,
        productsCount: int.tryParse((data['ProductsCount'] ?? data['productsCount'] ?? 0).toString()) ?? 0,
        createdAt: data.containsKey('CreatedAt') ? data['CreatedAt']?.toDate() : 
                  data.containsKey('createdAt') ? data['createdAt']?.toDate() : null,
        updatedAt: data.containsKey('UpdatedAt') ? data['UpdatedAt']?.toDate() :
                  data.containsKey('updatedAt') ? data['updatedAt']?.toDate() : null,
        shippingMethod: data['ShippingMethod'] ?? data['shippingMethod'] ?? 'drop_off',
        shopName: data['ShopName'] ?? data['shopName'],
        
        // Contact Information
        phoneNumber: data['PhoneNumber'] ?? data['phoneNumber'],
        email: data['Email'] ?? data['email'],
        businessAddress: data['BusinessAddress'] ?? data['businessAddress'],
        website: data['Website'] ?? data['website'],
        socialMediaLinks: Map<String, String>.from(data['SocialMediaLinks'] ?? data['socialMediaLinks'] ?? {}),
        
        // Business Details
        businessRegistrationNumber: data['BusinessRegistrationNumber'] ?? data['businessRegistrationNumber'],
        businessType: data['BusinessType'] ?? data['businessType'],
        businessDescription: data['BusinessDescription'] ?? data['businessDescription'],
        yearsInBusiness: data['YearsInBusiness'] ?? data['yearsInBusiness'],
        businessHours: Map<String, String>.from(data['BusinessHours'] ?? data['businessHours'] ?? {}),
        
        // Bank Details
        bankAccountNumber: data['BankAccountNumber'] ?? data['bankAccountNumber'],
        bankName: data['BankName'] ?? data['bankName'],
        bankBranch: data['BankBranch'] ?? data['bankBranch'],
        accountHolder: data['AccountHolder'] ?? data['accountHolder'],
        ifscCode: data['IfscCode'] ?? data['ifscCode'],
        accountType: data['AccountType'] ?? data['accountType'],
        
        // Document Management
        citizenshipImage: data['CitizenshipImage'] ?? data['citizenshipImage'],
        businessPanImage: data['BusinessPanImage'] ?? data['businessPanImage'],
        businessPanNumber: data['BusinessPanNumber'] ?? data['businessPanNumber'],
        citizenshipExpiryDate: data.containsKey('CitizenshipExpiryDate') ? data['CitizenshipExpiryDate']?.toDate() :
                             data.containsKey('citizenshipExpiryDate') ? data['citizenshipExpiryDate']?.toDate() : null,
        panExpiryDate: data.containsKey('PanExpiryDate') ? data['PanExpiryDate']?.toDate() :
                      data.containsKey('panExpiryDate') ? data['panExpiryDate']?.toDate() : null,
        documentVerificationStatus: data['DocumentVerificationStatus'] ?? data['documentVerificationStatus'] ?? 'pending',
        documentHistory: List<Map<String, dynamic>>.from(data['DocumentHistory'] ?? data['documentHistory'] ?? []),
      );
    } else {
      return SellerModel.empty();
    }
  }
}
