import 'package:cloud_firestore/cloud_firestore.dart';

class KYCStatus {
  static const String pending = 'pending';
  static const String verified = 'verified';
  static const String declined = 'declined';
}

class BankDetails {
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String branch;

  BankDetails({
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.branch,
  });

  factory BankDetails.fromMap(Map<String, dynamic> map) {
    return BankDetails(
      accountName: map['accountName'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      bankName: map['bankName'] ?? '',
      branch: map['branch'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountName': accountName,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'branch': branch,
    };
  }
}

class KYCModel {
  final String sellerId;
  final String name;
  final String panImageUrl;
  final String citizenshipFrontUrl;
  final String citizenshipBackUrl;
  final BankDetails bankDetails;
  final String status;
  final DateTime submittedAt;

  KYCModel({
    required this.sellerId,
    required this.name,
    required this.panImageUrl,
    required this.citizenshipFrontUrl,
    required this.citizenshipBackUrl,
    required this.bankDetails,
    required this.status,
    required this.submittedAt,
  });

  factory KYCModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final kycData = data['kyc'] as Map<String, dynamic>;
    
    return KYCModel(
      sellerId: doc.id,
      name: data['name'] ?? '',
      panImageUrl: kycData['panImageUrl'] ?? '',
      citizenshipFrontUrl: kycData['citizenshipFrontUrl'] ?? '',
      citizenshipBackUrl: kycData['citizenshipBackUrl'] ?? '',
      bankDetails: BankDetails.fromMap(kycData['bankDetails'] ?? {}),
      status: kycData['status'] ?? KYCStatus.pending,
      submittedAt: (kycData['submittedAt'] as Timestamp).toDate(),
    );
  }
} 