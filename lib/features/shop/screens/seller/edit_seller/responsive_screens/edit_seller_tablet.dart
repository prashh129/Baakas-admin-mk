import 'package:baakas_admin/features/shop/screens/seller/edit_seller/widgets/edit_seller_form.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/seller_model.dart';

class EditSellerTabletScreen extends StatelessWidget {
  const EditSellerTabletScreen({super.key, required this.seller});

  final SellerModel seller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BaakasBreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Update Seller',
                  breadcrumbItems: [BaakasRoutes.sellers, 'Update Seller']),
              const SizedBox(height: BaakasSizes.spaceBtwSections),

              // Form
              EditSellerForm(seller: seller),
            ],
          ),
        ),
      ),
    );
  }
}
