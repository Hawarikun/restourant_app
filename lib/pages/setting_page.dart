import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restourant_app/package/provider/scheduling_provider.dart';
import 'package:restourant_app/package/utils/background_service.dart';
import 'package:restourant_app/package/utils/date_time_helper.dart';
import 'package:restourant_app/package/widget/custom_dialog.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ListTile(
            title: const Text('Scheduling News'),
            trailing: Consumer<SchedulingProvider>(
              builder: (context, scheduled, _) {
                print(scheduled.isScheduled);
                return Switch(
                  value: scheduled.isScheduled,
                  onChanged: (value) async {
                    if (Platform.isIOS) {
                      customDialog(context);
                    } else {
                      scheduled.scheduledNews(value);
                    }
                  },
                );
              },
            ),
          ),

          ElevatedButton(onPressed: () {
            AndroidAlarmManager.oneShot(
                  const Duration(seconds: 5),
                  1,
                  BackgroundService.callback,
                  // startAt: DateTimeHelper.format(),
                  exact: true,
                  wakeup: true,
                );
          }, child: Text("Call"))
        ],
      ),
    );
  }
}
