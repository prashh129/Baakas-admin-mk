// routes.dart

class BaakasRoutes {
  static const login = '/login';
  static const forgetPassword = '/forgetPassword';
  static const resetPassword = '/resetPassword';
  static const dashboard = '/dashboard';
  static const media = '/media';

  static const banners = '/banners';
  static const createBanner = '/createBanner';
  static const editBanner = '/editBanner';

  static const products = '/products';
  static const createProduct = '/createProducts';
  static const editProduct = '/editProduct';

  static const categories = '/categories';
  static const createCategory = '/createCategory';
  static const editCategory = '/editCategory';

  static const brands = '/brands';
  static const createBrand = '/createBrand';
  static const editBrand = '/editBrand';

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

  static List sideMenuItems = [
    login,
    forgetPassword,
    dashboard,
    media,
    products,
    categories,
    brands,
    customers,
    orders,
    coupons,
    settings,
    profile,
  ];
}

// All App Screens
class AppScreens {
  static const home = '/';
  static const store = '/store';
  static const favourites = '/favourites';
  static const settings = '/settings';
  static const subCategories = '/sub-categories';
  static const search = '/search';
  static const productReviews = '/product-reviews';
  static const productDetail = '/product-detail';
  static const order = '/order';
  static const checkout = '/checkout';
  static const cart = '/cart';
  static const brand = '/brand';
  static const allProducts = '/all-products';
  static const userProfile = '/user-profile';
  static const userAddress = '/user-address';
  static const signUp = '/signup';
  static const signupSuccess = '/signup-success';
  static const verifyEmail = '/verify-email';
  static const signIn = '/sign-in';
  static const resetPassword = '/reset-password';
  static const forgetPassword = '/forget-password';
  static const onBoarding = '/on-boarding';

  static List<String> allAppScreenItems = [
    onBoarding,
    signIn,
    signUp,
    verifyEmail,
    resetPassword,
    forgetPassword,
    home,
    store,
    favourites,
    settings,
    subCategories,
    search,
    productDetail,
    productReviews,
    order,
    checkout,
    cart,
    brand,
    allProducts,
    userProfile,
    userAddress,
  ];
}
