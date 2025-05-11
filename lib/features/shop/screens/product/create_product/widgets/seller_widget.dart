import 'package:baakas_admin/features/shop/controllers/product/create_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/seller/seller_controller.dart';

class ProductSeller extends StatelessWidget {
  const ProductSeller({super.key});

  @override
  Widget build(BuildContext context) {
    // Get instances of controllers
    final controller = Get.put(CreateProductController());
    final sellerController = Get.put(SellerController());

    // Fetch sellers if the list is empty
    if (sellerController.allItems.isEmpty) {
      sellerController.fetchItems();
    }

    return BaakasRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seller label
          Text('Seller', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: BaakasSizes.spaceBtwItems),

          // TypeAheadField for seller selection
          Obx(
            () =>
                sellerController.isLoading.value
                    ? const BaakasShimmerEffect(
                      width: double.infinity,
                      height: 50,
                    )
                    : TypeAheadField(
                      builder: (context, ctr, focusNode) {
                        return TextFormField(
                          focusNode: focusNode,
                          controller: controller.sellerTextField = ctr,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Select Seller',
                            suffixIcon: Icon(Iconsax.box),
                          ),
                        );
                      },
                      suggestionsCallback: (pattern) {
                        // Return filtered seller suggestions based on the search pattern
                        return sellerController.allItems
                            .where((seller) => seller.name.contains(pattern))
                            .toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(title: Text(suggestion.name));
                      },
                      onSelected: (suggestion) {
                        controller.selectedSeller.value = suggestion;
                        controller.sellerTextField.text = suggestion.name;
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
