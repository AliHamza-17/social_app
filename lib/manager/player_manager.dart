import 'package:get/get.dart';
import 'dart:io';
import 'package:foap/manager/progress_notifier.dart';

enum PlayStateState { paused, playing, loading, idle }

class Audio {
  String id;
  String url;

  Audio({
    required this.id,
    required this.url,
  });
}

class PlayerManager extends GetxController {
  // final player = AudioPlayer();

  Duration totalDuration = const Duration(seconds: 0);
  Duration currentPosition = const Duration(seconds: 0);

  Rx<Audio?> currentlyPlayingAudio = Rx<Audio?>(null);
  Rx<ProgressBarState?> progress = Rx<ProgressBarState?>(null);

  playAudio(Audio audio) async {
    currentlyPlayingAudio.value = audio;
    // await player.setUrl(audio.url);

    // player.play();
    // listenToStates();
  }

  // listenToStates() {
  //   player.positionStream.listen((event) {
  //     currentPosition = event;
  //     progress.value =
  //         ProgressBarState(current: currentPosition, total: totalDuration);
  //   });
  //
  //   player.durationStream.listen((event) {
  //     totalDuration = event ?? const Duration(seconds: 0);
  //   });
  //
  //   // player.playerStateStream.listen((state) {
  //   //   if (state.playing) {
  //   //   } else {}
  //   //   switch (state.processingState) {
  //   //     // // case ProcessingState.idle:
  //   //     //   {
  //   //     //     return;
  //   //     //   }
  //   //     case ProcessingState.loading:
  //   //       return;
  //   //     case ProcessingState.buffering:
  //   //       return;
  //   //     case ProcessingState.ready:
  //   //       return;
  //   //     case ProcessingState.completed:
  //   //       currentlyPlayingAudio.value = null;
  //   //       return;
  //   //   }
  //   // });
  // }

  stopAudio() {
    // player.stop();
    currentlyPlayingAudio.value = null;
  }

  // playAudioFile(File file) async {
  //   await player.setFilePath(file.path);
  //
  //   player.play();
  //   listenToStates();
  // }
}
