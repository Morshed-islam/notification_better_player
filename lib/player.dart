
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player>  with WidgetsBindingObserver{


  int playingTme = 0;
  int notificationTime = 0;

  late BetterPlayerController _betterPlayerController;
  // bool showNotification = false;
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initPlayer();
    // showNotification();
    // initializeNotifications();


  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _betterPlayerController.dispose();
    super.dispose();
  }



  ///local notification
  // Future<void> initializeNotifications() async {
  //   // Initialize the notification plugin
  //   const InitializationSettings initializationSettings =
  //   InitializationSettings(
  //       android: AndroidInitializationSettings('ic_launcher')
  //   );
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  //
  //   // Fetch or create the notification channel for Better Player
  //   const channelId = 'Better Player';
  //   const channelName = 'Better Player';
  //   const channelDescription = 'Notification Channel for Better Player';
  //   const Importance importance = Importance.high;
  //   final AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     channelId,
  //     channelName,
  //     importance: importance,
  //   );
  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //       AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(channel);
  // }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('App state $state');

    if (state == AppLifecycleState.paused) {
      // Handle pause event when app goes to background or is minimized.
      log('App is paused');
      log('notification duration ${_betterPlayerController.videoPlayerController!.value.position.inMilliseconds}');
      // _initPlayer(true);

    } else if (state == AppLifecycleState.resumed) {

      log('player duration ${_betterPlayerController.videoPlayerController!.value.position.inMilliseconds}');
      log('player duration 1');
      playingTme = _betterPlayerController.videoPlayerController!.value.position.inMilliseconds;
      log('player duration 2');


      Future.delayed(const Duration(seconds: 2),(){
        setState(() {
          log('after 2 sec later player duration 1');

          log('player duration 3');

          if(_betterPlayerController.videoPlayerController!.value.position.inMilliseconds == playingTme){
            notificationTime = 0;
            playingTme = 0;
            log(" app paused done");
            log(" app paused time ${_betterPlayerController.videoPlayerController!.value.position.inMilliseconds}");
            _betterPlayerController.pause();
          }else{
            // notificationTime = 0;
            log(" app resumed done");
            log(" app resumed time ${_betterPlayerController.videoPlayerController!.value.position.inMilliseconds}");
            playingTme = 0;

            _betterPlayerController.play();

          }

        });
      });

      log('App is resumed');
    }
  }

  ///awesome notification
  NotificationContent createNotificationContent() {
    return NotificationContent(
      id: -1, // Unique ID
      channelKey: 'Better Player', // Define a channel with desired settings
      title: _betterPlayerController.betterPlayerSubtitlesSource?.name,
      body: 'This is a customizable notification.',
      payload: {'key': 'value'}, // Optional data
      bigPicture: 'assets/icon.png', // Optional large image
      largeIcon: 'ic_notification', // Optional large icon
      progress: 50,
      playbackSpeed: 2,
      playState: NotificationPlayState.playing,

      // Customize other properties as needed
    );
  }

  void showNotification() async {
    await AwesomeNotifications().createNotification(content: createNotificationContent()); // Immediate notification
  }


  _initPlayer(){

    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "https://bycwknztmq.gpcdn.net/90d58486-801b-4334-93ca-cb4e54e980c8/playlist.m3u8",

      notificationConfiguration:  const BetterPlayerNotificationConfiguration(
         showNotification: true,
        title: "Mahfil",
        author: "Some author",
        activityName: "MainActivity",
        notificationChannelName: "Better Player",
        imageUrl:"https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/African_Bush_Elephant.jpg/1200px-African_Bush_Elephant.jpg",
      ),
    );


    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(

            eventListener: _checkIfCanProcessPlayerEvent
        ),
        betterPlayerDataSource: betterPlayerDataSource);


    // _betterPlayerController.addEventsListener((event){
    //   if (event.betterPlayerEventType == BetterPlayerEventType.play) {
    //     showCustomNotification(context, 'Now Playing:', 'title check');
    //     log("play check");
    //
    //   } else if (event.betterPlayerEventType == BetterPlayerEventType.pause) {
    //     showCustomNotification(context, 'Pause', 'off');
    //     log("pause check");
    //     // Remove notification or update with pause info
    //   }
    // });
    // _betterPlayerController.playNextVideo();

  }



  // Future<void> showCustomNotification(BuildContext context, String title, String text) async {
  //   const AndroidNotificationDetails androidPlatformDetails = AndroidNotificationDetails(
  //     'Better Player',
  //     'Better Player',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //   );
  //   // const IOSNotificationDetails iosPlatformDetails = IOSNotificationDetails();
  //   const NotificationDetails platformDetails = NotificationDetails(
  //     android: androidPlatformDetails,
  //   );
  //   await flutterLocalNotificationsPlugin.show(0, title, text, platformDetails);
  // }



  String _checkIfCanProcessPlayerEvent(BetterPlayerEvent event) {
    log('default event ${event.betterPlayerEventType}');
    if(event.betterPlayerEventType == BetterPlayerEventType.pause){
      log('pause');
      return 'pause';
    }else if(event.betterPlayerEventType == BetterPlayerEventType.play){
      log('play');

      return 'play';
    }else if(event.betterPlayerEventType == BetterPlayerEventType.finished){
      log('Play finished');

    }else if(event.betterPlayerEventType == BetterPlayerEventType.pipStop){
      log('Pip  Stop');

    }else if(event.betterPlayerEventType == BetterPlayerEventType.progress){
      // //42545
      // log("Notification time: ${_betterPlayerController.videoPlayerController!.value.position.inMilliseconds}");
      //
      // setState(() {
      //   notificationTime = _betterPlayerController.videoPlayerController!.value.position.inMilliseconds;
      // });


    }

    //log('default event ${event.betterPlayerEventType}');

    return 'false';
      // event.betterPlayerEventType == BetterPlayerEventType.pause &&
      //     event.parameters != null &&
      //     event.parameters!['progress'] != null &&
      //     event.parameters!['duration'] != null;
  }



  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

          AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(
            controller: _betterPlayerController,
          ),),

        ElevatedButton(onPressed: (){
          showNotification();
        }, child: Text('Open'))
      ],
    );
    //   AspectRatio(
    //   aspectRatio: 16 / 9,
    //   child: BetterPlayer(
    //     controller: _betterPlayerController,
    //   ),
    // );
  }
}



