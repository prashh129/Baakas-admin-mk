import 'package:baakas_admin/features/personalization/models/address_model.dart';
import 'package:baakas_admin/features/shop/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../utils/formatters/formatter.dart';
import '../../../utils/constants/enums.dart';

/// Model class representing user data.
class UserModel {
  final String? id;
  String firstName;
  String lastName;
  String userName;
  String email;
  String phoneNumber;
  String profilePicture;
  AppRole role;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<OrderModel>? orders;
  List<AddressModel>? addresses;

  /// Constructor for UserModel.
  UserModel({
    this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.userName = '',
    this.phoneNumber = '',
    this.profilePicture = '',
    this.role = AppRole.user,
    this.createdAt,
    this.updatedAt,
  });

  /// Helper methods
  String get fullName => '$firstName $lastName';

  String get formattedPhoneNo => BaakasFormatter.formatPhoneNumber(phoneNumber);

  String get formattedDate => BaakasFormatter.formatDate(createdAt);

  String get formattedUpdatedAtDate => BaakasFormatter.formatDate(updatedAt);

  /// Static function to create an empty user model.
  static UserModel empty() =>
      UserModel(email: ''); // Default createdAt to current time

  /// Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'UserName': userName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Role': role.name.toString(),
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  /// Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data.containsKey('FirstName') ? data['FirstName'] ?? '' : '',
        lastName: data.containsKey('LastName') ? data['LastName'] ?? '' : '',
        userName: data.containsKey('UserName') ? data['UserName'] ?? '' : '',
        email: data.containsKey('Email') ? data['Email'] ?? '' : '',
        phoneNumber:
            data.containsKey('PhoneNumber') ? data['PhoneNumber'] ?? '' : '',
        profilePicture:
            data.containsKey('ProfilePicture')
                ? data['ProfilePicture'] ?? ''
                : '',
        role:
            data.containsKey('Role')
                ? (data['Role'] ?? AppRole.user) ==
                        AppRole.admin.name.toString()
                    ? AppRole.admin
                    : AppRole.user
                : AppRole.user,
        createdAt:
            data.containsKey('CreatedAt')
                ? data['CreatedAt']?.toDate() ?? DateTime.now()
                : DateTime.now(),
        updatedAt:
            data.containsKey('UpdatedAt')
                ? data['UpdatedAt']?.toDate() ?? DateTime.now()
                : DateTime.now(),
      );
    } else {
      return empty();
    }
  }
}
