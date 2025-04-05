import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../common/widgets/page_not_found/page_not_found.dart';
import 'responsive_screens/edit_brand_desktop.dart';
import 'responsive_screens/edit_brand_mobile.dart';
import 'responsive_screens/edit_brand_tablet.dart';

class EditBrandScreen extends StatelessWidget {
  const EditBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = Get.arguments;

    return brand != null
        ? BaakasSiteTemplate(
            desktop: EditBrandDesktopScreen(brand: brand),
            tablet: EditBrandTabletScreen(brand: brand),
            mobile: EditBrandMobileScreen(brand: brand),
          )
        : const BaakasPageNotFound();
  }
}
