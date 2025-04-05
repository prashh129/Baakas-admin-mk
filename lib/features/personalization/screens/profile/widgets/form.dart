import 'package:baakas_admin/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/user_controller.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Column(
      children: [
        BaakasRoundedContainer(
          padding: const EdgeInsets.symmetric(
            vertical: BaakasSizes.lg,
            horizontal: BaakasSizes.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: BaakasSizes.spaceBtwSections),

              // First and Last Name
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // First Name
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstNameController,
                            decoration: const InputDecoration(
                              hintText: 'First Name',
                              label: Text('First Name'),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator:
                                (value) => BaakasValidator.validateEmptyText(
                                  'First Name',
                                  value,
                                ),
                          ),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwInputFields),
                        // Last Name
                        Expanded(
                          child: TextFormField(
                            controller: controller.lastNameController,
                            decoration: const InputDecoration(
                              hintText: 'Last Name',
                              label: Text('Last Name'),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator:
                                (value) => BaakasValidator.validateEmptyText(
                                  'Last Name',
                                  value,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BaakasSizes.spaceBtwInputFields),

                    // Email and Phone
                    Row(
                      children: [
                        // First Name
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              label: Text('Email'),
                              prefixIcon: Icon(Iconsax.forward),
                              enabled: false,
                            ),
                            initialValue:
                                UserController.instance.user.value.email,
                          ),
                        ),
                        const SizedBox(width: BaakasSizes.spaceBtwItems),
                        // Last Name
                        Expanded(
                          child: TextFormField(
                            controller: controller.phoneController,
                            decoration: const InputDecoration(
                              hintText: 'Phone Number',
                              label: Text('Phone Number'),
                              prefixIcon: Icon(Iconsax.mobile),
                            ),
                            validator:
                                (value) => BaakasValidator.validateEmptyText(
                                  'Phone Number',
                                  value,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: BaakasSizes.spaceBtwSections),

              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        () =>
                            controller.loading.value
                                ? () {}
                                : controller.updateUserInformation(),
                    child:
                        controller.loading.value
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                            : const Text('Update Profile'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
