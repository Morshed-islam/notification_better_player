import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_player_latest/player.dart';
import 'package:notification_player_latest/test_player.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  NotificationChannel notificationChannel = NotificationChannel(channelKey: 'notify', channelName: 'notify', channelDescription: 'test');
  await AwesomeNotifications().initialize(
    // Your notification channels (optional)
    null,
    [notificationChannel],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Player(),
    );
  }
}
