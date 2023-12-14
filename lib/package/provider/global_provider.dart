import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:restourant_app/data/api/api_service.dart';
import 'package:restourant_app/data/model/restaurant.dart';

class GlobalProvider extends ChangeNotifier {
  /// name reviewer
  final TextEditingController _nameController = TextEditingController();

  /// review
  final TextEditingController _reviewController = TextEditingController();

  /// detail restaurant data from api
  late Future<DetailRestaurant> _detailRestaurantData;

  /// search restaurant data from api
  late Future<List<Restaurant>> searchRestaurantData;

  /// all restaurant data from api
  late Future<List<Restaurant>> restaurant;

  DetailRestaurant? _detailRestaurant;

  List<Restaurant> _searchRestaurant = [];
  /// restaurant List
  List<Restaurant> restaurantList = [];

  /// Restaurant by rating
  List<Restaurant> byRating = [];

  /// id for add reviews
  String _detailRestaurantId = "";
  
  /// search value
  String _searchValue = "";

  /// get
  TextEditingController get nameController => _nameController;
  TextEditingController get reviewController => _reviewController;

  Future<DetailRestaurant> get detailRestaurantData => _detailRestaurantData;

  DetailRestaurant? get detailrestaurant => _detailRestaurant;

  List<Restaurant> get searchRestaurant => _searchRestaurant;

  String get detailRestaurantId => _detailRestaurantId;
  String get searchValue => _searchValue;

  /// set id
  void setDetailRestaurantID(String id) {
    _detailRestaurantId = id;

    notifyListeners();
  }

  /// set search value
  void setSearchValue(String search) {
    _searchValue = search;

    notifyListeners();
  }

  /// set name
  void onChangeName(String value) {
    _nameController.text = value;

    notifyListeners();
  }

  /// set review
  void onChangeReview(String value) {
    _reviewController.text = value;

    notifyListeners();
  }

  /// get list data restourant from api
  Future fetchAndParseRestaurantList() async {
    try {
      restaurant = ApiService().getAllRestaurant();

      restaurantList = await restaurant;

      List<Restaurant> sortByRating = List.from(restaurantList);
      sortByRating.sort((a, b) => b.rating.compareTo(a.rating));

      List<Restaurant> top5Restaurants = sortByRating.take(5).toList();

      restaurantList;
      byRating = top5Restaurants;

      notifyListeners();
    } catch (error) {
      print("e : $error");
    }
  }

  /// get detail data restaurant from api
  Future<void> getData(BuildContext context) async {
    try {
      _detailRestaurantData = ApiService().getDetailRestaurant(context);

      _detailRestaurant = await _detailRestaurantData;

      notifyListeners();
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  /// get data restourant by search from api 
  Future<void> getSearchData(BuildContext context) async {
    try {
      searchRestaurantData = ApiService().searchRestaurant(context);

      _searchRestaurant = await searchRestaurantData;

      notifyListeners();
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  /// send data review to api
  Future sendReview(BuildContext context) async {
    await ApiService().addReview(context);
  }

  /// clear variable for add review
  void clear() {
    _nameController.clear();
    _reviewController.clear();

    notifyListeners();
  }

  /// Check conection
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
  ///
}
