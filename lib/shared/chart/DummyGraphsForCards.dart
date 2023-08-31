import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DummyGraphsForCards extends StatefulWidget {
  TypeOfGraph typeOfGraph;

  DummyGraphsForCards(this.typeOfGraph);

  @override
  State<DummyGraphsForCards> createState() => _DummyGraphsForCardsState();
}

class _DummyGraphsForCardsState extends State<DummyGraphsForCards> {
  @override
  Widget build(BuildContext context) {
    switch (widget.typeOfGraph) {
      case TypeOfGraph.PROGRESSIVE:
        return getProgressiveGraph();
      case TypeOfGraph.REGRESSIVE:
        return getRegressiveGraph();
      default:
        return getProgressiveGraph();
    }
  }
}

Widget getProgressiveGraph() {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Colors.black, Colors.transparent, Colors.black, Colors.black],
        stops: [0.0, 0.2, 0.95, 1.0],
      ).createShader(bounds);
    },
    blendMode: BlendMode.dstOut,
    child: LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 0,
        maxX: 7,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 1),
              FlSpot(1, 3),
              FlSpot(2, 4),
              FlSpot(3, 1),
              FlSpot(4, 2),
              FlSpot(5, 1.8),
              FlSpot(6, 3),
            ],
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.transparent,
          ),
          touchCallback: (p0, p1) {},
          handleBuiltInTouches: false,
        ),
      ),
    ),
  );
}

Widget getRegressiveGraph() {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Colors.black, Colors.transparent, Colors.black, Colors.black],
        stops: [0.0, 0.2, 0.95, 1.0],
      ).createShader(bounds);
    },
    blendMode: BlendMode.dstOut,
    child: LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 0,
        maxX: 7,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 3), // High value at the start
              FlSpot(1, 4),
              FlSpot(2, 2),
              FlSpot(3, 1),
              FlSpot(4, 0), // Low value at the end
            ],
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.transparent,
          ),
          touchCallback: (p0, p1) {},
          handleBuiltInTouches: false,
        ),
      ),
    ),
  );
}

enum TypeOfGraph { PROGRESSIVE, REGRESSIVE }
