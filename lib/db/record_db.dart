import 'package:sqflite/sqflite.dart';

class RecordedAudio {
  int? id;
  String? _text;
  String? _sentiment;
  String? _date;

  RecordedAudio({id_, required text, required sentiment, required date}) {
    id = id_;
    _text = text;
    _sentiment = sentiment;
    _date = date;
  }
  int? get id_ => id;
  String? get text => _text;
  String? get sentiment => _sentiment;
  String? get date => _date;
  Map<String, dynamic> toMap() {
    return {'id': id, 'text': _text, 'sentiment': _sentiment, 'date': _date};
  }

  RecordedAudio.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    _text = map['text'];
    _sentiment = map['sentiment'];
    _date = map['date'];
  }
}
