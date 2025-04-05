import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginScreenMobile extends StatelessWidget {
  const LoginScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaakasHelperFunctions.isDarkMode(context)
          ? BaakasColors.black
          : Colors.white,
      body: Container(
        padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              ///  Header
              BaakasLoginHeader(),

              /// Form
              BaakasLoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
