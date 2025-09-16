// // SPDX-License-Identifier: Apache-2.0
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_cluster_dashboard/cluster_config.dart';
// import 'package:flutter_cluster_dashboard/screen/home.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_cluster_dashboard/vehicle_signal/vehicle_signal_config.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   HttpClient client = await initializeClient();
//   runApp(
//     const ProviderScope(
//       child: MaterialApp(
//         // home: GetConfig(client: client),
//         home: Home(),
//       ),
//     ),
//   );
// }

// SPDX-License-Identifier: Apache-2.0

import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_cluster_dashboard/cluster_config.dart';
// import 'package:flutter_cluster_dashboard/screen/crankUI.dart';
import 'package:flutter_cluster_dashboard/screen/home.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_cluster_dashboard/vehicle_signal/vehicle_signal_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpClient client = await initializeClient();

  runApp(
    ProviderScope(
      child: MyApp(client: client),
    ),
  );
}

class MyApp extends StatelessWidget {
  final HttpClient client; // Pass client to the widget
  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xFFFFFFFF),
      builder: (context, child) {
        return const Directionality(
          textDirection: TextDirection.ltr,
          // child: GetConfig(client: client),
          child: Home(),
          // child: HomeScreen(),
          // or use Home() instead of GetConfig if needed
        );
      },
    );
  }
}

