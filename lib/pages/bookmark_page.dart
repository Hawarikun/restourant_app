import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restourant_app/data/model/restaurant.dart';
import 'package:restourant_app/package/provider/database_provider.dart';
import 'package:restourant_app/package/provider/global_provider.dart';
import 'package:restourant_app/package/utils/result_state.dart';
import 'package:restourant_app/pages/detail_restaurant.dart';
import 'package:restourant_app/common/style.dart';

class BookmarkPage extends StatelessWidget {
  static const titlePage = 'Your Favorites';
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          titlePage,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Consumer<DatabaseProvider>(
          builder: (context, provider, child) {
            if (provider.state == ResultState.hasData) {
              return ListView.builder(
                itemCount: provider.bookmarks.length,
                itemBuilder: (context, index) {
                  return _buildRestaurantItem(provider.bookmarks[index]);
                },
              );
            } else {
              return Center(
                child: Material(
                  child: Text(provider.message),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

///  Build Restauran Content
Widget _buildRestaurantItem(Restaurant restaurant) {
  return Consumer<GlobalProvider>(
    builder: (context, provider, child) => Card(
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
          provider.setDetailRestaurantID(restaurant.id);
          Navigator.pushNamed(
            context,
            RestaurantDetail.routeName,
            arguments: restaurant,
          );
        },
      ),
    ),
  );
}
