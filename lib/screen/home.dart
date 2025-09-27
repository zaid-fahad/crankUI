// SPDX-License-Identifier: Apache-2.0
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/gear_arc.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/left_bar.dart';
import 'package:flutter_cluster_dashboard/provider.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/guages/guage_props.dart';
import 'package:flutter_cluster_dashboard/screen/paints/topbar_paint.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/performance_mode.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/guages/speed_guage_animation_wrapper.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/signals.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/turn_signal.dart';
import 'package:flutter_cluster_dashboard/vehicle_signal/vehicle_signal_provider.dart';
import 'package:intl/intl.dart';

import '../map/navigationHome.dart';

/// Local provider to toggle navigation panel
final navVisibleProvider = StateProvider<bool>((ref) => true);

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(vehicleSignalProvider);
    final clock = ref.watch(clockProvider);
    // final navVisible = ref.watch(navVisibleProvider);
    final navVisible = true;
    final padding = MediaQuery.of(context).padding;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                Align(
                  alignment: Alignment.center,
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
                              color: const Color(0xFFFFFFFF),
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

          // Mid section with animation
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final midHeight = constraints.maxHeight;

                return Stack(
                  children: [
                    // Navigation panel
                    // AnimatedPositioned(
                    //   duration: const Duration(milliseconds: 400),
                    //   curve: Curves.easeInOut,
                    //   top: 0,
                    //   bottom: 0,
                    //   right: navVisible ? 0: -screenWidth * 0.7,
                    //   width: screenWidth * 0.35,
                    //   child: const NavigationHome(),
                    // ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      top: 0,
                      bottom: 0,
                      right: navVisible ? 0 : -screenWidth * 0.7,
                      width: screenWidth * 0.35,
                      child: const ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          bottomLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                        child: NavigationHome(),
                      ),
                    ),


                    // Dashboard that shifts left
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      top: 0,
                      bottom: 0,
                      left: navVisible ? -screenWidth * 0.2 : 0,
                      right: navVisible ? screenWidth * 0.1 : 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PerformanceMode(
                            size: Size(
                              (90 * screenHeight) / 480,
                              (20 * screenHeight) / 480,
                            ),
                            mode: vehicle.performanceMode,
                          ),
                          SizedBox(height: midHeight * 0.04),
                          Center(
                            child: SizedBox(
                              height: midHeight * 0.7,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: const Alignment(-0.2, -0.6),
                                    child: SizedBox(
                                      height: midHeight * 0.6,
                                      child: LeftArc(screenHeight: midHeight),
                                    ),
                                  ),
                                  SizedBox(
                                    height: midHeight * 0.7,
                                    child: SpeedGauge(
                                      screenHeight: midHeight * 1.2,
                                      guageColor: getGuageColor(
                                          vehicle.performanceMode),
                                    ),
                                  ),
                                  Align(
                                    alignment: const Alignment(0.3, -2.6),
                                    child: SizedBox(
                                      height: midHeight * 0.6,
                                      child: GearArc(screenHeight: midHeight),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: midHeight * 0.05),
                          Signals(
                            screenHeight: screenHeight,
                            vehicle: vehicle,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
