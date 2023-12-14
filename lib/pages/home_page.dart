import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:restourant_app/data/model/restaurant.dart';
import 'package:restourant_app/package/provider/global_provider.dart';
import 'package:restourant_app/pages/detail_restaurant.dart';
import 'package:restourant_app/style/style.dart';

/// use statefulwidget for refresh page with setState
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<GlobalProvider>(context, listen: false).getSearchData(context);
    Provider.of<GlobalProvider>(context, listen: false)
        .fetchAndParseRestaurantList();

    return Consumer<GlobalProvider>(
      builder: (context, globalProvider, _) => Scaffold(
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
          onSearch: (value) {
            globalProvider.setSearchValue(value);
            globalProvider.getSearchData(context);
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
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text("refresh"))
                    ],
                  ),
                ),
              )
            :

            /// refresh conection
            RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
        /// Call Data Futere
                child: FutureBuilder(
                  future: globalProvider.searchRestaurantData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.horizontalRotatingDots(
                          color: primaryColor,
                          size: 50,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wifi_off_rounded),
                            const SizedBox(height: 5),
                            const Text('No connection'),
                            const SizedBox(height: 5),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                child: const Text("refresh"))
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No data available'),
                      );
                    } else if (globalProvider.searchRestaurant == [] ||
                        globalProvider.searchRestaurant.isEmpty) {
                      /// ketika tidak ada data saat search restaurant
                      return const Center(
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
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///  ketika searchValue kosong tampilkan
                            if (globalProvider.searchValue.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  "Recommendation for you",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                            ///  ketika searchValue kosong tampilkan
                            if (globalProvider.searchValue.isEmpty)
                              _corouselSliderCostum(
                                  context, globalProvider.byRating),

                            ///  ketika searchValue kosong tampilkan
                            if (globalProvider.searchValue.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  "Explore Restaurant",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                            ///  ketika searchValue kosong ataupun tidak kosong tampilkan
                            if (globalProvider.searchValue.isEmpty ||
                                globalProvider.searchValue.isNotEmpty)
                              AnimationLimiter(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      globalProvider.searchRestaurant.length,
                                  itemBuilder: (context, index) {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 800),
                                      child: SlideAnimation(
                                        verticalOffset: 100.0,
                                        child: FadeInAnimation(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 5),
                                            child: _buildRestaurantItem(
                                              context,
                                              globalProvider
                                                  .searchRestaurant[index],
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
                  },
                ),
              ),
      ),
    );
  }
}

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
