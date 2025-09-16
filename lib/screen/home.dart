// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/gear_arc.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/left_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cluster_dashboard/map/navigationHome.dart';
import 'package:flutter_cluster_dashboard/provider.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/guages/guage_props.dart';
import 'package:flutter_cluster_dashboard/screen/paints/topbar_paint.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/performance_mode.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/guages/speed_guage_animation_wrapper.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/signals.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/turn_signal.dart';
import 'package:flutter_cluster_dashboard/vehicle_signal/vehicle_signal_provider.dart';
import 'package:intl/intl.dart';

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  GuageColors? getGuageColor(String mode) {
    return (mode == "economy")
        ? GuageProps.ecoModeColor
        : (mode == "sport")
        ? GuageProps.sportModeColor
        : null;
  }

  String addZero(int val) => val.toString().padLeft(2, '0');

  double calcPadding(double value, double height) => (value * height) / 720;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(vehicleSignalProvider);
    final clock = ref.watch(clockProvider);

    final padding = MediaQuery.of(context).padding;
    final windowHeight = MediaQuery.of(context).size.height;
    final windowWidth = MediaQuery.of(context).size.width;

    double screenHeight = windowHeight;
    double screenWidth = windowWidth;

    double ratHeight = (windowWidth * 9) / 16;
    double ratWidth = (windowHeight * 16) / 9;

    if (ratWidth <= windowWidth) {
      screenHeight = windowHeight;
      screenWidth = ratWidth;
    } else {
      screenHeight = ratHeight;
      screenWidth = windowWidth;
    }

    return Container(
      color: GuageProps.bgColor,
      padding: EdgeInsets.only(top: padding.top, bottom: padding.bottom),
      child: Column(
        children: [
          // Top bar
          SizedBox(
            height: (65 * screenHeight) / 480,
            child: Stack(
              children: [
                TurnSignal(
                  screenHeight: screenHeight,
                  isLefton: vehicle.isLeftIndicator,
                  isRighton: vehicle.isRightIndicator,
                ),
                Center(
                  child: SizedBox(
                    width: (400 * screenHeight) / 480,
                    child: CustomPaint(
                      painter: TopBarPainter(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(clock),
                            style: TextStyle(
                              color: const Color.fromARGB(255, 184, 183, 183),
                              fontSize: (20 * screenHeight) / 480,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: (40 * screenHeight) / 480),
                          Text(
                            "${clock.hour}:${addZero(clock.minute)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: (30 * screenHeight) / 480,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: (30 * screenHeight) / 480),
                          Text(
                            "${vehicle.ambientAirTemp} \u00B0C",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 184, 183, 183),
                              fontSize: (20 * screenHeight) / 480,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Mid section
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final midHeight = constraints.maxHeight;
              final midWidth = constraints.maxWidth / 2.0;

              return Stack(
                alignment: Alignment.center,
                children: [
                  // Left Arc
                  Positioned(
                    top: midHeight * 0.15,
                    left: midWidth - 200,
                    child: SizedBox(
                      height: midHeight * 0.6,
                      child: LeftArc(screenHeight: screenHeight),
                    ),
                  ),

                  // Gear Arc (Right)
                  Positioned(
                    top: midHeight * 0.05,
                    right: midWidth - 385,
                    child: SizedBox(
                      height: midHeight * 0.6,
                      child: GearArc(screenHeight: screenHeight),
                    ),
                  ),

                  // Center Speedometer
                  Center(
                    child: SizedBox(
                      height: midHeight * 0.7,
                      child: SpeedGauge(
                        screenHeight: screenHeight,
                        guageColor: getGuageColor(vehicle.performanceMode),
                      ),
                    ),
                  ),

                  // Performance mode above speedometer
                  Positioned(
                    top: midHeight * 0.08,
                    child: PerformanceMode(
                      size: Size(
                        (90 * screenHeight) / 480,
                        (20 * screenHeight) / 480,
                      ),
                      mode: vehicle.performanceMode,
                    ),
                  ),

                  // Warnings below
                  Positioned(
                    bottom: midHeight * 0.05,
                    child: Signals(
                      screenHeight: screenHeight,
                      vehicle: vehicle,
                    ),
                  ),
                ],
              );
            }),
          ),

        ],
      ),
    );
  }
}
