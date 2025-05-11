
import 'package:baakas_admin/features/shop/screens/banner/edit_banner/responsive_screens/edit_banner_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../common/widgets/page_not_found/page_not_found.dart';
import 'responsive_screens/edit_banner_desktop.dart';
import 'responsive_screens/edit_banner_mobile.dart';

class EditBannerScreen extends StatelessWidget {
  const EditBannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final banner = Get.arguments;

    return banner != null
        ? BaakasSiteTemplate(
          desktop: EditBannerDesktopScreen(banner: banner),
          tablet: EditBannerTabletScreen(banner: banner),
          mobile: EditBannerMobileScreen(banner: banner),
        )
        : const BaakasPageNotFound();
  }
}
