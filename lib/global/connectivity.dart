import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  static StreamSubscription<ConnectivityResult>? connectivity;

  static bool checked = false;
  static ConnectivityResult? currentStatus;

  static bool isConnected() {
    return currentStatus != null && currentStatus != ConnectivityResult.none;
  }

  static Future startListener() async {
    if (connectivity != null) return;

    currentStatus = await Connectivity().checkConnectivity();

    return connectivity = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      checked = false;
      currentStatus = result;
    });
  }

  static Future<void> stopListener() async {
    if (connectivity != null) {
      await connectivity?.cancel();
      currentStatus = null;
    }
  }
}
