import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeTrailerScreen extends StatefulWidget {
  final String youtubeUrl;

  const YouTubeTrailerScreen({super.key, required this.youtubeUrl});

  @override
  State<YouTubeTrailerScreen> createState() => _YouTubeTrailerScreenState();
}

class _YouTubeTrailerScreenState extends State<YouTubeTrailerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    if (videoId == null) {
      debugPrint('❌ URL inválida: ${widget.youtubeUrl}');
      _controller = YoutubePlayerController(
        initialVideoId: 'dQw4w9WgXcQ',
        flags: const YoutubePlayerFlags(autoPlay: true),
      );
    } else {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          forceHD: true,
          useHybridComposition: true,
          enableCaption: true,
        ),
      );
    }

    _controller.addListener(_orientationListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.toggleFullScreenMode();
    });
  }

  void _orientationListener() {
    if (_controller.value.isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_orientationListener);
    _controller.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
          backgroundColor: Colors.black26,
          bufferedColor: Colors.grey,
        ),
        bottomActions: [
          const SizedBox(width: 8),
          CurrentPosition(),
          const SizedBox(width: 8),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          const SizedBox(width: 8),
          FullScreenButton(),
        ],
        onReady: () {
          debugPrint('🎬 Reproductor listo');
        },
        onEnded: (data) {
          debugPrint('🎞️ Video finalizado');
        },
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: _controller.value.isFullScreen
              ? null
              : AppBar(
                  backgroundColor: Colors.black87,
                  title: const Text("Tráiler", style: TextStyle(color: Colors.white)),
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
          body: Center(child: player),
        );
      },
    );
  }
}
