import 'package:flutter/material.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../all_sellers/responsive_screens/sellers_desktop.dart';
import '../all_sellers/responsive_screens/sellers_mobile.dart';
import '../all_sellers/responsive_screens/sellers_tablet.dart';

class SellersScreen extends StatelessWidget {
  const SellersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaakasSiteTemplate(
        desktop: SellersDesktopScreen(),
        tablet: SellersTabletScreen(),
        mobile: SellersMobileScreen());
  }
}
