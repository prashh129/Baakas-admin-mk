import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../media/controllers/media_controller.dart';
import '../../media/models/image_model.dart';
import '../models/user_model.dart';

/// Controller for managing admin-related data and operations
class UserController extends GetxController {
  static UserController get instance => Get.find();

  // Observable variables
  RxBool loading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  // Dependencies
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    // Fetch user details on controller initialization
    fetchUserDetails();
    super.onInit();
  }

  /// Fetches user details from the repository
  Future<UserModel> fetchUserDetails() async {
    try {
      loading.value = true;
      if (user.value.id == null || user.value.id!.isEmpty) {
        final user = await userRepository.fetchAdminDetails();
        this.user.value = user;
      }

      firstNameController.text = user.value.firstName;
      lastNameController.text = user.value.lastName;
      phoneController.text = user.value.phoneNumber;

      loading.value = false;
      return user.value;
    } catch (e) {
      BaakasLoaders.errorSnackBar(
          title: 'Something went wrong.', message: e.toString());
      return UserModel.empty();
    }
  }

  /// Pick Thumbnail Image from Media
  void updateProfilePicture() async {
    try {
      loading.value = true;
      final controller = Get.put(MediaController());
      List<ImageModel>? selectedImages =
          await controller.selectImagesFromMedia();

      // Handle the selected images
      if (selectedImages != null && selectedImages.isNotEmpty) {
        // Set the selected image to the main image or perform any other action
        ImageModel selectedImage = selectedImages.first;

        // Update Profile in Firestore
        await userRepository
            .updateSingleField({'ProfilePicture': selectedImage.url});

        // Update the main image using the selectedImage
        user.value.profilePicture = selectedImage.url;
        user.refresh();
        BaakasLoaders.successSnackBar(
            title: 'Congratulations',
            message: 'Your Profile Picture has been updated.');
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      BaakasLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void updateUserInformation() async {
    try {
      loading.value = true;
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        BaakasFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        BaakasFullScreenLoader.stopLoading();
        return;
      }
      user.value.firstName = firstNameController.text.trim();
      user.value.lastName = lastNameController.text.trim();
      user.value.phoneNumber = phoneController.text.trim();

      await userRepository.updateUserDetails(user.value);
      user.refresh();

      loading.value = false;
      BaakasLoaders.successSnackBar(
          title: 'Congratulations', message: 'Your Profile has been updated.');
    } catch (e) {
      loading.value = false;
      BaakasLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
