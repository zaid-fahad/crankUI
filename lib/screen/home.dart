// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cluster_dashboard/map/navigationHome.dart';
import 'package:flutter_cluster_dashboard/provider.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/guages/guage_props.dart';
import 'package:flutter_cluster_dashboard/screen/paints/bottombar_paint.dart';
import 'package:flutter_cluster_dashboard/screen/paints/topbar_paint.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/guages/rpm_guage_animation_wrapper.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/left_bar.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/performance_mode.dart';
import 'package:flutter_cluster_dashboard/screen/widgets/right_bar.dart';
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

  String addZero(int val) {
    final res = val.toString();
    if (res.length < 2) {
      return res.isEmpty ? "00" : "0$res";
    }
    return res;
  }

  double calcPadding(double value, double height) {
    // values wrt to values at 720 height
    return (value * height) / 720;
  }

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
      padding: EdgeInsets.only(
        top: padding.top,
        bottom: padding.bottom,
      ),
      child: Center(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top bar
              Flexible(
                flex: 1,
                child: Stack(
                  children: [
                    TurnSignal(
                      screenHeight: screenHeight,
                      isLefton: vehicle.isLeftIndicator,
                      isRighton: vehicle.isRightIndicator,
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: (400 * screenHeight) / 480,
                            height: (65 * screenHeight) / 480,
                            child: CustomPaint(
                              painter: TopBarPainter(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('EEEE')
                                        .format(clock)
                                        .substring(0, 3),
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 184, 183, 183),
                                      fontSize: (20 * screenHeight) / 480,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: (40 * screenHeight) / 480),
                                  Text(
                                    "${clock.hour}:${addZero(clock.minute)}",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize: (30 * screenHeight) / 480,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: (30 * screenHeight) / 480),
                                  Text(
                                    "${vehicle.ambientAirTemp} ${"\u00B0"}C",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 184, 183, 183),
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
                  ],
                ),
              ),

              // Mid section
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: Stack(
                  children: [
                    // left/right arc
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        calcPadding(60, screenHeight),
                        calcPadding(60, screenHeight),
                        calcPadding(60, screenHeight),
                        0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              LeftArc(screenHeight: screenHeight),
                              Positioned(
                                child: Image.asset(
                                  "images/temperature-icon.png",
                                  color: const Color(0xFFFFFFFF),
                                  width: (13 * screenHeight) / 480,
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              RightArc(screenHeight: screenHeight),
                              Positioned(
                                child: Image.asset(
                                  "images/fuel-icon.png",
                                  color: const Color(0xFFFFFFFF),
                                  width: (18 * screenHeight) / 480,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // logo / nav
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        calcPadding(60, screenHeight),
                        calcPadding(10, screenHeight),
                        calcPadding(60, screenHeight),
                        0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: (550 * screenHeight) / 720,
                            height: (450 * screenHeight) / 720,
                            child: Flex(
                              direction: Axis.vertical,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: PerformanceMode(
                                    size: Size(
                                      (90 * screenHeight) / 480,
                                      (20 * screenHeight) / 480,
                                    ),
                                    mode: vehicle.performanceMode,
                                  ),
                                ),
                                Flexible(
                                  flex: 6,
                                  fit: FlexFit.tight,
                                  child: SizedBox(
                                    width: (330 * screenHeight) / 720,
                                    child: (vehicle.isSteeringInfo)
                                        ? const NavigationHome()
                                        : Padding(
                                      padding: EdgeInsets.all(
                                        (48.0 * screenHeight) / 720,
                                      ),
                                      child: Image.asset(
                                        "images/logo_agl.png",
                                        width:
                                        (90 * screenHeight) / 480,
                                        color:
                                        const Color(0xFF757575),
                                      ),
                                    ),
                                  ),
                                ),
                                const Flexible(flex: 1, child: SizedBox()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // warnings
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        calcPadding(0, screenHeight),
                        calcPadding(430, screenHeight),
                        calcPadding(0, screenHeight),
                        0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Signals(
                            screenHeight: screenHeight,
                            vehicle: vehicle,
                          ),
                        ],
                      ),
                    ),

                    // gauges
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        calcPadding(70, screenHeight),
                        calcPadding(30, screenHeight),
                        calcPadding(70, screenHeight),
                        0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SpeedGauge(
                            screenHeight: screenHeight,
                            guageColor:
                            getGuageColor(vehicle.performanceMode),
                          ),
                          RPMGauge(
                            screenHeight: screenHeight,
                            guageColor:
                            getGuageColor(vehicle.performanceMode),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // bottom bar
              Flexible(
                flex: 1,
                child: SizedBox(
                  width: (400 * screenHeight) / 480,
                  height: (50 * screenHeight) / 480,
                  child: CustomPaint(
                    size: Size(
                      (400 * screenHeight) / 480,
                      (50 * screenHeight) / 480,
                    ),
                    painter: BottomBarPainter(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "P",
                          style: vehicle.selectedGear == Gear.parking
                              ? GuageProps.activeGearIconStyle(screenHeight)
                              : GuageProps.gearIconStyle(screenHeight),
                        ),
                        Text(
                          "R",
                          style: vehicle.selectedGear == Gear.reverse
                              ? GuageProps.activeGearIconStyle(screenHeight)
                              : GuageProps.gearIconStyle(screenHeight),
                        ),
                        Text(
                          "N",
                          style: vehicle.selectedGear == Gear.neutral
                              ? GuageProps.activeGearIconStyle(screenHeight)
                              : GuageProps.gearIconStyle(screenHeight),
                        ),
                        Text(
                          "D",
                          style: vehicle.selectedGear == Gear.drive
                              ? GuageProps.activeGearIconStyle(screenHeight)
                              : GuageProps.gearIconStyle(screenHeight),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
