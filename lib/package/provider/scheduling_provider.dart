import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:restourant_app/package/utils/background_service.dart';
import 'package:restourant_app/package/utils/date_time_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  SchedulingProvider() {
    _loadScheduledStatus();
  }

  Future<void> _loadScheduledStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isScheduled = prefs.getBool('isScheduled') ?? false;
    notifyListeners();
  }

  Future<void> saveScheduledStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isScheduled', value);
    notifyListeners();
  }

  

  Future<bool> scheduledNews(bool value) async {
    _isScheduled = value;
    await saveScheduledStatus(value);
    if (_isScheduled) {
      print('Scheduling News Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling News Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
