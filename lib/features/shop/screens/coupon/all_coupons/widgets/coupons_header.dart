import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../features/personalization/controllers/user_controller.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/popups/loaders.dart';
import '../../../../controllers/coupon/coupon_controller.dart';

class CouponsHeader extends StatelessWidget implements PreferredSizeWidget {
  const CouponsHeader({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    final couponController = Get.put(CouponController());
    return Container(
      decoration: const BoxDecoration(
        color: BaakasColors.white,
        border: Border(bottom: BorderSide(color: BaakasColors.grey, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: BaakasSizes.md,
        vertical: BaakasSizes.sm,
      ),
      child: BaakasAppBar(
        leadingIcon: !BaakasDeviceUtils.isDesktopScreen(context) ? Iconsax.menu : null,
        leadingOnPressed: !BaakasDeviceUtils.isDesktopScreen(context)
            ? () {
                if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
                  scaffoldKey.currentState?.closeDrawer();
                } else {
                  scaffoldKey.currentState?.openDrawer();
                }
              }
            : null,
        title: Row(
          children: [
            if (BaakasDeviceUtils.isDesktopScreen(context))
              SizedBox(
                width: 400,
                child: TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.search_normal),
                    hintText: 'Search coupons...',
                  ),
                  onChanged: (value) => couponController.searchQuery(value),
                ),
              ),
            if (!BaakasDeviceUtils.isDesktopScreen(context))
              const Text('Coupons', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          if (!BaakasDeviceUtils.isDesktopScreen(context))
            IconButton(
              icon: const Icon(Iconsax.search_normal),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.search_normal),
                              hintText: 'Search coupons...',
                            ),
                            onChanged: (value) => couponController.searchQuery(value),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Iconsax.notification),
            onPressed: () {
              BaakasLoaders.successSnackBar(
                title: 'Notifications',
                message: 'No new notifications',
              );
            },
          ),
          const SizedBox(width: BaakasSizes.spaceBtwItems / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => BaakasRoundedImage(
                  width: 40,
                  padding: 2,
                  height: 40,
                  fit: BoxFit.cover,
                  imageType: controller.user.value.profilePicture.isNotEmpty
                      ? ImageType.network
                      : ImageType.asset,
                  image: controller.user.value.profilePicture.isNotEmpty
                      ? controller.user.value.profilePicture
                      : BaakasImages.user,
                  imageUrl: controller.user.value.profilePicture.isNotEmpty
                      ? controller.user.value.profilePicture
                      : BaakasImages.user,
                  isNetworkImage: controller.user.value.profilePicture.isNotEmpty,
                ),
              ),
              const SizedBox(width: BaakasSizes.sm),
              if (!BaakasDeviceUtils.isMobileScreen(context))
                Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.loading.value
                          ? const SizedBox(width: 50, height: 13)
                          : Text(
                              controller.user.value.fullName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                      controller.loading.value
                          ? const SizedBox(width: 70, height: 13)
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
  Size get preferredSize => Size.fromHeight(BaakasDeviceUtils.getAppBarHeight() + 15);
} 