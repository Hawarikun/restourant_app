import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:restourant_app/pages/detail_restaurant.dart';
import 'package:restourant_app/models/restaurant.dart';
import 'package:restourant_app/style/style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchValue = "";

  // restaurant list after search
  List<Restaurant> searchRestaurant = [];

  // restaurant list
  List<Restaurant> restaurantList = [];

  // Restaurant by rating
  List<Restaurant> byRating = [];

  @override
  void initState() {
    super.initState();
    fetchAndParseRestaurantList();
  }

  List<Restaurant> parseRestaurant(String? json) {
    if (json == null) {
      return [];
    }

    final Map<String, dynamic> parsed = jsonDecode(json);
    final List<dynamic> restaurants = parsed['restaurants'];

    return restaurants.map((json) => Restaurant.fromJson(json)).toList();
  }

  // filter restaurant by search
  List<Restaurant> filterRestaurants(
      List<Restaurant> restaurants, String searchValue) {
    return restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(searchValue.toLowerCase());
    }).toList();
  }

  // call data restaurant
  Future<void> fetchAndParseRestaurantList() async {
    try {
      String jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/data/local_restaurant.json');
      List<Restaurant> restaurants = parseRestaurant(jsonString);

      List<Restaurant> sortByRating = List.from(restaurants);
      sortByRating.sort((a, b) => b.rating.compareTo(a.rating));

      List<Restaurant> top5Restaurants = sortByRating.take(5).toList();

      setState(() {
        restaurantList = restaurants;
        searchRestaurant = filterRestaurants(restaurantList, searchValue);
        byRating = top5Restaurants;
      });
    } catch (error) {
      print("e : $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        title: const Text(
          "Restaurant",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        searchHintText: "search restourant",
        onSearch: (value) => setState(
          () {
            searchValue = value;
            searchRestaurant = filterRestaurants(restaurantList, searchValue);
          },
        ),
      ),

      // Call Data Futere
      body: FutureBuilder<String>(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/data/local_restaurant.json'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Text('No data available');
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  ketika searchValue kosong tampilkan
                if (searchValue.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "Recommendation for you",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),

                //  ketika searchValue kosong tampilkan
                if (searchValue.isEmpty) _corouselSliderCostum(byRating),

                //  ketika searchValue kosong tampilkan
                if (searchValue.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Explore Restaurant",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),

                //  ketika searchValue kosong ataupun tidak kosong tampilkan
                if (searchValue.isEmpty || searchValue.isNotEmpty)
                  Expanded(
                    child: AnimationLimiter(
                      child: ListView.builder(
                        itemCount: searchRestaurant.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 800),
                            child: SlideAnimation(
                              verticalOffset: 100.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  child: _buildRestaurantItem(
                                    context,
                                    searchRestaurant[index],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}

Widget _corouselSliderCostum(List data) {
  return CarouselSlider(
    options: CarouselOptions(
      aspectRatio: 2.3,
      enlargeCenterPage: true,
      initialPage: 2,
      autoPlay: true,
    ),
    items: data.map((restaurant) {
      return Builder(
        builder: (BuildContext context) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                RestaurantDetail.routeName,
                arguments: restaurant,
              );
            },
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(restaurant.url),
                      fit: BoxFit.fill,
                      onError: (ctx, error) =>
                          const Center(child: Icon(Icons.error)),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            restaurant.name,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Star review
                      Container(
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(211, 224, 224, 224),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: starColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                restaurant.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }).toList(),
  );
}

//  Build Restauran Content
Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
  return Card(
    surfaceTintColor: Colors.white,
    elevation: 2,
    child: ListTile(
      leading: Hero(
        tag: restaurant.url,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            restaurant.url,
            width: 75,
            height: 75,
            fit: BoxFit.fill,
            errorBuilder: (ctx, error, _) =>
                const Center(child: Icon(Icons.error)),
          ),
        ),
      ),

      // restaurant Name
      title: Text(
        restaurant.name,
        maxLines: 1,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // restaurant Location
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 12,
              ),
              const SizedBox(width: 5),
              Text(
                restaurant.city,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),

          // Restaurant Rating
          Row(
            children: [
              const Icon(
                Icons.star,
                size: 12,
                color: starColor,
              ),
              const SizedBox(width: 5),
              Text(
                restaurant.rating.toString(),
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          RestaurantDetail.routeName,
          arguments: restaurant,
        );
      },
    ),
  );
}
