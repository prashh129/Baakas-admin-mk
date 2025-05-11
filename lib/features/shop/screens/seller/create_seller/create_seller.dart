import 'package:flutter/material.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../create_seller/responsive_screens/create_seller_desktop.dart';
import '../create_seller/responsive_screens/create_seller_mobile.dart';
import '../create_seller/responsive_screens/create_seller_tablet.dart';

class CreateSellerScreen extends StatelessWidget {
  const CreateSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaakasSiteTemplate(
      desktop: CreateSellerDesktopScreen(),
      tablet: CreateSellerTabletScreen(),
      mobile: CreateSellerMobileScreen(),
    );
  }
}
