import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../common/widgets/page_not_found/page_not_found.dart';
import '../edit_seller/responsive_screens/edit_seller_desktop.dart';
import '../edit_seller/responsive_screens/edit_seller_mobile.dart';
import '../edit_seller/responsive_screens/edit_seller_tablet.dart';

class EditSellerScreen extends StatelessWidget {
  const EditSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final seller = Get.arguments;

    return seller != null
        ? BaakasSiteTemplate(
            desktop: EditSellerDesktopScreen(seller: seller),
            tablet: EditSellerTabletScreen(seller: seller),
            mobile: EditSellerMobileScreen(seller: seller),
          )
        : const BaakasPageNotFound();
  }
}
