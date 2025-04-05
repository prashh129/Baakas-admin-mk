import 'package:baakas_admin/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/general_bindings.dart';
import 'common/widgets/page_not_found/page_not_found.dart';
import 'routes/app_routes.dart';
import 'routes/route_observer.dart';
import 'utils/constants/colors.dart';
import 'utils/constants/text_strings.dart';
import 'utils/device/web_material_scroll.dart';
import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: BaakasTexts.appName,
      themeMode: ThemeMode.light,
      theme: BaakasAppTheme.lightTheme,
      darkTheme: BaakasAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialBinding: GeneralBindings(),
      navigatorObservers: [RouteObservers()],
      scrollBehavior: MyCustomScrollBehavior(),
      initialRoute: BaakasRoutes.dashboard,
      getPages: BaakasAppRoute.pages,
      unknownRoute: GetPage(
        name: '/page-not-found',
        page:
            () => const BaakasPageNotFound(
              isFullPage: true,
              title: 'Oops! You\'ve Ventured into the Abyss of the Internet!',
              subTitle:
                  'Looks like you’ve discovered the Bermuda Triangle of our app. Don\'t worry, we won’t let you stay lost forever. Click the button below to return to safety!',
            ),
      ),
      home: const Scaffold(
        backgroundColor: BaakasColors.primary,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
    );
  }
}
