import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:restourant_app/package/provider/scheduling_provider.dart';
import 'package:restourant_app/package/widget/custom_dialog.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SchedulingProvider>(
      builder: (context, scheduled, _) => Scaffold(
        body: SafeArea(
          child: ListTile(
            key: const Key("switch"),
            title: const Text('Scheduling News'),
            trailing: Switch.adaptive(
              value: scheduled.isScheduled,
              onChanged: (value) async {
                if (Platform.isIOS) {
                  customDialog(context);
                } else {
                  scheduled.scheduledNews(value);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
