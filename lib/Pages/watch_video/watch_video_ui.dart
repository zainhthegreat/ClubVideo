import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_aws/Pages/watch_video/watch_video_bloc.dart';
import 'package:video_aws/Pages/watch_video/watch_video_event.dart';
import 'package:video_aws/Pages/watch_video/watch_video_state.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchVideo extends StatefulWidget {
  const WatchVideo({Key? key}) : super(key: key);

  @override
  _WatchVideoState createState() => _WatchVideoState();
}

class _WatchVideoState extends State<WatchVideo> {
  @override
  void initState() {
    super.initState();

    context.read<WatchVideosBloc>().add(GetVideoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.read<WatchVideosBloc>().state.UIName),
      ),
      body: BlocBuilder<WatchVideosBloc, WatchVideosState>(
        builder: (BuildContext context, state) {
          return Center(
            child: state.url != ''
                ? const RunPlayer()
                : const CircularProgressIndicator(
                    color: Colors.black,
                  ),
          );
        },
      ),
    );
  }
}

class RunPlayer extends StatefulWidget {
  const RunPlayer({
    Key? key,
  }) : super(key: key);

  @override
  _RunPlayerState createState() => _RunPlayerState();
}

class _RunPlayerState extends State<RunPlayer> {
  final videoPlayerController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');

  late var chewieController;

  late var playerWidget;

  @override
  void initState() {
    initController();
    super.initState();
  }

  void initController() async {
    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: chewieController,
    );
  }
  // return _controller.value.isInitialized
  //     ? Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Container(
  //         height: 200,
  //         child: AspectRatio(
  //           aspectRatio: _controller.value.aspectRatio,
  //           child: VideoPlayer(_controller),
  //         ),
  //       ),
  //         const SizedBox(height: 50),
  //         ElevatedButton(
  //           onPressed: () {
  //             setState(() {
  //               _controller.value.isPlaying
  //                   ? _controller.pause()
  //                   : _controller.play()
  //               ;
  //
  //             });
  //             },
  //
  //
  //         child: Icon(
  //           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
  //         ),
  //       ),
  //
  //       ElevatedButton(onPressed: (){
  //       _controller.seekTo(Duration(seconds: 10));
  //
  //       },
  //         child: Icon(Icons.ac_unit_rounded))
  //     ])
  //         : const CircularProgressIndicator(
  //       color: Colors.deepPurple,
  //     );
  //   }
}
