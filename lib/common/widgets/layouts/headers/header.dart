import 'package:baakas_admin/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../features/personalization/controllers/user_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../appbar/appbar.dart';
import '../../images/t_rounded_image.dart';
import '../../shimmers/shimmer.dart';

/// Header widget for the application
class BaakasHeader extends StatelessWidget implements PreferredSizeWidget {
  const BaakasHeader({super.key, required this.scaffoldKey});

  /// GlobalKey to access the Scaffold state
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Container(
      /// Background Color, Bottom Border
      decoration: const BoxDecoration(
        color: BaakasColors.white,
        border: Border(bottom: BorderSide(color: BaakasColors.grey, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: BaakasSizes.md,
        vertical: BaakasSizes.sm,
      ),
      child: BaakasAppBar(
        /// Mobile Menu
        leadingIcon:
            !BaakasDeviceUtils.isDesktopScreen(context) ? Iconsax.menu : null,
        leadingOnPressed:
            !BaakasDeviceUtils.isDesktopScreen(context)
                ? () => scaffoldKey.currentState?.openDrawer()
                : null,
        title: Row(
          children: [
            /// Search
            if (BaakasDeviceUtils.isDesktopScreen(context))
              SizedBox(
                width: 400,
                child: TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.search_normal),
                    hintText: 'Search anything...',
                  ),
                ),
              ),
          ],
        ),
        actions: [
          // Search Icon on Mobile
          if (!BaakasDeviceUtils.isDesktopScreen(context))
            IconButton(
              icon: const Icon(Iconsax.search_normal),
              onPressed: () {},
            ),

          // Notification Icon
          IconButton(icon: const Icon(Iconsax.notification), onPressed: () {}),
          const SizedBox(width: BaakasSizes.spaceBtwItems / 2),

          /// User Data
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// User Profile Image
              Obx(
                () => BaakasRoundedImage(
                  width: 40,
                  padding: 2,
                  height: 40,
                  fit: BoxFit.cover,
                  imageType:
                      controller.user.value.profilePicture.isNotEmpty
                          ? ImageType.network
                          : ImageType.asset,
                  image:
                      controller.user.value.profilePicture.isNotEmpty
                          ? controller.user.value.profilePicture
                          : BaakasImages.user,
                  imageUrl: controller.user.value.profilePicture.isNotEmpty
                      ? controller.user.value.profilePicture
                      : BaakasImages.user,
                  isNetworkImage: controller.user.value.profilePicture.isNotEmpty,
                ),
              ),

              const SizedBox(width: BaakasSizes.sm),

              /// User Profile Data [Hide on Mobile]
              if (!BaakasDeviceUtils.isMobileScreen(context))
                Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.loading.value
                          ? const BaakasShimmerEffect(width: 50, height: 13)
                          : Text(
                            controller.user.value.fullName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                      controller.loading.value
                          ? const BaakasShimmerEffect(width: 70, height: 13)
                          : Text(
                            controller.user.value.email,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(BaakasDeviceUtils.getAppBarHeight() + 15);
}
