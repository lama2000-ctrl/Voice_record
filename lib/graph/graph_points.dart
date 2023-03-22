import 'package:voice_record/db/db_connect.dart';
import 'package:voice_record/db/record_db.dart';
import 'package:collection/collection.dart' as col;

class GraphPoint {
  final double x;
  final double y;

  GraphPoint({required this.x, required this.y});
}

Future<List<GraphPoint>> graphPoints() async {
  final RecordProvider recordProvider = RecordProvider();
  var data = await recordProvider.getRec();
  List<GraphPoint> data_ = [];
  int count = 0;
  print("This is ${data.runtimeType}");
  print("this is ${data}");
  //data = data as List<double>;

  data.forEach((element) {
    data_.add(GraphPoint(x: count.toDouble(), y: element.toDouble()));
    count += 1;
  });

  print("yessssssss${data_}");
  return data_;
}
