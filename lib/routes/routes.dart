// routes.dart

class BaakasRoutes {
  static const login = '/login';
  static const forgetPassword = '/forgetPassword';
  static const resetPassword = '/resetPassword';
  static const dashboard = '/dashboard';
  static const media = '/media';
  static const kycReview = '/kyc-review'; // edited by prashant mk
  static const String sellerDetails = '/seller-details';

  static const banners = '/banners';
  static const createBanner = '/createBanner';
  static const editBanner = '/editBanner';

  static const products = '/products';
  static const createProduct = '/createProducts';
  static const editProduct = '/editProduct';

  static const categories = '/categories';
  static const createCategory = '/createCategory';
  static const editCategory = '/editCategory';

  static const sellers = '/sellers';
  static const createSeller = '/createSeller';
  static const editSeller = '/editSeller';

  static const customers = '/customers';
  static const createCustomer = '/createCustomer';
  static const customerDetails = '/customerDetails';

  static const orders = '/orders';
  static const orderDetails = '/orderDetails';

  static const coupons = '/coupons';
  static const createCoupon = '/createCoupon';
  static const editCoupon = '/editCoupon';

  static const settings = '/settings';
  static const profile = '/profile';

  static const String productManagement = '/product-management';

  static List sideMenuItems = [
    login,
    forgetPassword,
    dashboard,
    media,
    products,
    categories,
    sellers,
    customers,
    orders,
    coupons,
    settings,
    profile,
  ];



// All App Screens
static const String appHome = '/';
static const String appStore = '/store';
static const String appFavourites = '/favourites';
static const String appSettings = '/settings';

  static const subCategories = '/sub-categories';
  static const search = '/search';
  static const productReviews = '/product-reviews';
  static const productDetail = '/product-detail';
  static const order = '/order';
  static const checkout = '/checkout';
  static const cart = '/cart';
  static const seller = '/seller';
  static const allProducts = '/all-products';
  static const userProfile = '/user-profile';
  static const userAddress = '/user-address';
  static const appSignUp = '/signup';
  static const appSignupSuccess = '/signup-success';
  static const appVerifyEmail = '/verify-email';
  static const appSignIn = '/sign-in';
  static const appResetPassword = '/reset-password';
  static const appForgetPassword = '/forget-password';
  static const appOnBoarding = '/on-boarding';

  static List<String> allAppScreenItems = [
    appOnBoarding,
    appSignIn,
    appSignUp,
    appVerifyEmail,
    appResetPassword,
    appForgetPassword,
    appHome,
    appStore,
    appFavourites,
    appSettings,
    subCategories,
    search,
    productDetail,
    productReviews,
    order,
    checkout,
    cart,
    seller,
    allProducts,
    userProfile,
    userAddress,
  ];
}
