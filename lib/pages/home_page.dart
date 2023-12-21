import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:restourant_app/data/model/restaurant.dart';
import 'package:restourant_app/package/provider/global_provider.dart';
import 'package:restourant_app/package/utils/result_state.dart';
import 'package:restourant_app/pages/detail_restaurant.dart';
import 'package:restourant_app/common/style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
      builder: (context, globalProvider, _) => Scaffold(
        appBar: EasySearchBar(
          key: const Key("searchBar"),
          title: const Text(
            "Restaurant",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          searchHintText: "search restourant",
          onSearch: (value) {
            globalProvider.setSearchValue(value);
            globalProvider.getSearchData();
          },
        ),
        body: globalProvider.connectionStatus == ConnectivityResult.none
            ? Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off_rounded),
                      const SizedBox(height: 5),
                      const Text('No connection'),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          surfaceTintColor: Colors.green,
                        ),
                        onPressed: () {
                          Provider.of<GlobalProvider>(context, listen: false)
                              .fecthAllRestaurant();
                        },
                        child: const Text(
                          "refresh",
                          style: TextStyle(color: primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
              )
            :

            /// pull to refresh
            RefreshIndicator(
                onRefresh: () async {
                  Provider.of<GlobalProvider>(context, listen: false)
                      .fecthAllRestaurant();
                },

                /// Call Data Futere
                child: _buildList(),
              ),
      ),
    );
  }

  Widget _buildList() {
    return Consumer<GlobalProvider>(
      builder: (context, state, _) {
        /// check data loading
        if (state.state == ResultState.loading) {
          return Center(
            child: LoadingAnimationWidget.horizontalRotatingDots(
              color: primaryColor,
              size: 50,
            ),
          );

          /// check data error
        } else if (state.state == ResultState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded),
                const SizedBox(height: 5),
                const Text('No connection'),
                const SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: Colors.green,
                  ),
                  onPressed: () {
                    Provider.of<GlobalProvider>(context, listen: false)
                        .fecthAllRestaurant();
                  },
                  child: const Text(
                    "refresh",
                    style: TextStyle(color: primaryColor),
                  ),
                )
              ],
            ),
          );

          /// check data empty
        } else if (state.state == ResultState.noData) {
          return const Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_outlined,
                    size: 54,
                  ),
                  SizedBox(height: 15),
                  Text("data not found"),
                ],
              ),
            ),
          );

          /// has data
        } else {
          /// check data search restourant is empty
          if (state.searchRestaurant.isEmpty || state.searchValue == '') {
            return _restaurantListWidget(context, state);

            /// check data search restourant is has data
          } else if (state.searchRestaurant.isNotEmpty) {
            /// check data search restourant is loading
            if (state.state == ResultState.loading) {
              return Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  color: primaryColor,
                  size: 50,
                ),
              );

              /// check data search restourant is error
            } else if (state.state == ResultState.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded),
                    const SizedBox(height: 5),
                    const Text('No connection'),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Colors.green,
                      ),
                      onPressed: () {
                        Provider.of<GlobalProvider>(context, listen: false)
                            .fecthAllRestaurant();
                      },
                      child: const Text(
                        "refresh",
                        style: TextStyle(color: primaryColor),
                      ),
                    )
                  ],
                ),
              );

              /// check data search restourant is no data
            } else if (state.state == ResultState.noData) {
              return const Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_outlined,
                        size: 54,
                      ),
                      SizedBox(height: 15),
                      Text("data not found"),
                    ],
                  ),
                ),
              );
            } else {
              /// check data search restourant is has data
              return _searchListWidget(state);
            }

            /// check data search restourant is empty
          } else {
            /// ketika tidak ada data saat search restaurant
            return const Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_outlined,
                      size: 54,
                    ),
                    SizedBox(height: 15),
                    Text("data not found"),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  /// untuk menampilkan list hasil search
  AnimationLimiter _searchListWidget(GlobalProvider state) {
    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.searchRestaurant.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 800),
            child: SlideAnimation(
              verticalOffset: 100.0,
              child: FadeInAnimation(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: _buildRestaurantItem(
                    context,
                    state.searchRestaurant[index],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// untuk menampilkan list restaurant
  SingleChildScrollView _restaurantListWidget(
      BuildContext context, GlobalProvider state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "Recommendation for you",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          _corouselSliderCostum(context, state.byRating),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Explore Restaurant",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          AnimationLimiter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.restaurantList.length,
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
                          state.restaurantList[index],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// corousel widget
Widget _corouselSliderCostum(BuildContext context, List data) {
  final globalProvider = Provider.of<GlobalProvider>(context, listen: false);

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
              globalProvider.setDetailRestaurantID(restaurant.id.toString());
              Navigator.pushNamed(
                context,
                RestaurantDetail.routeName,
                arguments: restaurant,
              );
            },
            child: Stack(
              children: [
                /// image
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}'),
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
                      /// restauran name
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

                      /// Star review
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

///  Build Restauran Content
Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
  final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
  return Card(
    surfaceTintColor: Colors.white,
    elevation: 2,
    child: ListTile(
      /// hero
      leading: Hero(
        tag: restaurant.pictureId,

        /// image
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
            width: 75,
            fit: BoxFit.fill,
            errorBuilder: (ctx, error, _) => const SizedBox(
              width: 75,
              child: Icon(Icons.error),
            ),
          ),
        ),
      ),

      /// restaurant Name
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
          /// restaurant Location
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

          /// Restaurant Rating
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
        globalProvider.setDetailRestaurantID(restaurant.id);
        Navigator.pushNamed(
          context,
          RestaurantDetail.routeName,
          arguments: restaurant,
        );
      },
    ),
  );
}
