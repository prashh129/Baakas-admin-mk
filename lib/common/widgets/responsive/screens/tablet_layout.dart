import 'package:flutter/material.dart';

import '../../layouts/headers/header.dart';
import '../../layouts/sidebars/sidebar.dart';

/// Widget for the tablet layout
class TabletLayout extends StatelessWidget {
  TabletLayout({super.key, this.body});

  /// Widget to be displayed as the body of the tablet layout
  final Widget? body;

  /// Key for the scaffold widget
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const BaakasSidebar(), // Sidebar
      appBar: BaakasHeader(scaffoldKey: scaffoldKey), // Header
      body: body ?? Container(), // Body
    );
  }
}
