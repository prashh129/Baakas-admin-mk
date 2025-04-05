import 'package:baakas_admin/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../controllers/login_controller.dart';

class BaakasLoginForm extends StatelessWidget {
  const BaakasLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: BaakasSizes.spaceBtwSections,
        ),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: controller.email,
              validator: BaakasValidator.validateEmail,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: BaakasTexts.email,
              ),
            ),
            const SizedBox(height: BaakasSizes.spaceBtwInputFields),

            /// Password
            Obx(
              () => TextFormField(
                obscureText: controller.hidePassword.value,
                controller: controller.password,
                validator:
                    (value) =>
                        BaakasValidator.validateEmptyText('Password', value),
                decoration: InputDecoration(
                  labelText: BaakasTexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed:
                        () =>
                            controller.hidePassword.value =
                                !controller.hidePassword.value,
                    icon: Icon(
                      controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: BaakasSizes.spaceBtwInputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged:
                            (value) => controller.rememberMe.value = value!,
                      ),
                    ),
                    const Text(BaakasTexts.rememberMe),
                  ],
                ),

                /// Forget Password
                TextButton(
                  onPressed: () => Get.toNamed(BaakasRoutes.forgetPassword),
                  child: const Text(BaakasTexts.forgetPassword),
                ),
              ],
            ),
            const SizedBox(height: BaakasSizes.spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              // Un Comment this line to register admin
              // child: ElevatedButton(onPressed: () => controller.registerAdmin(), child: const Text('Register Admin')),
              child: ElevatedButton(
                onPressed: () => controller.emailAndPasswordSignIn(),
                child: const Text(BaakasTexts.signIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
