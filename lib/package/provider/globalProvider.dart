import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:restourant_app/data/api/api_service.dart';
import 'package:restourant_app/data/model/restaurant.dart';

class GlobalProvider extends ChangeNotifier {
  late Future<DetailRestaurant> _detailRestaurantData;
  DetailRestaurant? _detailRestaurant;

  String _detailRestaurantId = "";

  Future<DetailRestaurant> get detailRestaurantData => _detailRestaurantData;
  DetailRestaurant? get detailrestaurant => _detailRestaurant;

  String get detailRestaurantId => _detailRestaurantId;

  void setDetailRestaurantID(String id) {
    _detailRestaurantId = id;

    print(_detailRestaurantId);

    notifyListeners();
  }

  Future<void> getData(BuildContext context) async {
    try {
      _detailRestaurantData = ApiService().getDetailRestaurant(context);

      _detailRestaurant = await _detailRestaurantData;

      notifyListeners();
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  ConnectivityResult get connectionStatus => _connectionStatus;

  GlobalProvider() {
    initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);

      notifyListeners();
    } catch (e) {
      debugPrint('Couldn\'t check connectivity status: $e');
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (_connectionStatus != result) {
      _connectionStatus = result;
      notifyListeners();
    }
  }
}
