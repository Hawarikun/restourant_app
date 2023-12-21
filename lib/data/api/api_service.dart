import 'dart:convert';
import "package:http/http.dart" as http;

import "package:restourant_app/data/model/restaurant.dart";

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _type = 'Content-Type';
  static const String _header = 'application/json';

  Future<List<Restaurant>> getAllRestaurant() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<dynamic> restaurantDataList = data['restaurants'];

      List<Restaurant> restaurants =
          restaurantDataList.map((json) => Restaurant.fromJson(json)).toList();

      return restaurants;
    } else {
      /// Jika request tidak berhasil, lempar exception dengan pesan status code
      throw Exception(
          'Failed to load restaurants, status code: ${response.statusCode}');
    }
  }

  Future<DetailRestaurant> getDetailRestaurant(String id) async {
    // final globalProvider = Provider.of<GlobalProvider>(context, listen: false);

    final response = await http.get(
        Uri.parse("$_baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      dynamic detailRestaurantData = data['restaurant'];

      DetailRestaurant detailRestaurant =
          DetailRestaurant.fromJson(detailRestaurantData);

      return detailRestaurant;
    } else {
      throw Exception(
          'Failed to load restaurants, status code: ${response.statusCode}');
    }
  }

  Future<List<Restaurant>> searchRestaurant(String searchValue) async {

    final response = await http
        .get(Uri.parse("$_baseUrl/search?q=$searchValue"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<dynamic> restaurantDataList = data['restaurants'];

      List<Restaurant> restaurants =
          restaurantDataList.map((json) => Restaurant.fromJson(json)).toList();

      return restaurants;
    } else {
      throw Exception(
          'Failed to load restaurants, status code: ${response.statusCode}');
    }
  }

  Future<void> addReview(String id, String name,String review) async {

    var body = {
      'id': id,
      'name': name,
      'review': review
    };

    final response = await http.post(
      Uri.parse(
        "$_baseUrl/review",
      ),
      headers: <String, String>{
        _type: _header,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200) {
      /// Berhasil, respon dari server
      print('Response: ${response.body}');
    } else {
      /// Gagal, respon error dari server
      throw Exception(
          'Failed to load restaurants, status code: ${response.statusCode}');
    }
  }
}
