import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/form.dart';
import '../widgets/image_meta.dart';

class ProfileTabletScreen extends StatelessWidget {
  const ProfileTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              BaakasBreadcrumbsWithHeading(
                  heading: 'Profile', breadcrumbItems: ['Profile']),
              SizedBox(height: BaakasSizes.spaceBtwSections),

              Column(
                children: [
                  ImageAndMeta(),
                  SizedBox(height: BaakasSizes.spaceBtwSections),

                  // Form
                  ProfileForm(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
