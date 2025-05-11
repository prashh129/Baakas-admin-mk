import 'package:baakas_admin/features/authentication/screens/password_configuration/reset_password/reset_password.dart';
import 'package:baakas_admin/features/media/screens/media/media.dart';
import 'package:baakas_admin/features/personalization/screens/profile/profile.dart';
import 'package:baakas_admin/features/personalization/screens/settings/settings.dart';
import 'package:baakas_admin/features/shop/screens/banner/edit_banner/edit_banner.dart';
import 'package:baakas_admin/features/shop/screens/category/all_categories/categories.dart';
import 'package:baakas_admin/features/shop/screens/category/create_category/create_category.dart';
import 'package:baakas_admin/features/shop/screens/category/edit_category/edit_category.dart';
import 'package:baakas_admin/features/shop/screens/customer/all_customers/customers.dart';
import 'package:baakas_admin/features/shop/screens/kyc/kyc_review_screen.dart';
import 'package:baakas_admin/features/shop/screens/order/orders_detail/order_detail.dart'
    show OrderDetailScreen;
import 'package:baakas_admin/features/shop/screens/product/all_products/all_products_screen.dart';
import 'package:baakas_admin/features/shop/screens/product/create_product/create_product.dart';
import 'package:baakas_admin/features/shop/screens/product/edit_product/edit_product.dart';
import 'package:baakas_admin/features/shop/screens/seller/all_sellers/sellers.dart';
import 'package:baakas_admin/features/shop/screens/seller/create_seller/create_seller.dart';
import 'package:baakas_admin/features/shop/screens/seller/edit_seller/edit_seller.dart';
import 'package:baakas_admin/features/shop/screens/seller/seller_details/seller_details_screen.dart';
import 'package:get/get.dart';
import '../features/authentication/screens/forget_password/forget_password.dart';
import '../features/authentication/screens/login/login.dart';
import '../features/shop/screens/banner/all_banners/banners.dart';
import '../features/shop/screens/banner/create_banner/create_banner.dart';
import '../features/shop/screens/coupon/all_coupons/coupons.dart';
import '../features/shop/screens/coupon/create_coupon/create_coupon.dart';
import '../features/shop/screens/customer/customer_detail/customer.dart';
import '../features/shop/screens/dashboard/dashboard.dart';
import '../features/shop/screens/order/all_orders/orders.dart';
import 'routes.dart';
import 'routes_middleware.dart';
import 'package:baakas_admin/common/widgets/page_not_found/page_not_found.dart';

class BaakasAppRoute {
  static final List<GetPage> pages = [
    GetPage(name: BaakasRoutes.login, page: () => const LoginScreen()),
    GetPage(
      name: BaakasRoutes.forgetPassword,
      page: () => const ForgetPasswordScreen(),
    ),
    GetPage(
      name: BaakasRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
    ),
    GetPage(
      name: BaakasRoutes.dashboard,
      page: () => const DashboardScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.media,
      page: () => const MediaScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),

    // Banners
    GetPage(
      name: BaakasRoutes.banners,
      page: () => const BannersScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.createBanner,
      page: () => const CreateBannerScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.editBanner,
      page: () => const EditBannerScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),

    // Products
    GetPage(
      name: BaakasRoutes.products,
      page: () => const AllProductsScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.createProduct,
      page: () => const CreateProductScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.editProduct,
      page: () => const EditProductScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),

    // Categories
    GetPage(
      name: BaakasRoutes.categories,
      page: () => const CategoriesScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.createCategory,
      page: () => const CreateCategoryScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.editCategory,
      page: () => const EditCategoryScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),

    // Sellers
    GetPage(
      name: BaakasRoutes.sellers,
      page: () => const SellersScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.createSeller,
      page: () => const CreateSellerScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.editSeller,
      page: () => const EditSellerScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.sellerDetails,
      page: () {
        final seller = Get.arguments;
        return seller != null ? SellerDetailsScreen(seller: seller) : const BaakasPageNotFound();
      },
      middlewares: [BaakasRouteMiddleware()],
    ),

    // Coupons
    GetPage(
      name: BaakasRoutes.coupons,
      page: () => const CouponsScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.createCoupon,
      page: () => const CreateCouponScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),

    // Customers
    GetPage(
      name: BaakasRoutes.customers,
      page: () => const CustomersScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.customerDetails,
      page: () => const CustomerDetailScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),

    // Orders
    GetPage(
      name: BaakasRoutes.orders,
      page: () => const OrdersScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.orderDetails,
      page: () => const OrderDetailScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),

    // Settings
    GetPage(
      name: BaakasRoutes.settings,
      page: () => const SettingsScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.profile,
      page: () => const ProfileScreen(),
      middlewares: [BaakasRouteMiddleware()],
    ),
    GetPage(
      name: BaakasRoutes.kycReview,
      page: () => const KYCReviewScreen(),
    ),

  ];
}
