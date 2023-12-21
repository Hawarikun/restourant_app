import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:restourant_app/data/api/api_service.dart';
import 'package:restourant_app/data/model/restaurant.dart';
import 'package:restourant_app/package/utils/result_state.dart';



class GlobalProvider extends ChangeNotifier {
  final ApiService apiService;

  GlobalProvider({required this.apiService, required BuildContext context}) {
    fecthAllRestaurant();
    initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  /// current index for bottom navbar
  int _currentIndex = 0;

  /// name reviewer
  final TextEditingController _nameController = TextEditingController();

  /// review
  final TextEditingController _reviewController = TextEditingController();

  /// ResultState
  late ResultState _state;

  /// detail restaurant
  DetailRestaurant? _detailRestaurant;

  /// list hasil search
  List<Restaurant> _searchRestaurant = [];

  /// restaurant List
  List<Restaurant> _restaurantList = [];

  /// Restaurant by rating
  List<Restaurant> byRating = [];

  /// id for add reviews
  String _detailRestaurantId = "";

  /// search value
  String _searchValue = "";

  /// get
  ResultState get state => _state;

  TextEditingController get nameController => _nameController;
  TextEditingController get reviewController => _reviewController;

  // Future<DetailRestaurant> get detailRestaurantData => _detailRestaurantData;

  DetailRestaurant? get detailrestaurant => _detailRestaurant;

  List<Restaurant> get restaurantList => _restaurantList;
  List<Restaurant> get searchRestaurant => _searchRestaurant;

  int get currentIndex => _currentIndex;
  String get detailRestaurantId => _detailRestaurantId;
  String get searchValue => _searchValue;

  /// set index
  void setCurrentIndex(int index) {
    _currentIndex = index;

    notifyListeners();
  }

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

  void refresh() {
    notifyListeners();
  }

  /// get list data restourant from api
  Future fecthAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurant = await ApiService().getAllRestaurant();

      if (restaurant.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
      } else {
        _state = ResultState.hasData;
        _restaurantList = restaurant;

        List<Restaurant> sortByRating = List.from(_restaurantList);
        sortByRating.sort((a, b) => b.rating.compareTo(a.rating));

        List<Restaurant> top5Restaurants = sortByRating.take(5).toList();

        _restaurantList;
        byRating = top5Restaurants;

        notifyListeners();
      }
    } catch (error) {
      _state = ResultState.error;
      notifyListeners();
    }
  }

  /// get detail data restaurant from api
  Future getData() async {
    try {
      _state = ResultState.loading;

      final detailRestaurantData =
          await ApiService().getDetailRestaurant(detailRestaurantId);

      _state = ResultState.hasData;
      _detailRestaurant = detailRestaurantData;
      // print('done');
      notifyListeners();
    } catch (error) {
      _state = ResultState.error;
      notifyListeners();
    }
  }

  /// get data restourant by search from api
  Future getSearchData() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final searchRestaurantData = await ApiService().searchRestaurant(searchValue);

      if (searchRestaurantData.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
      } else {
        _state = ResultState.hasData;
        _searchRestaurant = searchRestaurantData;
        notifyListeners();
      }
    } catch (error) {
      _state = ResultState.error;
      notifyListeners();
    }
  }

  /// send data review to api
  Future sendReview() async {
    await ApiService().addReview(detailRestaurantId, nameController.text, reviewController.text);

    notifyListeners();
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
