import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

import 'package:voice_record/api_client.dart';
import 'package:voice_record/app_constants.dart';
import 'package:voice_record/audio_player.dart';
import 'package:voice_record/audio_recorder.dart';

import 'package:voice_record/db/db_connect.dart';
import 'package:voice_record/db/record_db.dart';
import 'package:voice_record/server.dart';
import 'package:get/get_connect/http/src/response/response.dart' as resp;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showPlayer = false;
  String? audioPath;
  String? newpath;
  RecordedAudio? recordedAudio;
  String text = 'this is happiness';
  late String file;
  late bool _isUploading;
  List<Reference> references = [];
  ApiClient apiClient = ApiClient();
  Server server = Server();
  // late String file;
  String? url;
  String? sentiment;
  RecordProvider recordProvider = RecordProvider();
  resp.Response? response;
  resp.Response? response_json;
  resp.Response? getResponse;

  @override
  void initState() {
    showPlayer = false;

    super.initState();
    getfiles();
    _onUploadComplete();
  }

  /// This has to happen only once per app

  void getfiles() async {
    final dir = Directory('/data/user/0/com.example.voice_record/app_flutter');
    //dir.deleteSync(recursive: true);
    final List<FileSystemEntity> entities = await dir.list().toList();
    //print(entities);
    entities.forEach((element) {
      if (element.toString().contains('.wav')) {
        print(_getDateFromFilePatah(filePath: element.toString(), i: 0));
      }
    });
  }

  Future<String> _onUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult = await firebaseStorage.ref().child('uploads').list();
    setState(() {
      references = listResult.items;
    });
    return listResult.items.last.getDownloadURL();
  }

  String _getDateFromFilePatah({required String filePath, required int i}) {
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch), isUtc: false);
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;
    int hours = recordedDate.hour;
    int minutes = recordedDate.minute + i;
    int seconds = recordedDate.second;
    return ('$year-$month-$day:$hours:$minutes:$seconds');
  }

  String getfile(String filePath) {
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));
    return '$fromEpoch.wav';
  }

  Map<String, dynamic> getJson(String path, String audio_url) {
    return {
      'audio_url': audio_url,
      'sentiment_analysis': true,
    };
  }

  Future<void> _onFileUploadButtonPressed(String path) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    setState(() {
      _isUploading = true;
    });
    try {
      await firebaseStorage
          .ref('uploads')
          .child(path.substring(path.lastIndexOf('/'), path.length))
          .putFile(File(path));
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occured while uplaoding'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void insertForGraph(List<dynamic> response, String path) {
    int count = 1;

    response.forEach((element) {
      recordProvider.insert(RecordedAudio(
          text: text,
          sentiment: element["sentiment"],
          date: _getDateFromFilePatah(filePath: path, i: count)));
    });
    print(recordProvider.getAllRecords());
  }

  void insertToDB(List<dynamic> response, String path) {
    int count_pos = 0;
    int count_neg = 0;
    int count_neut = 0;

    response.forEach((element) {
      if (element["sentiment"] == "NEUTRAL") {
        count_neut += 1;
      } else if (element["sentiment"] == "POSITIVE") {
        count_pos += 1;
      } else {
        count_neg += 1;
      }
    });
    if (count_pos > count_neg && count_pos > count_neut) {
      sentiment = "POSITIVE";
    } else if (count_neg > count_pos && count_neg > count_neut) {
      sentiment = "NEGATIVE";
    } else {
      sentiment = "NEUTRAL";
    }

    recordProvider.insert(RecordedAudio(
        text: text,
        sentiment: sentiment,
        date: _getDateFromFilePatah(filePath: path, i: 0)));
    print(recordProvider.getAllRecords());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: showPlayer
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: AudioPlayerr(
                  source: audioPath!,
                  onDelete: () async {
                    setState(() => showPlayer = false);
                    Future.delayed(Duration(minutes: 5), () async {
                      getResponse = await apiClient.getData(
                          AppConstants.ENDPOINT +
                              '/' +
                              response_json!.body['id']);
                      print(getResponse!.body["sentiment_analysis_results"]);
                      insertForGraph(
                          getResponse!.body["sentiment_analysis_results"],
                          audioPath!);
                    });
                  },
                ),
              )
            : AudioRecorder(
                onStop: (path) async {
                  if (kDebugMode) print('Recorded file path: $path');
                  _onFileUploadButtonPressed(path);
                  url = await _onUploadComplete();

                  response = await apiClient.postData(
                      AppConstants.ENDPOINT, getJson(path, url!));
                  print(response!.body["status"]);
                  setState(() {
                    response_json = response;
                  });

                  setState(() {
                    audioPath = path;
                    showPlayer = true;
                  });
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    recordProvider.close();
    print(text);
    super.dispose();
  }
}
