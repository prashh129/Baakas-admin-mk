import 'package:baakas_admin/features/shop/screens/seller/create_seller/widgets/create_seller_form.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';

class CreateSellerMobileScreen extends StatelessWidget {
  const CreateSellerMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaakasBreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Create Seller',
                  breadcrumbItems: [BaakasRoutes.sellers, 'Create Seller']),
              SizedBox(height: BaakasSizes.spaceBtwSections),

              // Form
              CreateSellerForm(),
            ],
          ),
        ),
      ),
    );
  }
}
