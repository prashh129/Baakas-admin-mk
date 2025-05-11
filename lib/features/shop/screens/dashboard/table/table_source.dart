import 'package:baakas_admin/data/repositories/user/user_repository.dart';
import 'package:baakas_admin/features/personalization/models/user_model.dart';
import 'package:baakas_admin/routes/routes.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../../common/widgets/loaders/shimmer.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/order/order_controller.dart';

class OrderRows extends DataTableSource {
  final controller = OrderController.instance;
  final userRepository = Get.put(UserRepository());
  final Map<String, UserModel> _userCache = {};

  Future<UserModel> _getUserDetails(String userId) async {
    if (userId.isEmpty) return UserModel.empty();
    if (_userCache.containsKey(userId)) return _userCache[userId]!;
    
    final user = await userRepository.fetchUserDetails(userId);
    _userCache[userId] = user;
    return user;
  }

  @override
  DataRow? getRow(int index) {
    final order = controller.filteredItems[index];
    
    return DataRow2(
      onTap: () => Get.toNamed(BaakasRoutes.orderDetails, arguments: order),
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Text(
            order.id,
            style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: BaakasColors.primary),
          ),
        ),
        DataCell(Text('${order.items.length} Items')),
        DataCell(
          FutureBuilder<UserModel>(
            future: _getUserDetails(order.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const BaakasShimmerEffect(width: 80, height: 20);
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Text('N/A');
              }
              return Text(snapshot.data!.fullName);
            },
          ),
        ),
        DataCell(
          FutureBuilder<UserModel>(
            future: _getUserDetails(order.sellerId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const BaakasShimmerEffect(width: 80, height: 20);
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Text('N/A');
              }
              return Text(snapshot.data!.fullName);
            },
          ),
        ),
        DataCell(
          BaakasRoundedContainer(
            radius: BaakasSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: BaakasSizes.xs,
              horizontal: BaakasSizes.md,
            ),
            backgroundColor: BaakasHelperFunctions.getOrderStatusColor(
              order.status,
            ).withOpacity(0.1),
            child: Text(
              order.status.name.capitalize.toString(),
              style: TextStyle(
                color: BaakasHelperFunctions.getOrderStatusColor(order.status),
              ),
            ),
          ),
        ),
        DataCell(Text('Rs ${order.totalAmount}')),
        DataCell(Text(order.formattedOrderDate)),
        DataCell(
          BaakasTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => Get.toNamed(BaakasRoutes.orderDetails, arguments: order),
            onDeletePressed: () => controller.confirmAndDeleteItem(order),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount => controller.selectedRows.where((selected) => selected).length;
}
