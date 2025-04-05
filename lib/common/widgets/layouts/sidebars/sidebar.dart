import 'package:baakas_admin/features/personalization/controllers/settings_controller.dart';
import 'package:baakas_admin/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../images/t_circular_image.dart';
import 'menu/menu_item.dart';

/// Sidebar widget for navigation menu
class BaakasSidebar extends StatelessWidget {
  const BaakasSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          color: BaakasColors.white,
          border: Border(right: BorderSide(width: 1, color: BaakasColors.grey)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Obx(
                    () => BaakasCircularImage(
                      width: 60,
                      height: 60,
                      padding: 0,
                      margin: BaakasSizes.sm,
                      backgroundColor: Colors.transparent,
                      imageType:
                          SettingsController
                                  .instance
                                  .settings
                                  .value
                                  .appLogo
                                  .isNotEmpty
                              ? ImageType.network
                              : ImageType.asset,
                      image:
                          SettingsController
                                  .instance
                                  .settings
                                  .value
                                  .appLogo
                                  .isNotEmpty
                              ? SettingsController
                                  .instance
                                  .settings
                                  .value
                                  .appLogo
                              : BaakasImages.darkAppLogo,
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => Text(
                        SettingsController.instance.settings.value.appName,
                        style: Theme.of(context).textTheme.headlineLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: BaakasSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: BaakasSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'MENU',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2),
                    ),
                    // Menu Items
                    const BaakasMenuItem(
                      route: BaakasRoutes.dashboard,
                      icon: Iconsax.status,
                      itemName: 'Dashboard',
                    ),
                    const BaakasMenuItem(
                      route: BaakasRoutes.media,
                      icon: Iconsax.image,
                      itemName: 'Media',
                    ),
                    const BaakasMenuItem(
                      route: BaakasRoutes.banners,
                      icon: Iconsax.picture_frame,
                      itemName: 'Banners',
                    ),
                    const BaakasMenuItem(
                      route: BaakasRoutes.products,
                      icon: Iconsax.shopping_bag,
                      itemName: 'Products',
                    ),
                    const BaakasMenuItem(
                      route: BaakasRoutes.categories,
                      icon: Iconsax.category_2,
                      itemName: 'Categories',
                    ),
                    const BaakasMenuItem(
                      route: BaakasRoutes.brands,
                      icon: Iconsax.dcube,
                      itemName: 'Brands',
                    ),
                    const BaakasMenuItem(
                      route: BaakasRoutes.customers,
                      icon: Iconsax.profile_2user,
                      itemName: 'Customers',
                    ),
                    const BaakasMenuItem(
                      route: BaakasRoutes.orders,
                      icon: Iconsax.box,
                      itemName: 'Orders',
                    ),
                    const BaakasMenuItem(
                      route: BaakasRoutes.coupons,
                      icon: Iconsax.code,
                      itemName: 'Coupons',
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    Text(
                      'OTHER',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2),
                    ),
                    // Other menu items
                    const BaakasMenuItem(
                      route: BaakasRoutes.profile,
                      icon: Iconsax.user,
                      itemName: 'Profile',
                    ),
                    const BaakasMenuItem(
                      route: BaakasRoutes.settings,
                      icon: Iconsax.setting_2,
                      itemName: 'Settings',
                    ),
                    const BaakasMenuItem(
                      route: 'logout',
                      icon: Iconsax.logout,
                      itemName: 'Logout',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
