import 'package:baakas_admin/features/shop/screens/banner/edit_banner/widgets/edit_seller_form.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/banner_model.dart';


class EditBannerDesktopScreen extends StatelessWidget {
  const EditBannerDesktopScreen({super.key, required this.banner});

  final BannerModel banner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const BaakasBreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Update Banner',
                  breadcrumbItems: [BaakasRoutes.categories, 'Update Banner']),
              const SizedBox(height: BaakasSizes.spaceBtwSections),

              // Form
              EditBannerForm(banner: banner),
            ],
          ),
        ),
      ),
    );
  }
}
