import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:voice_record/db/db_connect.dart';
import 'package:voice_record/graph/graph_points.dart';
import 'package:voice_record/graph/line_chart.dart';

class GraphView extends StatefulWidget {
  const GraphView({super.key});

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  RecordProvider recordProvider = RecordProvider();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GraphPoint>>(
        future: graphPoints(),
        builder: (context, AsyncSnapshot<List<GraphPoint>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Container(
                  child:
                      Center(child: LineChartWidget(points: snapshot.data!))),
            );
          } else {
            // print(snapshot.data);
            return Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
