import 'package:baakas_admin/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';


class CreateCouponScreen extends StatelessWidget {
  const CreateCouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CouponController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BaakasBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Create Coupon',
                breadcrumbItems: [BaakasRoutes.coupons, 'Create Coupon'],
              ),
              const SizedBox(height: BaakasSizes.spaceBtwSections),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.couponCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Coupon Code',
                        prefixIcon: Icon(Iconsax.tag),
                      ),
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwInputFields),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.discountValueController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Discount Value',
                              prefixIcon: Icon(Iconsax.discount_shape),
                            ),
                          ),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwItems),
                        DropdownButton<bool>(
                          value: controller.isPercentage.value,
                          items: const [
                            DropdownMenuItem(value: true, child: Text('%')),
                            DropdownMenuItem(value: false, child: Text('Rs')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.isPercentage.value = value;
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.minPurchaseController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Minimum Purchase (Rs)',
                        prefixIcon: Icon(Iconsax.money),
                      ),
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.maxDiscountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Maximum Discount (Rs)',
                        prefixIcon: Icon(Iconsax.money),
                      ),
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwInputFields),
                    ListTile(
                      title: const Text('Valid From'),
                      subtitle: Obx(() => Text(controller.validFrom.value.toString())),
                      trailing: const Icon(Iconsax.calendar),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: controller.validFrom.value,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          controller.validFrom.value = picked;
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('Expires On'),
                      subtitle: Obx(() => Text(controller.expiresOn.value.toString())),
                      trailing: const Icon(Iconsax.calendar),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: controller.expiresOn.value,
                          firstDate: controller.validFrom.value,
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          controller.expiresOn.value = picked;
                        }
                      },
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.createCoupon(),
                        child: const Text('Create Coupon'),
                      ),
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