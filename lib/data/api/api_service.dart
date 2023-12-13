import 'dart:convert';
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:provider/provider.dart";
import "package:restourant_app/data/model/restaurant.dart";
import "package:restourant_app/package/provider/globalProvider.dart";

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

  Future<DetailRestaurant> getDetailRestaurant(BuildContext context) async {
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);

    final response = await http.get(
        Uri.parse("$_baseUrl/detail/${globalProvider.detailRestaurantId}"));

    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      dynamic detailRestaurantData = data['restaurant'];

      DetailRestaurant detailRestaurant =
          DetailRestaurant.fromJson(detailRestaurantData);

      print(detailRestaurant);

      return detailRestaurant;
    } else {
      throw Exception(
          'Failed to load restaurants, status code: ${response.statusCode}');
    }
  }
}
