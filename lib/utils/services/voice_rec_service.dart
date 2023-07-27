/*
import 'dart:developer';
import 'dart:io';

import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecordingService {
  final recorder = FlutterSoundRecorder();

  Future<void> record() async {
    await recorder.startRecorder(toFile: '');
  }

  Future<void> stop() async {
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);

    log('Recorded Audio: $audioFile');
  }

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
  }

  Future<void> close() async {
    recorder.closeRecorder();
  }

  Future<void> onAudioRecord() async {
    if (recorder.isRecording) {
      await stop();
    } else {
      await record();
    }
  }
}

 */
