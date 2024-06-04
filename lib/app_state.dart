import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

class AppState extends ChangeNotifier {
  final Connectivity _connectivity;

  AppState(this._connectivity);

  /// Initializes the app state.
  /// - Checks if the device has an internet connection.
  Future<void> init() async {
    hasConnection = await _connectivity.checkConnectivity().then((connection) {
      return connection[0] != ConnectivityResult.none;
    });

    await _checkServerConnection();
    subscribeConnection();
  }

  //*---------------------Server Connection-----------------------*//
  bool? _isServerDown;
  bool? get isServerDown => _isServerDown;
  // control overlay when no wifi connection
  // the overlay builder in "scaffold_with_navbar.dart"
  final OverlayPortalController overlayController = OverlayPortalController();
  Future<void> _checkServerConnection() async {
    _isServerDown = null;
    notifyListeners();

    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 2)));
    await dio.getUri(uriBuilder(path: '/')).then(
      (_) {},
      onError: (e) {
        if ((e as DioException).response != null) {
          _isServerDown = false;
        } else {
          _isServerDown = true;
        }
        notifyListeners();
      },
    );
  }

  // retry connection to the server
  Future<void> retryConnection() async {
    await _checkServerConnection();
  }

  //*---------------------Connectivity-----------------------
  bool hasConnection = true;
  Stream<List<ConnectivityResult>> get connectionStream => _connectivity.onConnectivityChanged;

  // subscribe to the connectivity stream
  void subscribeConnection() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> connection) {
      hasConnection = connection[0] != ConnectivityResult.none;

      if (!hasConnection) {
        overlayController.show();
      } else if (hasConnection) {
        overlayController.hide();
      }

      notifyListeners();
    });
  }
}
