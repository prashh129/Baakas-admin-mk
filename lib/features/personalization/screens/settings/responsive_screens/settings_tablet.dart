import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/image_meta.dart';
import '../widgets/settings_form.dart';

class SettingsTabletScreen extends StatelessWidget {
  const SettingsTabletScreen({super.key});

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
                  heading: 'Settings', breadcrumbItems: ['Settings']),
              SizedBox(height: BaakasSizes.spaceBtwSections),

              Column(
                children: [
                  ImageAndMeta(),
                  SizedBox(height: BaakasSizes.spaceBtwSections),

                  // Form
                  SettingsForm(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
