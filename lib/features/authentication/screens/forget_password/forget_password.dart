import 'package:baakas_admin/features/authentication/screens/forget_password/responsive_screens/forget_password_desktop.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';

/// Screen for handling the forget password process
class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaakasSiteTemplate(
      useLayout: false,
      desktop: ForgetPasswordScreenDesktop(),
    );
  }
}
