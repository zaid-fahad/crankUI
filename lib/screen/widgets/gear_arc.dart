// SPDX-License-Identifier: Apache-2.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cluster_dashboard/screen/paints/gear_arc_painter.dart';
import 'package:flutter_cluster_dashboard/vehicle_signal/vehicle_signal_model.dart';
import 'package:flutter_cluster_dashboard/vehicle_signal/vehicle_signal_provider.dart';

class GearArc extends HookConsumerWidget {
  final double screenHeight;
  const GearArc({Key? key, required this.screenHeight}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get current vehicle state
    final VehicleSignal vehicle = ref.watch(vehicleSignalProvider);

    // selected gear (comes from provider)
    final selectedGear = vehicle.selectedGear; // e.g. "P", "R", "N", "D"

    return CustomPaint(
      size: Size((200 * screenHeight) / 480, (120 * screenHeight) / 480),
      painter: GearArcPainter(
        screenHeight: screenHeight,
        selectedGear: selectedGear,
      ),
    );
  }
}
