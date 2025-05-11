import 'package:baakas_admin/features/shop/controllers/product/product_controller.dart';
import 'package:baakas_admin/features/shop/widgets/products_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../utils/constants/sizes.dart';
import 'widgets/table_header.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    );
    // Initial filter
    controller.filterByApprovalStatus('pending');
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final status = _getStatusFromIndex(_tabController.index);
        controller.filterByApprovalStatus(status);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getStatusFromIndex(int index) {
    switch (index) {
      case 0:
        return 'pending';
      case 1:
        return 'approved';
      case 2:
        return 'rejected';
      default:
        return 'pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs and Header
              const BaakasBreadcrumbsWithHeading(
                heading: 'Products',
                breadcrumbItems: ['Products'],
              ),
              const SizedBox(height: BaakasSizes.spaceBtwSections),
              ProductTableHeader(),
              const SizedBox(height: BaakasSizes.spaceBtwItems),

              // Tab Bar
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(child: Text('Pending')),
                  Tab(child: Text('Approved')),
                  Tab(child: Text('Rejected')),
                ],
              ),
              const SizedBox(height: BaakasSizes.spaceBtwSections),

              // Tab Content
              SizedBox(
                height: 700,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: BaakasLoaderAnimation());
                  }
                  return TabBarView(
                    controller: _tabController,
                    children: const [
                      BaakasRoundedContainer(child: ProductsTable(status: 'pending')),
                      BaakasRoundedContainer(child: ProductsTable(status: 'approved')),
                      BaakasRoundedContainer(child: ProductsTable(status: 'rejected')),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 