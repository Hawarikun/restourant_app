import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import 'package:restourant_app/data/model/restaurant.dart';
import 'package:restourant_app/package/provider/database_provider.dart';
import 'package:restourant_app/package/provider/global_provider.dart';
import 'package:restourant_app/package/utils/result_state.dart';
import 'package:restourant_app/package/widget/costum_scaffold.dart';
import 'package:restourant_app/common/style.dart';

/// use statefulwidget for refresh page with setState
class RestaurantDetail extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final Restaurant restaurant;

  const RestaurantDetail({super.key, required this.restaurant});

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  @override
  void initState() {
    context.read<GlobalProvider>().getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
      builder: (context, globalProvider, _) => CustomScaffold(
        restaurant: widget.restaurant,
        body: _buildList(),
      ),
    );
  }

   Widget _buildList() {
    return Consumer<GlobalProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return Center(
            child: LoadingAnimationWidget.horizontalRotatingDots(
              color: primaryColor,
              size: 50,
            ),
          );
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
                        .getData();
                  },
                  child: const Text(
                    "refresh",
                    style: TextStyle(color: primaryColor),
                  ),
                )
              ],
            ),
          );
        } else if (state.state == ResultState.noData ||
            state.detailrestaurant == null) {
          return const Center(
            child: Text('No data available'),
          );
        } else {
          return

              /// check conection
              state.connectionStatus == ConnectivityResult.none
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
                                Provider.of<GlobalProvider>(context,
                                        listen: false)
                                    .getData();
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
                  : NestedScrollView(
                      headerSliverBuilder: (context, isScrolled) {
                        return [
                          SliverAppBar(
                            expandedHeight: 200,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Hero(
                                transitionOnUserGestures: false,
                                tag: widget.restaurant.pictureId,
                                child: Image.network(
                                  "https://restaurant-api.dicoding.dev/images/large/${widget.restaurant.pictureId}",
                                  fit: BoxFit.fitWidth,
                                  errorBuilder: (ctx, error, _) =>
                                      const Center(child: Icon(Icons.error)),
                                ),
                              ),
                            ),
                          ),
                        ];
                      },

                      // body: const SizedBox(),

                      /// pull to refresh
                      body: RefreshIndicator(
                        onRefresh: () async {
                          Provider.of<GlobalProvider>(context, listen: false)
                              .getData();
                        },
                        // child: const SizedBox(),
                        child: Consumer<DatabaseProvider>(
                          builder: (context, provider, child) => FutureBuilder(
                            future: provider.isBookmarked(widget.restaurant.id),
                            builder: (context, snapshot) {
                              var isBookmarked = snapshot.data ?? false;
                              return _bodyDetailRestourant(
                                  context, isBookmarked);
                            },
                          ),
                        ),
                      ),
                    );
        }
      },
    );
  }

  SingleChildScrollView _bodyDetailRestourant(
      BuildContext context, bool isBookmarked) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Consumer2<GlobalProvider, DatabaseProvider>(
        builder: (context, provider, databaseProvider, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// restaurant name & bookmark
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.restaurant.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                /// bookmark
                Card(
                  surfaceTintColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  // decoration: BoxDecoration(
                  //   border: Border.all(width: 1, color: Colors.grey.shade400),
                  // ),
                  child: isBookmarked
                      ? IconButton(
                          icon: const Icon(Icons.favorite),
                          color: Theme.of(context).primaryColor,
                          onPressed: () => databaseProvider
                              .removeBookmark(widget.restaurant.id),
                        )
                      : IconButton(
                          icon: const Icon(Icons.favorite_border),
                          color: Theme.of(context).primaryColor,
                          onPressed: () =>
                              databaseProvider.addBookmark(widget.restaurant),
                        ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            /// rating

            Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < widget.restaurant.rating.round()
                          ? Icons.star
                          : Icons.star_border,
                      size: 16,
                      color: starColor,
                    );
                  }),
                ),
                const SizedBox(width: 5),
                Text(
                  widget.restaurant.rating.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  "${provider.detailrestaurant!.address}, ${widget.restaurant.city}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),

            /// category
            Row(
              children: [
                const Text("category : "),
                SizedBox(
                  height: 35,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.detailrestaurant!.categories.length,
                    itemBuilder: (context, index) {
                      final data = provider.detailrestaurant!.categories[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(data.name),
                        ),
                      );
                    },
                  ),
                )
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
            ReadMoreText(
              widget.restaurant.description,
              textAlign: TextAlign.justify,
              trimLines: 6,
              trimMode: TrimMode.Line,
              colorClickableText: Colors.green,
              trimCollapsedText: "Show More",
              trimExpandedText: '\nShow less',
              moreStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
              lessStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
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
                itemCount: provider.detailrestaurant!.menus.foods.length,
                itemBuilder: (context, index) {
                  final data = provider.detailrestaurant!.menus.foods[index];

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
                itemCount: provider.detailrestaurant!.menus.drinks.length,
                itemBuilder: (context, index) {
                  final data = provider.detailrestaurant!.menus.drinks[index];

                  /// card food menus content
                  return _contentMenus(
                      data.name, 'assets/images/orange_jus.jpeg');
                },
              ),
            ),
            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 18),

            /// Costumer Review
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Costumer Reviews",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showAddReview(context);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: size.height * 0.4,
              child: ListView.builder(
                reverse: true,
                itemCount: provider.detailrestaurant!.customerReviews.length,
                itemBuilder: (contex, index) {
                  final data =
                      provider.detailrestaurant!.customerReviews[index];
                  return _reviewCard(data);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showAddReview(BuildContext context) {
    return showModalBottomSheet<void>(
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 300,
            child: Consumer<GlobalProvider>(
              builder: (context, globalProvider, _) => SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Add Your Review'),

                        /// close
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            globalProvider.clear();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    /// Name
                    const Text("Name"),
                    const SizedBox(height: 5),
                    TextField(
                      autofocus: true,
                      style: const TextStyle(fontSize: 10),
                      controller: globalProvider.nameController,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (value) {
                        globalProvider.onChangeName(value);
                      },
                      decoration: const InputDecoration(
                        hintText: "Your Name",
                        hintStyle: TextStyle(fontSize: 10),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                    ),

                    /// Review
                    const SizedBox(height: 5),
                    const Text("Review"),
                    const SizedBox(height: 5),
                    TextField(
                      style: const TextStyle(fontSize: 10),
                      controller: globalProvider.reviewController,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        globalProvider.onChangeReview(value);
                      },
                      decoration: const InputDecoration(
                        hintText: "Your Review",
                        hintStyle: TextStyle(fontSize: 10),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Add
                    ElevatedButton(
                      onPressed: (globalProvider.nameController.text.isEmpty ||
                              globalProvider.reviewController.text.isEmpty)
                          ? null
                          : () async {
                              globalProvider.sendReview();
                              Navigator.pop(context);
                              globalProvider.clear();
                              Provider.of<GlobalProvider>(context,
                                      listen: false)
                                  .getData();
                            },
                      child: const Text("Add"),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Card _reviewCard(CustomerReview data) {
    return Card(
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),

                /// name and date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Text(
                        data.date,
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// review
            Text(
              data.review,
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
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
