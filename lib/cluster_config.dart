// SPDX-License-Identifier: Apache-2.0

import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cluster_dashboard/vehicle_signal/initial_socket_connection.dart';
import 'package:yaml/yaml.dart';

class GetConfig extends ConsumerStatefulWidget {
  const GetConfig({Key? key, required this.client}) : super(key: key);
  final HttpClient client;

  @override
  ConsumerState<GetConfig> createState() => _GetConfigState();
}

class _GetConfigState extends ConsumerState<GetConfig> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final configStateProvider = ref.read(clusterConfigStateprovider.notifier);

      const configFilePath = '/etc/xdg/AGL/flutter-cluster-dashboard.yaml';
      const orsKeyFilePath = '/etc/default/openroutekey';

      final configFile = File(configFilePath);
      final orsKeyFile = File(orsKeyFilePath);

      configFile.readAsString().then((content) {
        final yamlMap = loadYaml(content);
        configStateProvider.update(
          hostname: yamlMap['hostname'],
          port: yamlMap['port'],
          homeLat: yamlMap['homeLat'],
          homeLng: yamlMap['homeLng'],
          orsPathParam: yamlMap['orsPathParam'],
          kuksaAuthToken: yamlMap['kuskaAuthToken'],
        );
      });

      orsKeyFile.readAsString().then((content) {
        String keyContent = content.split(':')[1].trim();
        if (keyContent.isNotEmpty &&
            keyContent != 'YOU_NEED_TO_SET_IT_IN_LOCAL_CONF') {
          configStateProvider.update(orsApiKey: keyContent);
        } else {
          print("WARNING: openrouteservice API Key not found!");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(clusterConfigStateprovider);

    if (config.hostname.isEmpty ||
        config.port == 0 ||
        config.kuksaAuthToken.isEmpty ||
        config.homeLat == 0 ||
        config.homeLng == 0 ||
        config.orsPathParam.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "ERROR",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Something Wrong with config file! Check config.yaml file and restart",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return InitialScreen(client: widget.client);
  }
}

// ----------------------------
// Cluster Config State
// ----------------------------

class ClusterConfig {
  ClusterConfig({
    required this.hostname,
    required this.port,
    required this.kuksaAuthToken,
    required this.orsApiKey,
    required this.orsPathParam,
    required this.homeLat,
    required this.homeLng,
  });

  final String hostname;
  final int port;
  final String kuksaAuthToken;
  final double homeLat;
  final double homeLng;
  final String orsApiKey;
  final String orsPathParam;

  ClusterConfig copywith({
    String? hostname,
    int? port,
    String? kuksaAuthToken,
    double? homeLat,
    double? homeLng,
    String? orsApiKey,
    String? orsPathParam,
  }) =>
      ClusterConfig(
        hostname: hostname ?? this.hostname,
        port: port ?? this.port,
        kuksaAuthToken: kuksaAuthToken ?? this.kuksaAuthToken,
        homeLat: homeLat ?? this.homeLat,
        homeLng: homeLng ?? this.homeLng,
        orsApiKey: orsApiKey ?? this.orsApiKey,
        orsPathParam: orsPathParam ?? this.orsPathParam,
      );
}

class ClusterConfigStateNotifier extends StateNotifier<ClusterConfig> {
  ClusterConfigStateNotifier() : super(_initialValue);

  static final _initialValue = ClusterConfig(
    hostname: "",
    port: 0,
    kuksaAuthToken: "",
    orsApiKey: "",
    orsPathParam: "",
    homeLat: 0,
    homeLng: 0,
  );

  void update({
    String? hostname,
    int? port,
    String? kuksaAuthToken,
    double? homeLat,
    double? homeLng,
    String? orsApiKey,
    String? orsPathParam,
  }) {
    state = state.copywith(
      hostname: hostname,
      port: port,
      kuksaAuthToken: kuksaAuthToken,
      homeLat: homeLat,
      homeLng: homeLng,
      orsApiKey: orsApiKey,
      orsPathParam: orsPathParam,
    );
  }
}

final clusterConfigStateprovider =
StateNotifierProvider<ClusterConfigStateNotifier, ClusterConfig>(
        (ref) => ClusterConfigStateNotifier());
