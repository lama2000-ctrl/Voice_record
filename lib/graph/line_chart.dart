import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:voice_record/graph/graph_points.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key, required this.points});

  final List<GraphPoint> points;

  @override
  Widget build(BuildContext context) {
    print("this is ${points[0].x}");
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(LineChartData(lineBarsData: [
        LineChartBarData(
            spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
            isCurved: false,
            dotData: FlDotData(show: true),
            color: Colors.redAccent)
      ])),
    );
  }
}
