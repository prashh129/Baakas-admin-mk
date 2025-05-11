import 'package:baakas_admin/features/shop/controllers/seller/edit_seller_controller.dart';
import 'package:baakas_admin/features/shop/models/seller_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/validators/validation.dart';



class SellerDetailsScreen extends StatelessWidget {
  const SellerDetailsScreen({super.key, required this.seller});

  final SellerModel seller;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditSellerController());
    controller.init(seller);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BaakasBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Seller Details',
                breadcrumbItems: [BaakasRoutes.sellers, 'Seller Details'],
              ),
              const SizedBox(height: BaakasSizes.spaceBtwSections),

              // Seller Information
              BaakasRoundedContainer(
                padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seller Information', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    
                    // Basic Info
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.name,
                            validator: (value) => BaakasValidator.validateEmptyText('Name', value),
                            decoration: const InputDecoration(
                              labelText: 'Seller Name',
                              prefixIcon: Icon(Iconsax.user),
                            ),
                          ),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: controller.businessPanNumber,
                            decoration: const InputDecoration(
                              labelText: 'Business PAN Number',
                              prefixIcon: Icon(Iconsax.document),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwSections),

                    // Contact Information
                    Text('Contact Information', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.phoneNumber,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Iconsax.call),
                            ),
                          ),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: controller.email,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Iconsax.sms),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    TextFormField(
                      controller: controller.businessAddress,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Business Address',
                        prefixIcon: Icon(Iconsax.location),
                      ),
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.website,
                            decoration: const InputDecoration(
                              labelText: 'Website',
                              prefixIcon: Icon(Iconsax.global),
                            ),
                          ),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Social Media Links',
                              prefixIcon: Icon(Iconsax.share),
                            ),
                            onTap: () {
                              // TODO: Show dialog to add/edit social media links
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwSections),

                    // Business Details
                    Text('Business Details', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.businessRegistrationNumber,
                            decoration: const InputDecoration(
                              labelText: 'Business Registration Number',
                              prefixIcon: Icon(Iconsax.document),
                            ),
                          ),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: controller.businessType,
                            decoration: const InputDecoration(
                              labelText: 'Business Type',
                              prefixIcon: Icon(Iconsax.building),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    TextFormField(
                      controller: controller.businessDescription,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Business Description',
                        prefixIcon: Icon(Iconsax.note),
                      ),
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.yearsInBusiness,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Years in Business',
                              prefixIcon: Icon(Iconsax.calendar),
                            ),
                          ),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Business Hours',
                              prefixIcon: Icon(Iconsax.clock),
                            ),
                            onTap: () {
                              // TODO: Show dialog to set business hours
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwSections),

                    // Bank Details
                    Text('Bank Details', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.bankName,
                            decoration: const InputDecoration(
                              labelText: 'Bank Name',
                              prefixIcon: Icon(Iconsax.bank),
                            ),
                          ),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: controller.bankBranch,
                            decoration: const InputDecoration(
                              labelText: 'Branch',
                              prefixIcon: Icon(Iconsax.location),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.accountHolder,
                            decoration: const InputDecoration(
                              labelText: 'Account Holder',
                              prefixIcon: Icon(Iconsax.user),
                            ),
                          ),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: controller.bankAccountNumber,
                            decoration: const InputDecoration(
                              labelText: 'Account Number',
                              prefixIcon: Icon(Iconsax.card),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.ifscCode,
                            decoration: const InputDecoration(
                              labelText: 'IFSC Code',
                              prefixIcon: Icon(Iconsax.code),
                            ),
                          ),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: controller.accountType,
                            decoration: const InputDecoration(
                              labelText: 'Account Type',
                              prefixIcon: Icon(Iconsax.wallet),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwSections),

                    // Documents
                    Text('Documents', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Citizenship Document'),
                              const SizedBox(height: BaakasSizes.spaceBtwItems),
                              Obx(() => BaakasImageUploader(
                                image: controller.citizenshipImageURL.value.isNotEmpty 
                                    ? controller.citizenshipImageURL.value 
                                    : seller.citizenshipImage ?? '',
                                imageType: ImageType.network,
                                onImageSelected: (image) {
                                  controller.citizenshipImageURL.value = image;
                                },
                              )),
                              if (controller.citizenshipImageURL.value.isEmpty && (seller.citizenshipImage?.isEmpty ?? true))
                                Padding(
                                  padding: const EdgeInsets.only(top: BaakasSizes.xs),
                                  child: Text(
                                    'Citizenship document is required',
                                    style: Theme.of(context).textTheme.bodySmall?.apply(color: Colors.red),
                                  ),
                                ),
                              const SizedBox(height: BaakasSizes.spaceBtwItems),
                              Obx(() => TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Expiry Date',
                                  prefixIcon: Icon(Iconsax.calendar),
                                ),
                                controller: TextEditingController(
                                  text: controller.citizenshipExpiryDate.value?.toString() ?? '',
                                ),
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: controller.citizenshipExpiryDate.value ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                                  );
                                  if (date != null) {
                                    controller.citizenshipExpiryDate.value = date;
                                  }
                                },
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwItems),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Business PAN Document'),
                              const SizedBox(height: BaakasSizes.spaceBtwItems),
                              Obx(() => BaakasImageUploader(
                                image: controller.businessPanImageURL.value.isNotEmpty 
                                    ? controller.businessPanImageURL.value 
                                    : seller.businessPanImage ?? '',
                                imageType: ImageType.network,
                                onImageSelected: (image) {
                                  controller.businessPanImageURL.value = image;
                                },
                              )),
                              if (controller.businessPanImageURL.value.isEmpty && (seller.businessPanImage?.isEmpty ?? true))
                                Padding(
                                  padding: const EdgeInsets.only(top: BaakasSizes.xs),
                                  child: Text(
                                    'Business PAN document is required',
                                    style: Theme.of(context).textTheme.bodySmall?.apply(color: Colors.red),
                                  ),
                                ),
                              const SizedBox(height: BaakasSizes.spaceBtwItems),
                              Obx(() => TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Expiry Date',
                                  prefixIcon: Icon(Iconsax.calendar),
                                ),
                                controller: TextEditingController(
                                  text: controller.panExpiryDate.value?.toString() ?? '',
                                ),
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: controller.panExpiryDate.value ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                                  );
                                  if (date != null) {
                                    controller.panExpiryDate.value = date;
                                  }
                                },
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwItems),
                    Obx(() => Container(
                      padding: const EdgeInsets.all(BaakasSizes.sm),
                      decoration: BoxDecoration(
                        color: controller.documentVerificationStatus.value == 'verified'
                            ? Colors.green.withOpacity(0.1)
                            : (controller.documentVerificationStatus.value == 'rejected'
                                ? Colors.red.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(BaakasSizes.borderRadiusMd),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Document Verification Status: ${controller.documentVerificationStatus.value.toUpperCase()}',
                            style: Theme.of(context).textTheme.bodyLarge?.apply(
                              color: controller.documentVerificationStatus.value == 'verified'
                                  ? Colors.green
                                  : (controller.documentVerificationStatus.value == 'rejected'
                                      ? Colors.red
                                      : Colors.orange),
                            ),
                          ),
                          if (controller.documentVerificationStatus.value == 'pending')
                            TextButton(
                              onPressed: () {
                                // TODO: Show document history dialog
                              },
                              child: const Text('View History'),
                            ),
                        ],
                      ),
                    )),
                    const SizedBox(height: BaakasSizes.spaceBtwSections),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwItems),
                        ElevatedButton(
                          onPressed: () {
                            // Update seller details
                            controller.updateSeller(seller);
                          },
                          child: const Text('Save Changes'),
                        ),
                      ],
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