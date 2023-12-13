import 'dart:convert';
import "package:http/http.dart" as http;
import "package:restourant_app/data/model/restaurant.dart";

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<List<Restaurant>> getAllRestaurant() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<dynamic> restaurantDataList = data['restaurants'];

      List<Restaurant> restaurants =
          restaurantDataList.map((json) => Restaurant.fromJson(json)).toList();

      return restaurants;
    } else {
      // Jika request tidak berhasil, lempar exception dengan pesan status code
      throw Exception(
          'Failed to load restaurants, status code: ${response.statusCode}');
    }
  }

  Future<DetailRestaurant> getDetailRestaurant() async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/:id"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      dynamic detailRestaurantData = data['restaurants'];

      DetailRestaurant detailRestaurant = detailRestaurantData;

      return detailRestaurant;
    } else {
      throw Exception(
          'Failed to load restaurants, status code: ${response.statusCode}');
    }
  }
}
