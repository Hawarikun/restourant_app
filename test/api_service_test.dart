import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restourant_app/data/api/api_service.dart';
import 'package:restourant_app/data/model/restaurant.dart';

import 'api_service_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  late http.Client client;

  setUp(() {
    client = MockClient();
  });

  /// test get list restaurant
  group('fetchListRestaurant', () {
    test('returns an List Restaurant if the http call completes successfully',
        () async {
      var url = 'https://restaurant-api.dicoding.dev/list';

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

      when(client.get(Uri.parse(url)))
          .thenAnswer((_) async => http.Response(json.encode(listBody), 200));

      final result = await ApiService(client).getAllRestaurant();

      expect(result, isInstanceOf<List<Restaurant>>());
      expect(result, hasLength(2));
      verify(client.get(Uri.parse(url))).called(1);
    });

    test('throws an exception if the http call completes with an error', () {
      var url = 'https://restaurant-api.dicoding.dev/list';

      when(client.get(Uri.parse(url)))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => ApiService(client).getAllRestaurant(), throwsException);
      verify(client.get(Uri.parse(url))).called(1);
    });
  });

  /// test get detail restaurant
  group('fetchDetailRestaurant', () {
    test('returns an Restaurant if the http call completes successfully',
        () async {
      var url =
          'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867';
      var detailBody =
          '{"error":false,"message":"success","restaurant":{"id":"rqdv5juczeskfw1e867","name":"Melting Pot","description":"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.","city":"Medan","address":"Jln. Pandeglang no 19","pictureId":"14","categories":[{"name":"Italia"},{"name":"Modern"}],"menus":{"foods":[{"name":"Paket rosemary"},{"name":"Toastie salmon"},{"name":"Bebek crepes"},{"name":"Salad lengkeng"}],"drinks":[{"name":"Es krim"},{"name":"Sirup"},{"name":"Jus apel"},{"name":"Jus jeruk"},{"name":"Coklat panas"},{"name":"Air"},{"name":"Es kopi"},{"name":"Jus alpukat"},{"name":"Jus mangga"},{"name":"Teh manis"},{"name":"Kopi espresso"},{"name":"Minuman soda"},{"name":"Jus tomat"}]},"rating":4.2,"customerReviews":[{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"13 November 2019"},{"name":"Hayato","review":"Submission 3","date":"22 Desember 2023"},{"name":"HetaTest","review":"Meomng Mayt","date":"22 Desember 2023"},{"name":"Test and I will be there at the same time I dont have to go to the store and","review":"Test and I will be there at the same time I dont have to go","date":"22 Desember 2023"},{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"22 Desember 2023"},{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"22 Desember 2023"},{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"22 Desember 2023"},{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"22 Desember 2023"},{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"22 Desember 2023"},{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"22 Desember 2023"},{"name":"ugun","review":"Tidak rekomendasi untuk pelajar!","date":"22 Desember 2023"},{"name":"Ugun","review":"Penjualnya sangat asik","date":"22 Desember 2023"},{"name":"Ugun","review":"Penjualnya sangat asik","date":"22 Desember 2023"},{"name":"Anonim","review":"enak","date":"22 Desember 2023"},{"name":"Anonim","review":"enak","date":"22 Desember 2023"},{"name":"Anonim","review":"enak","date":"22 Desember 2023"},{"name":"Anonim","review":"enak","date":"22 Desember 2023"},{"name":"Anonim","review":"enak","date":"22 Desember 2023"},{"name":"Anonim","review":"enak","date":"22 Desember 2023"},{"name":"Anonim","review":"enak","date":"22 Desember 2023"},{"name":"Anonim","review":"enak","date":"22 Desember 2023"},{"name":"Anonim","review":"enak","date":"22 Desember 2023"},{"name":"test","review":"test","date":"22 Desember 2023"},{"name":"Anonim","review":"harga murah rasa mantap","date":"22 Desember 2023"},{"name":"andika","review":"makanannya sehat","date":"22 Desember 2023"},{"name":"andika","review":"makanannya sehat","date":"22 Desember 2023"},{"name":"anonim","review":"makanannya enak","date":"22 Desember 2023"}]}}';

      when(client.get(Uri.parse(url)))
          .thenAnswer((_) async => http.Response(detailBody, 200));

      expect(
          await ApiService(client).getDetailRestaurant('rqdv5juczeskfw1e867'),
          isA<DetailRestaurant>());
      verify(client.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .called(1);
    });

    test('throws an exception if the http call completes with an error', () {
      var url =
          'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867';

      when(client.get(Uri.parse(url)))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
          () => ApiService(client).getDetailRestaurant('rqdv5juczeskfw1e867'),
          throwsException);
    });
  });
}
