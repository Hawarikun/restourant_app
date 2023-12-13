import 'package:flutter/material.dart';

import 'package:restourant_app/data/model/restaurant.dart';

class CustomScaffold extends StatelessWidget {
  final DetailRestaurant restaurant;
  final Widget body;

  const CustomScaffold({Key? key, required this.body, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            body,
            Card(
              surfaceTintColor: Colors.white,
              margin: const EdgeInsets.all(0),
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
