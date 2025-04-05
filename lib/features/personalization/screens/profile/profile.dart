import 'package:baakas_admin/features/personalization/screens/profile/responsive_screens/profile_desktop.dart';
import 'package:baakas_admin/features/personalization/screens/profile/responsive_screens/profile_mobile.dart';
import 'package:baakas_admin/features/personalization/screens/profile/responsive_screens/profile_tablet.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaakasSiteTemplate(
      desktop: ProfileDesktopScreen(),
      tablet: ProfileTabletScreen(),
      mobile: ProfileMobileScreen(),
    );
  }
}
