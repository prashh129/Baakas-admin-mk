import 'package:baakas_admin/features/personalization/screens/settings/responsive_screens/settings_desktop.dart';
import 'package:baakas_admin/features/personalization/screens/settings/responsive_screens/settings_mobile.dart';
import 'package:baakas_admin/features/personalization/screens/settings/responsive_screens/settings_tablet.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaakasSiteTemplate(
      desktop: SettingsDesktopScreen(),
      tablet: SettingsTabletScreen(),
      mobile: SettingsMobileScreen(),
    );
  }
}
