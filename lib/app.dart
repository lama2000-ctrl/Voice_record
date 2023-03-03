import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_record/audio_player.dart';
import 'package:voice_record/audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_record/db/db_connect.dart';
import 'package:voice_record/db/record_db.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showPlayer = false;
  String? audioPath;
  String? newpath;
  RecordProvider? recordProvider;
  RecordedAudio? recordedAudio;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = 'this is happiness';
  String text = 'this is happiness';
  late String file;

  @override
  void initState() {
    showPlayer = false;

    super.initState();
    getfiles();
  }

  /// This has to happen only once per app

  void getfiles() async {
    final dir = Directory('/data/user/0/com.example.voice_record/app_flutter');
    //dir.deleteSync(recursive: true);
    final List<FileSystemEntity> entities = await dir.list().toList();
    //print(entities);
    entities.forEach((element) {
      if (element.toString().contains('.wav')) {
        print(_getDateFromFilePatah(filePath: element.toString()));
      }
    });
  }

  String _getDateFromFilePatah({required String filePath}) {
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch), isUtc: false);
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;
    int hours = recordedDate.hour + 6;
    int minutes = recordedDate.minute;
    int seconds = recordedDate.second;
    return ('$year-$month-$day:$hours:$minutes:$seconds');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: showPlayer
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: AudioPlayerr(
                    source: audioPath!,
                    onDelete: () {
                      setState(() => showPlayer = false);
                    },
                  ),
                )
              : AudioRecorder(
                  onStop: (path) {
                    if (kDebugMode) print('Recorded file path: $path');
                    recordProvider = RecordProvider(
                        recordedAudio: RecordedAudio(
                            text: text,
                            sentiment: "positive",
                            date: _getDateFromFilePatah(filePath: path)));

                    recordProvider!.insert(RecordedAudio(
                        text: text,
                        sentiment: "positive",
                        date: _getDateFromFilePatah(filePath: path)));
                    print(recordProvider!.getAllRecords());
                    setState(() {
                      audioPath = path;
                      showPlayer = true;
                    });
                  },
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    recordProvider!.close();
    print(text);
    super.dispose();
  }
}
