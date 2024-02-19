import 'dart:developer';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestVideoScreen extends StatefulWidget {
  const TestVideoScreen({super.key});

  @override
  State<TestVideoScreen> createState() => _TestVideoScreenState();
}

class _TestVideoScreenState extends State<TestVideoScreen> {
  late BetterPlayerController? _betterPlayerController;
  late bool isHide = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///data source - means which type data with configuration
    BetterPlayerDataSource dataSource = BetterPlayerDataSource.network(
      'https://bycwknztmq.gpcdn.net/90d58486-801b-4334-93ca-cb4e54e980c8/playlist.m3u8',
      videoFormat: BetterPlayerVideoFormat.hls,
      cacheConfiguration: const BetterPlayerCacheConfiguration(
        useCache: true,
        preCacheSize: 10 * 1024 * 1024,
        maxCacheSize: 10 * 1024 * 1024,
        maxCacheFileSize: 10 * 1024 * 1024,

        ///Android only option to use cached video between app sessions
        //key: videoLink ?? '',
        key: "testCacheKey",
      ),

      ///useAsmsSubtitles: true,
      useAsmsTracks: true,
    );

    ///set data source and configuration on controller
    BetterPlayerConfiguration betterPlayerConfiguration =
    const BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      autoPlay: true,
      looping: false,
      handleLifecycle: false,
      allowedScreenSleep: false,
      // Handle full-screen exit event.
      fullScreenByDefault: false,
      // Important setting
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],

      controlsConfiguration: BetterPlayerControlsConfiguration(
        enableSkips: true,
        showControls: true,
        enablePlayPause: true,
        controlsHideTime: Duration(milliseconds: 1),
      ),
    );
    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: dataSource,
    );
  }

  @override
  void dispose() {
    log('log result: on Dispose');
    if (_betterPlayerController != null) {
      log('log result: on Dispose inside');
      _betterPlayerController!.clearCache();
      _betterPlayerController!.pause();
      // _betterPlayerController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Video'),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: _betterPlayerController!.getAspectRatio() ?? 16 / 9,
                  child: BetterPlayer(
                    controller: _betterPlayerController!,
                  ),
                ),
                Opacity(
                  opacity: .3,
                  child: CachedNetworkImage(
                    imageUrl: 'https://mahfilbucket.s3.amazonaws.com/media_test/video_content_thumbnail/mob_thumbnail_y7z9yf8J2h_JPG_1600x900.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5G25YRBXUVQTFY73%2F20240111%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20240111T110011Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=1bc4e6416edcc907d47dd510dffd9033630a2b995926190059ff314b23860fdb',
                    color: Colors.black.withOpacity(.3),
                    colorBlendMode: BlendMode.darken,
                    imageBuilder: (context, imageProvider) => Container(
                      width: ScreenUtil().scaleWidth,
                      height: 215,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      color: Colors.grey[100],
                      width: ScreenUtil().scaleWidth,
                      height: 215,
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      size: 200,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
