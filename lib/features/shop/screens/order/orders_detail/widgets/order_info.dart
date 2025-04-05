import 'package:baakas_admin/common/widgets/shimmers/shimmer.dart';
import 'package:baakas_admin/features/shop/controllers/order/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../models/order_model.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    controller.orderStatus.value = order.status;
    return BaakasRoundedContainer(
      padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: BaakasSizes.spaceBtwSections),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date'),
                    Text(
                      order.formattedOrderDate,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Items'),
                    Text(
                      '${order.items.length} Items',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: BaakasDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status'),
                    Obx(() {
                      if (controller.statusLoader.value) {
                        return const BaakasShimmerEffect(
                          width: double.infinity,
                          height: 55,
                        );
                      }
                      return BaakasRoundedContainer(
                        radius: BaakasSizes.cardRadiusSm,
                        padding: const EdgeInsets.symmetric(
                          horizontal: BaakasSizes.sm,
                          vertical: 0,
                        ),
                        backgroundColor:
                            BaakasHelperFunctions.getOrderStatusColor(
                              controller.orderStatus.value,
                            ).withOpacity(0.1),
                        child: DropdownButton<OrderStatus>(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          value: controller.orderStatus.value,
                          onChanged: (OrderStatus? newValue) {
                            if (newValue != null) {
                              controller.updateOrderStatus(order, newValue);
                            }
                          },
                          items:
                              OrderStatus.values.map((OrderStatus status) {
                                return DropdownMenuItem<OrderStatus>(
                                  value: status,
                                  child: Text(
                                    status.name.capitalize.toString(),
                                    style: TextStyle(
                                      color:
                                          BaakasHelperFunctions.getOrderStatusColor(
                                            controller.orderStatus.value,
                                          ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total'),
                    Text(
                      '\$${order.totalAmount}',
                      style: Theme.of(context).textTheme.bodyLarge,
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
}
