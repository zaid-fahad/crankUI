// SPDX-License-Identifier: Apache-2.0
import 'package:flutter/widgets.dart';
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

    final padding = MediaQuery.of(context).padding;
    final screenHeight = MediaQuery.of(context).size.height;

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

          // Mid section
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final midHeight = constraints.maxHeight;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Performance mode
                    PerformanceMode(
                      size: Size(
                        (90 * screenHeight) / 480,
                        (20 * screenHeight) / 480,
                      ),
                      mode: vehicle.performanceMode,
                    ),

                    SizedBox(height: midHeight * 0.04),

                    // Centered cluster: Stack for precise positioning
                    Center(
                      child: SizedBox(
                        height: midHeight * 0.7,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Left Arc
                            Align(
                              alignment: const Alignment(-0.2, -0.6), // left
                              child: SizedBox(
                                height: midHeight * 0.6,
                                child: LeftArc(screenHeight: midHeight),
                              ),
                            ),

                            // Speedometer
                            SizedBox(
                              height: midHeight * 0.7,
                              child: SpeedGauge(
                                screenHeight: midHeight * 1.2,
                                guageColor: getGuageColor(vehicle.performanceMode),
                              ),
                            ),

                            // Gear Arc (can shift slightly up without breaking center)
                            Align(
                              alignment: const Alignment(0.3, - 2.6), // right + slightly up
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

                    // Warnings
                    Signals(
                      screenHeight: screenHeight,
                      vehicle: vehicle,
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
