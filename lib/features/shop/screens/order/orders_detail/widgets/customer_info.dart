import 'package:baakas_admin/features/shop/controllers/order/order_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/order_model.dart';

class OrderCustomer extends StatelessWidget {
  const OrderCustomer({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderDetailController());
    controller.order.value = order;
    controller.getCustomerOfCurrentOrder();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal Info
        BaakasRoundedContainer(
          padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: BaakasSizes.spaceBtwSections),
              Obx(() {
                return Row(
                  children: [
                    BaakasRoundedImage(
                      padding: 0,
                      backgroundColor: BaakasColors.primaryBackground,
                      image:
                          controller.customer.value.profilePicture.isNotEmpty
                              ? controller.customer.value.profilePicture
                              : BaakasImages.user,
                      imageType:
                          controller.customer.value.profilePicture.isNotEmpty
                              ? ImageType.network
                              : ImageType.asset,
                    ),
                    const SizedBox(width: BaakasSizes.spaceBtwItems),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.customer.value.fullName,
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            controller.customer.value.email,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: BaakasSizes.spaceBtwSections),

        // Contact Info
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: BaakasRoundedContainer(
              padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Person',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: BaakasSizes.spaceBtwSections),
                  Text(
                    controller.customer.value.fullName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: BaakasSizes.spaceBtwItems / 2),
                  Text(
                    controller.customer.value.email,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: BaakasSizes.spaceBtwItems / 2),
                  Text(
                    controller.customer.value.formattedPhoneNo.isNotEmpty
                        ? controller.customer.value.formattedPhoneNo
                        : '(+1) *** ****',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: BaakasSizes.spaceBtwSections),

        // Contact Info
        SizedBox(
          width: double.infinity,
          child: BaakasRoundedContainer(
            padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipping Address',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: BaakasSizes.spaceBtwSections),
                Text(
                  order.shippingAddress != null
                      ? order.shippingAddress!.name
                      : '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: BaakasSizes.spaceBtwItems / 2),
                Text(
                  order.shippingAddress != null
                      ? order.shippingAddress!.toString()
                      : '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: BaakasSizes.spaceBtwSections),

        // Contact Info: Adjust this address as per your needs
        SizedBox(
          width: double.infinity,
          child: BaakasRoundedContainer(
            padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Billing Address',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: BaakasSizes.spaceBtwSections),
                Text(
                  order.billingAddressSameAsShipping
                      ? order.shippingAddress!.name
                      : order.billingAddress!.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: BaakasSizes.spaceBtwItems / 2),
                Text(
                  order.billingAddressSameAsShipping
                      ? order.shippingAddress!.toString()
                      : order.billingAddress!.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: BaakasSizes.spaceBtwSections),
      ],
    );
  }
}
