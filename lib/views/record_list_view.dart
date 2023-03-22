import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:voice_record/audio_player.dart';

class RecordListView extends StatefulWidget {
  final List<Reference> references;
  final List<String> recordList;
  const RecordListView(
      {Key? key, required this.references, required this.recordList})
      : super(key: key);

  @override
  _RecordListViewState createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView> {
  late int _totalDuration;
  late int _currentDuration;
  double? _completedPercentage;
  bool _isPlaying = false;
  int? _selectedIndex;
  late AudioPlayerr audioPlayerr;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _isPlaying = false;
    _selectedIndex = -1;
    _completedPercentage = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return widget.references.isEmpty
        ? Center(child: Text('No records yet'))
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView.builder(
                  itemCount: widget.references.length,
                  shrinkWrap: true,
                  reverse: true,
                  itemBuilder: (BuildContext context, int i) {
                    return ExpansionTile(
                      title:
                          Text('New recoding ${widget.references.length - i}'),
                      subtitle: Text(_getDateFromFilePatah(
                          filePath: widget.references.elementAt(i).name)),
                      onExpansionChanged: ((newState) {
                        if (newState) {
                          setState(() {
                            _selectedIndex = i;
                          });
                        }
                      }),
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          height: 100,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LinearProgressIndicator(
                                minHeight: 5,
                                backgroundColor: Colors.black,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                                value: _selectedIndex == i
                                    ? _completedPercentage
                                    : 0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: AudioPlayerr(
                                  source: widget.recordList[i],
                                  onDelete: () {
                                    setState(() {});
                                  },
                                ),
                              )
                              // IconButton(
                              //   icon: _selectedIndex == i
                              //       ? _isPlaying
                              //           ? Icon(Icons.pause)
                              //           : Icon(Icons.play_arrow)
                              //       : Icon(Icons.play_arrow),
                              //   onPressed: () => AudioPlayer() _onPlay(
                              //       filePath: widget.records.elementAt(i), index: i),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
  }

  // Future<void> _onPlay({required String filePath, required int index}) async {
  //   AudioPlayer audioPlayer = AudioPlayer();

  //   if (!_isPlaying) {
  //     audioPlayer.play(filePath, isLocal: true);
  //     setState(() {
  //       _selectedIndex = index;
  //       _completedPercentage = 0.0;
  //       _isPlaying = true;
  //     });

  //     audioPlayer.onPlayerCompletion.listen((_) {
  //       setState(() {
  //         _isPlaying = false;
  //         _completedPercentage = 0.0;
  //       });
  //     });
  //     audioPlayer.onDurationChanged.listen((duration) {
  //       setState(() {
  //         _totalDuration = duration.inMicroseconds;
  //       });
  //     });

  //     audioPlayer.onAudioPositionChanged.listen((duration) {
  //       setState(() {
  //         _currentDuration = duration.inMicroseconds;
  //         _completedPercentage =
  //             _currentDuration.toDouble() / _totalDuration.toDouble();
  //       });
  //     });
  //   }
  // }

  String _getDateFromFilePatah({required String filePath}) {
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('%') + 1, filePath.lastIndexOf('.'));
    print("............$fromEpoch");
    DateTime recordedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;
    int hours = recordedDate.hour + 6;
    int minutes = recordedDate.minute;
    int seconds = recordedDate.second;
    return ('$year-$month-$day:$hours:$minutes:$seconds');
  }
}
