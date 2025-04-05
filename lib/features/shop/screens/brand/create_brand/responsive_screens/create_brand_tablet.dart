import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/create_brand_form.dart';

class CreateBrandTabletScreen extends StatelessWidget {
  const CreateBrandTabletScreen({
    super.key,
  });

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
                  heading: 'Create Brand',
                  breadcrumbItems: [BaakasRoutes.categories, 'Create Brand']),
              SizedBox(height: BaakasSizes.spaceBtwSections),

              // Form
              CreateBrandForm(),
            ],
          ),
        ),
      ),
    );
  }
}
