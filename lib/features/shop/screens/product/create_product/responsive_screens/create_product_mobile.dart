import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/product_images_controller.dart';
import '../widgets/additional_images.dart';
import '../widgets/attributes_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/seller_widget.dart';
import '../widgets/categories_widget.dart';
import '../widgets/product_type_widget.dart';
import '../widgets/stock_pricing_widget.dart';
import '../widgets/thumbnail_widget.dart';
import '../widgets/title_description.dart';
import '../widgets/variations_widget.dart';
import '../widgets/visibility_widget.dart';

class CreateProductMobileScreen extends StatelessWidget {
  const CreateProductMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductImagesController());

    return Scaffold(
      bottomNavigationBar: const ProductBottomNavigationButtons(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const BaakasBreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Create Product',
                  breadcrumbItems: [BaakasRoutes.products, 'Create Product']),
              const SizedBox(height: BaakasSizes.spaceBtwSections),

              // Create Product
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProductTitleAndDescription(),
                  const SizedBox(height: BaakasSizes.spaceBtwSections),

                  // Stock & Pricing
                  BaakasRoundedContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Heading
                        Text('Stock & Pricing',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: BaakasSizes.spaceBtwItems),

                        // Product Type
                        const ProductTypeWidget(),
                        const SizedBox(height: BaakasSizes.spaceBtwInputFields),

                        // Stock
                        const ProductStockAndPricing(),
                        const SizedBox(height: BaakasSizes.spaceBtwSections),

                        // Attributes
                        ProductAttributes(),
                        const SizedBox(height: BaakasSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                  const SizedBox(height: BaakasSizes.spaceBtwSections),

                  // Variations
                  const ProductVariations(),
                  const SizedBox(height: BaakasSizes.spaceBtwSections),

                  // Sidebar
                  const ProductThumbnailImage(),
                  const SizedBox(height: BaakasSizes.spaceBtwSections),

                  // Product Images
                  BaakasRoundedContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('All Product Images',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: BaakasSizes.spaceBtwItems),
                        ProductAdditionalImages(
                          additionalProductImagesURLs:
                              controller.additionalProductImagesUrls,
                          onTapToAddImages: () =>
                              controller.selectMultipleProductImages(),
                          onTapToRemoveImage: (index) =>
                              controller.removeImage(index),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: BaakasSizes.spaceBtwSections),

                  // Product Seller
                  const ProductSeller(),
                  const SizedBox(height: BaakasSizes.spaceBtwSections),

                  // Product Categories
                  const ProductCategories(),
                  const SizedBox(height: BaakasSizes.spaceBtwSections),

                  // Product Visibility
                  const ProductVisibilityWidget(),
                  const SizedBox(height: BaakasSizes.spaceBtwSections),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
