import 'package:baakas_admin/features/shop/models/kyc_model.dart';
import 'package:baakas_admin/utils/constants/colors.dart';
import 'package:flutter/material.dart';


class KYCStatusBadge extends StatelessWidget {
  final String status;

  const KYCStatusBadge({
    super.key,
    required this.status,
  });

  Color _getStatusColor() {
    switch (status) {
      case KYCStatus.verified:
        return BaakasColors.success;
      case KYCStatus.declined:
        return BaakasColors.error;
      case KYCStatus.pending:
        return BaakasColors.warning;
      default:
        return BaakasColors.grey;
    }
  }

  String _getStatusText() {
    switch (status) {
      case KYCStatus.verified:
        return 'Verified';
      case KYCStatus.declined:
        return 'Declined';
      case KYCStatus.pending:
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getStatusColor()),
      ),
      child: Text(
        _getStatusText(),
        style: TextStyle(
          color: _getStatusColor(),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
} 