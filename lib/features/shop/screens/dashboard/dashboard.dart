import 'package:baakas_admin/features/shop/screens/dashboard/responsive_screens/dashboard_desktop.dart';
import 'package:baakas_admin/features/shop/screens/dashboard/responsive_screens/dashboard_mobile.dart';
import 'package:baakas_admin/features/shop/screens/dashboard/responsive_screens/dashboard_tablet.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaakasSiteTemplate(
      desktop: DashboardDesktopScreen(),
      tablet: DashboardTabletScreen(),
      mobile: DashboardMobileScreen(),
    );
  }
}
