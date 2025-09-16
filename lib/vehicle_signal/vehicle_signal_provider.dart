// // SPDX-License-Identifier: Apache-2.0
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_cluster_dashboard/vehicle_signal/vehicle_signal_model.dart';
//
// final vehicleSignalProvider =
//     StateNotifierProvider<VehicleSignalNotifier, VehicleSignal>(
//   (ref) => VehicleSignalNotifier(),
// );
//
// class VehicleSignalNotifier extends StateNotifier<VehicleSignal> {
//   VehicleSignalNotifier() : super(_initialValue);
//   static final VehicleSignal _initialValue = VehicleSignal(
//     speed: 140,
//     rpm: 7000,
//     fuelLevel: 50,
//     coolantTemp: 20,
//     isLeftIndicator: false,
//     isRightIndicator: false,
//     selectedGear: "P",
//     performanceMode: "normal",
//     isHazardLightOn: false,
//     isHighBeam: true,
//     isLowBeam: false,
//     isParkingOn: true,
//     travelledDistance: 888,
//     ambientAirTemp: '25',
//     cruiseControlSpeed: 60,
//     isCruiseControlActive: false,
//     isCruiseControlError: false,
//     isMILon: false,
//     isTrunkLocked: true,
//     isTrunkOpen: false,
//     isBatteryCharging: true,
//     isSteeringCruiseEnable: false,
//     isSteeringCruiseSet: false,
//     isSteeringCruiseResume: false,
//     isSteeringCruiseCancel: false,
//     isSteeringInfo: false,
//     isSteeringLaneWarning: false,
//     vehicleDistanceUnit: 'km',
//     currLat: 31.71,
//     currLng: 76.95,
//     desLat: 31.71,
//     desLng: 76.95,
//   );
//   void update({
//     double? speed,
//     double? rpm,
//     double? fuelLevel,
//     double? coolantTemp,
//     bool? isLeftIndicator,
//     bool? isRightIndicator,
//     String? selectedGear,
//     String? performanceMode,
//     String? ambientAirTemp,
//     bool? isLowBeam,
//     bool? isHighBeam,
//     bool? isHazardLightOn,
//     bool? isMILon,
//     bool? isParkingOn,
//     bool? isTrunkOpen,
//     bool? isTrunkLocked,
//     bool? isCruiseControlActive,
//     bool? isCruiseControlError,
//     bool? isBatteryCharging,
//     double? travelledDistance,
//     double? cruiseControlSpeed,
//     //
//     String? vehicleDistanceUnit,
//     bool? isSteeringCruiseEnable,
//     bool? isSteeringCruiseSet,
//     bool? isSteeringCruiseResume,
//     bool? isSteeringCruiseCancel,
//     bool? isSteeringLaneWarning,
//     bool? isSteeringInfo,
//     //
//     double? currLat,
//     double? currLng,
//     double? desLat,
//     double? desLng,
//   }) {
//     state = state.copyWith(
//       speed: speed,
//       rpm: rpm,
//       fuelLevel: fuelLevel,
//       coolantTemp: coolantTemp,
//       isLeftIndicator: isLeftIndicator,
//       isRightIndicator: isRightIndicator,
//       selectedGear: selectedGear,
//       isLowBeam: isLowBeam,
//       isHighBeam: isHighBeam,
//       isHazardLightOn: isHazardLightOn,
//       travelledDistance: travelledDistance,
//       performanceMode: performanceMode,
//       isParkingOn: isParkingOn,
//       isTrunkOpen: isTrunkOpen,
//       isTrunkLocked: isTrunkLocked,
//       isMILon: isMILon,
//       ambientAirTemp: ambientAirTemp,
//       isCruiseControlActive: isCruiseControlActive,
//       isCruiseControlError: isCruiseControlError,
//       cruiseControlSpeed: cruiseControlSpeed,
//       isBatteryCharging: isBatteryCharging,
//       //
//       isSteeringCruiseEnable: isSteeringCruiseEnable,
//       isSteeringCruiseSet: isSteeringCruiseSet,
//       isSteeringCruiseResume: isSteeringCruiseResume,
//       isSteeringCruiseCancel: isSteeringCruiseCancel,
//       isSteeringInfo: isSteeringInfo,
//       isSteeringLaneWarning: isSteeringLaneWarning,
//       vehicleDistanceUnit: vehicleDistanceUnit,
//       //
//       currLat: currLat,
//       currLng: currLng,
//       desLat: desLat,
//       desLng: desLng,
//     );
//   }
// }


// SPDX-License-Identifier: Apache-2.0

import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cluster_dashboard/vehicle_signal/vehicle_signal_model.dart';

final vehicleSignalProvider =
StateNotifierProvider<VehicleSignalNotifier, VehicleSignal>(
      (ref) => VehicleSignalNotifier()..startRandomizer(), // auto start
);

class VehicleSignalNotifier extends StateNotifier<VehicleSignal> {
  VehicleSignalNotifier() : super(_initialValue);

  static final VehicleSignal _initialValue = VehicleSignal(
    speed: 0,
    rpm: 0,
    fuelLevel: 50,
    coolantTemp: 20,
    isLeftIndicator: false,
    isRightIndicator: false,
    selectedGear: "P",
    performanceMode: "normal",
    isHazardLightOn: false,
    isHighBeam: false,
    isLowBeam: false,
    isParkingOn: true,
    travelledDistance: 0,
    ambientAirTemp: '25',
    cruiseControlSpeed: 0,
    isCruiseControlActive: false,
    isCruiseControlError: false,
    isMILon: false,
    isTrunkLocked: true,
    isTrunkOpen: false,
    isBatteryCharging: true,
    isSteeringCruiseEnable: false,
    isSteeringCruiseSet: false,
    isSteeringCruiseResume: false,
    isSteeringCruiseCancel: false,
    isSteeringInfo: false,
    isSteeringLaneWarning: false,
    vehicleDistanceUnit: 'km',
    currLat: 31.71,
    currLng: 76.95,
    desLat: 31.71,
    desLng: 76.95,
  );

  Timer? _timer;
  final _random = Random();

  /// Starts random updates to simulate real-time signals
  void startRandomizer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      update(
        speed: _random.nextInt(180).toDouble(), // 0–180 km/h
        rpm: _random.nextInt(8000).toDouble(), // 0–8000 rpm
        fuelLevel: state.fuelLevel > 0
            ? state.fuelLevel - _random.nextDouble() * 0.1
            : 0, // gradually decreases
        coolantTemp: 60 + _random.nextInt(40).toDouble(), // 60–100 °C
        isLeftIndicator: _random.nextBool(),
        isRightIndicator: _random.nextBool(),
        selectedGear: ["P", "R", "N", "D"].elementAt(_random.nextInt(4)),
        performanceMode: ["eco", "normal", "sport"]
            .elementAt(_random.nextInt(3)),
        isHighBeam: _random.nextBool(),
        isLowBeam: _random.nextBool(),
        isHazardLightOn: _random.nextBool(),
        travelledDistance: state.travelledDistance + _random.nextDouble(),
        cruiseControlSpeed:
        _random.nextBool() ? _random.nextInt(120).toDouble() : 0,
        isCruiseControlActive: _random.nextBool(),
        isCruiseControlError: _random.nextBool(),
        isBatteryCharging: _random.nextBool(),
      );
    });
  }

  /// Stop simulation
  void stopRandomizer() {
    _timer?.cancel();
  }

  void update({
    double? speed,
    double? rpm,
    double? fuelLevel,
    double? coolantTemp,
    bool? isLeftIndicator,
    bool? isRightIndicator,
    String? selectedGear,
    String? performanceMode,
    String? ambientAirTemp,
    bool? isLowBeam,
    bool? isHighBeam,
    bool? isHazardLightOn,
    bool? isMILon,
    bool? isParkingOn,
    bool? isTrunkOpen,
    bool? isTrunkLocked,
    bool? isCruiseControlActive,
    bool? isCruiseControlError,
    bool? isBatteryCharging,
    double? travelledDistance,
    double? cruiseControlSpeed,
    //
    String? vehicleDistanceUnit,
    bool? isSteeringCruiseEnable,
    bool? isSteeringCruiseSet,
    bool? isSteeringCruiseResume,
    bool? isSteeringCruiseCancel,
    bool? isSteeringLaneWarning,
    bool? isSteeringInfo,
    //
    double? currLat,
    double? currLng,
    double? desLat,
    double? desLng,
  }) {
    state = state.copyWith(
      speed: speed,
      rpm: rpm,
      fuelLevel: fuelLevel,
      coolantTemp: coolantTemp,
      isLeftIndicator: isLeftIndicator,
      isRightIndicator: isRightIndicator,
      selectedGear: selectedGear,
      isLowBeam: isLowBeam,
      isHighBeam: isHighBeam,
      isHazardLightOn: isHazardLightOn,
      travelledDistance: travelledDistance,
      performanceMode: performanceMode,
      isParkingOn: isParkingOn,
      isTrunkOpen: isTrunkOpen,
      isTrunkLocked: isTrunkLocked,
      isMILon: isMILon,
      ambientAirTemp: ambientAirTemp,
      isCruiseControlActive: isCruiseControlActive,
      isCruiseControlError: isCruiseControlError,
      cruiseControlSpeed: cruiseControlSpeed,
      isBatteryCharging: isBatteryCharging,
      //
      isSteeringCruiseEnable: isSteeringCruiseEnable,
      isSteeringCruiseSet: isSteeringCruiseSet,
      isSteeringCruiseResume: isSteeringCruiseResume,
      isSteeringCruiseCancel: isSteeringCruiseCancel,
      isSteeringInfo: isSteeringInfo,
      isSteeringLaneWarning: isSteeringLaneWarning,
      vehicleDistanceUnit: vehicleDistanceUnit,
      //
      currLat: currLat,
      currLng: currLng,
      desLat: desLat,
      desLng: desLng,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
