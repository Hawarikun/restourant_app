import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:restourant_app/data/model/restaurant.dart';
import 'package:restourant_app/package/provider/globalProvider.dart';
import 'package:restourant_app/package/widget/costum_scaffold.dart';
import 'package:restourant_app/style/style.dart';

class RestaurantDetail extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final Restaurant restaurant;

  const RestaurantDetail({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    Provider.of<GlobalProvider>(context, listen: false).getData(context);

    return CustomScaffold(
      restaurant: restaurant,
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2),
            () => globalProvider.detailRestaurantData),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Text('No data available');
          } else {
            return NestedScrollView(
              headerSliverBuilder: (context, isScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        transitionOnUserGestures: false,
                        tag: restaurant.pictureId,
                        child: Image.network(
                          "https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}",
                          fit: BoxFit.fitWidth,
                          errorBuilder: (ctx, error, _) =>
                              const Center(child: Icon(Icons.error)),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: _bodyDetailRestourant(globalProvider),
            );
          }
        },
      ),
    );
  }

  SingleChildScrollView _bodyDetailRestourant(GlobalProvider globalProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// restaurant name
          Text(
            restaurant.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// restaurant location
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    restaurant.city,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),

              /// rating
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: starColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    restaurant.rating.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          /// description
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
            "Description",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            restaurant.description,
            textAlign: TextAlign.justify,
            maxLines: 12,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),
          const Divider(),

          /// Food menus
          const SizedBox(height: 18),
          const Text(
            "Foods Menu",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,

            /// call Foods menu
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: globalProvider.detailrestaurant!.menus.foods.length,
              itemBuilder: (context, index) {
                final data =
                    globalProvider.detailrestaurant!.menus.foods[index];

                /// card food menus content
                return _contentMenus(data.name, 'assets/images/food.jpeg');
              },
            ),
          ),

          /// Drink menus
          const SizedBox(height: 18),
          const Text(
            "Drinks Menu",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,

            /// call Foods menu
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: globalProvider.detailrestaurant!.menus.drinks.length,
              itemBuilder: (context, index) {
                final data =
                    globalProvider.detailrestaurant!.menus.drinks[index];

                /// card food menus content
                return _contentMenus(
                    data.name, 'assets/images/orange_jus.jpeg');
              },
            ),
          ),
        ],
      ),
    );
  }

  /// card menus content
  SizedBox _contentMenus(String name, String image) {
    return SizedBox(
      width: 150,
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.asset(
                  image,
                  width: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, _) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Text("IDR 60.000")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
