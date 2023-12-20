import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restourant_app/data/model/restaurant.dart';

import 'api_service_test.mocks.dart';

/// for test api
Future<Restaurant> fetchDetailRestaurant(http.Client client) async {
  final response = await client.get(
      Uri.parse('https://restaurant-api.dicoding.dev/rqdv5juczeskfw1e867'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Restaurant.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Restaurant');
  }
}

Future<List<Restaurant>> fetchRestaurant(http.Client client) async {
  final response =
      await client.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final Map<String, dynamic> data = json.decode(response.body);

    List<dynamic> restaurantDataList = data['restaurants'];
    return restaurantDataList.map((json) => Restaurant.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Restaurant');
  }
}

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  /// test get detail restaurant
  group('fetchDetailRestaurant', () {
    test('returns an Restaurant if the http call completes successfully',
        () async {
      final client = MockClient();

      var url =
          Uri.parse('https://restaurant-api.dicoding.dev/rqdv5juczeskfw1e867');

      var detailBody =
          '{ "id": "rqdv5juczeskfw1e867", "name": "Melting Pot", "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...", "pictureId": "14", "city": "Medan", "rating": 4.2}';

      when(client.get(url))
          .thenAnswer((_) async => http.Response(detailBody, 200));

      expect(await fetchDetailRestaurant(client), isA<Restaurant>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      var url =
          Uri.parse('https://restaurant-api.dicoding.dev/rqdv5juczeskfw1e867');

      when(client.get(url))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchDetailRestaurant(client), throwsException);
    });
  });

  /// test get list restaurant
  group('fetchListRestaurant', () {
    test('returns an List Restaurant if the http call completes successfully',
        () async {
      final client = MockClient();

      var url = Uri.parse('https://restaurant-api.dicoding.dev/list');

      var listBody = {
        "error": false,
        "message": "success",
        "count": 20,
        "restaurants": [
          {
            "id": "rqdv5juczeskfw1e867",
            "name": "Melting Pot",
            "description":
                "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
            "pictureId": "14",
            "city": "Medan",
            "rating": 4.2
          },
          {
            "id": "s1knt6za9kkfw1e867",
            "name": "Kafe Kita",
            "description":
                "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
            "pictureId": "25",
            "city": "Gorontalo",
            "rating": 4
          }
        ]
      };

      when(client.get(url))
          .thenAnswer((_) async => http.Response(json.encode(listBody), 200));

      final result = await fetchRestaurant(client);

      expect(result, isA<List<Restaurant>>());
      expect(result.length, equals(2));
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      var url = Uri.parse('https://restaurant-api.dicoding.dev/list');

      when(client.get(url))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchRestaurant(client), throwsException);
    });
  });
}
