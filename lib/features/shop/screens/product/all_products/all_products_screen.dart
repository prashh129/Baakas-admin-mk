import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import 'product_management_screen.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaakasSiteTemplate(
      desktop: ProductManagementScreen(),
      tablet: ProductManagementScreen(),
      mobile: ProductManagementScreen(),
    );
  }
} 