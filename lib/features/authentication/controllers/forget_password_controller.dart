import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

/// Controller for handling forget password functionality
class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Text editing controller for email field
  final email = TextEditingController();

  /// Form key for forget password form
  final forgetPasswordFormKey = GlobalKey<FormState>();

  /// Sends a password reset email
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      BaakasFullScreenLoader.openLoadingDialog(
          'Processing your request...', BaakasImages.ridingIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        BaakasFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        BaakasFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      // Remove Loader
      BaakasFullScreenLoader.stopLoading();

      // Redirect
      BaakasLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email Link Sent to Reset your Password'.tr);
      Get.offNamed(BaakasRoutes.resetPassword, arguments: email.text.trim());
    } catch (e) {
      BaakasFullScreenLoader.stopLoading();
      BaakasLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  /// Resends a password reset email
  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      BaakasFullScreenLoader.openLoadingDialog(
          'Processing your request...', BaakasImages.ridingIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        BaakasFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.trim());

      // Remove Loader
      BaakasFullScreenLoader.stopLoading();

      // Show success message
      BaakasLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email Link Sent to Reset your Password'.tr);
    } catch (e) {
      BaakasFullScreenLoader.stopLoading();
      BaakasLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
