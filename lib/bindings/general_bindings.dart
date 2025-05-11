import 'package:baakas_admin/features/personalization/controllers/settings_controller.dart';
import 'package:baakas_admin/features/shop/controllers/kyc/kyc_controller.dart';
import 'package:baakas_admin/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:get/get.dart';
import '../features/personalization/controllers/user_controller.dart';
import '../utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    /// -- Core
    Get.lazyPut(() => NetworkManager(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
    
    /// -- Shop
    Get.lazyPut(() => KYCController(), fenix: true);
    Get.lazyPut(() => CouponController(), fenix: true);
  }
}
