import 'package:baakas_admin/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/product_images_controller.dart';
import '../../../../models/product_model.dart';
import '../../create_product/widgets/additional_images.dart';
import '../../create_product/widgets/thumbnail_widget.dart';
import '../widgets/attributes_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/seller_widget.dart';
import '../widgets/categories_widget.dart';
import '../widgets/product_type_widget.dart';
import '../widgets/stock_pricing_widget.dart';
import '../widgets/title_description.dart';
import '../widgets/variations_widget.dart';
import '../widgets/visibility_widget.dart';

class EditProductDesktopScreen extends StatelessWidget {
  const EditProductDesktopScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductImagesController());
    return Scaffold(
      bottomNavigationBar: ProductBottomNavigationButtons(product: product),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const BaakasBreadcrumbsWithHeading(
                heading: 'Edit Product',
                returnToPreviousScreen: true,
                breadcrumbItems: [BaakasRoutes.products, 'Edit Product'],
              ),
              const SizedBox(height: BaakasSizes.spaceBtwSections),

              // Edit Product
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: BaakasDeviceUtils.isTabletScreen(context) ? 2 : 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Basic Information
                        const ProductTitleAndDescription(),
                        const SizedBox(height: BaakasSizes.spaceBtwSections),

                        // Stock & Pricing
                        BaakasRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Heading
                              Text(
                                'Stock & Pricing',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: BaakasSizes.spaceBtwItems),

                              // Product Type
                              const ProductTypeWidget(),
                              const SizedBox(
                                height: BaakasSizes.spaceBtwInputFields,
                              ),

                              // Stock
                              const ProductStockAndPricing(),
                              const SizedBox(
                                height: BaakasSizes.spaceBtwSections,
                              ),

                              // Attributes
                              ProductAttributes(), // Add/Edit/Delete Attributes
                              const SizedBox(
                                height: BaakasSizes.spaceBtwSections,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: BaakasSizes.spaceBtwSections),

                        // Variations
                        const ProductVariations(), // Edit/Delete Variations
                      ],
                    ),
                  ),
                  const SizedBox(width: BaakasSizes.defaultSpace),

                  // Sidebar
                  Expanded(
                    child: Column(
                      children: [
                        // Product Thumbnail
                        const ProductThumbnailImage(),
                        const SizedBox(height: BaakasSizes.spaceBtwSections),

                        // Product Images
                        BaakasRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'All Product Images',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: BaakasSizes.spaceBtwItems),
                              ProductAdditionalImages(
                                additionalProductImagesURLs:
                                    controller.additionalProductImagesUrls,
                                onTapToAddImages:
                                    () =>
                                        controller
                                            .selectMultipleProductImages(),
                                onTapToRemoveImage:
                                    (index) => controller.removeImage(index),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: BaakasSizes.spaceBtwSections),

                        // Product Seller
                        const ProductSeller(),
                        const SizedBox(height: BaakasSizes.spaceBtwSections),

                        // Product Categories
                        ProductCategories(product: product),
                        const SizedBox(height: BaakasSizes.spaceBtwSections),

                        // Product Visibility
                        const ProductVisibilityWidget(),
                        const SizedBox(height: BaakasSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
