import 'package:baakas_admin/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerTableHeader extends StatelessWidget {
  const BannerTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () => Get.toNamed(BaakasRoutes.createBanner),
            child: const Text('Create New Banner'),
          ),
        ),
      ],
    );
  }
}
