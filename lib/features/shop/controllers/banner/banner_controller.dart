import 'package:baakas_admin/data/abstract/base_data_table_controller.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/banners/banners_repository.dart';
import '../../models/banner_model.dart';

class BannerController extends BaakasBaseController<BannerModel> {
  static BannerController get instance => Get.find();

  final _bannerRepository = Get.put(BannerRepository());

  @override
  Future<void> deleteItem(BannerModel item) async {
    await _bannerRepository.deleteBanner(item.id ?? '');
  }

  @override
  Future<List<BannerModel>> fetchItems() async {
    return await _bannerRepository.getAllBanners();
  }

  /// Method for formatting a route string.
  String formatRoute(String route) {
    try {
      if (route.isEmpty) return '';
      if (route.length == 1) return route;

      // Remove the leading '/'
      String formatted = route.substring(1);

      // Capitalize the first character
      formatted = formatted[0].toUpperCase() + formatted.substring(1);

      return formatted;
    } catch (e) {
      print(e);
      return '';
    }
  }

  @override
  bool containsSearchQuery(BannerModel item, String query) {
    return false;
  }
}
