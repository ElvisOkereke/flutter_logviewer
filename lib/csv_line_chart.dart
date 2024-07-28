import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_color/random_color.dart';
import 'csv_cubit.dart';

class CsvLineChart extends StatefulWidget {
  @override
  _CsvLineChartState createState() => _CsvLineChartState();
}

class _CsvLineChartState extends State<CsvLineChart> {
  List<int> selectedVariables = List.filled(5, 1); // Default selected variables
  List<Color> _lineColors = [];
  double _sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CsvCubit, List<List<dynamic>>>(
      builder: (context, data) {
        if (data.isEmpty) {
          return Center(child: Text('No data loaded'));
        }

        // Initialize the colors
        if (_lineColors.isEmpty) {
          for (int i = 1; i < data.first.length; i++) {
            _lineColors.add(RandomColor().randomColor());
          }
        }

        int maxVisiblePoints = 100; // Number of points visible at a time
        int maxPoints = data.length - 1;

        return Column(
          children: [
            Row(
              children: [
                Column(
                  children: List.generate(5, (index) {
                    return DropdownButton<int>(
                      value: selectedVariables[index],
                      items: List.generate(
                        data.first.length - 1,
                        (i) => DropdownMenuItem<int>(
                          value: i + 1,
                          child: Text(data[0][i + 1].toString()),
                        ),
                      ),
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedVariables[index] = newValue!;
                        });
                      },
                    );
                  }),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: (maxPoints + 1) *
                          20.0, // Adjust the width based on the data length
                      height: 400, // Set a fixed height for the chart
                      color: Colors.black, // Set background color to black
                      child: LineChart(
                        LineChartData(
                          backgroundColor: Colors
                              .black, // Set the background color of the chart
                          titlesData: FlTitlesData(
                            leftTitles: SideTitles(
                              showTitles: false,
                            ),
                            bottomTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (value) =>
                                  const TextStyle(color: Colors.white),
                            ),
                          ),
                          lineBarsData: _getLineChartBarData(
                              data, _sliderValue, maxVisiblePoints),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          minX: _sliderValue,
                          maxX: _sliderValue + maxVisiblePoints,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _sliderValue,
              min: 0,
              max: (maxPoints - maxVisiblePoints).toDouble(),
              divisions: (maxPoints - maxVisiblePoints),
              label: _sliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
          ],
        );
      },
    );
  }

  List<LineChartBarData> _getLineChartBarData(
      List<List<dynamic>> data, double start, int maxVisiblePoints) {
    List<LineChartBarData> lineBars = [];

    for (int i = 0; i < selectedVariables.length; i++) {
      int variableIndex = selectedVariables[i];
      List<FlSpot> spots = [];
      for (int j = start.toInt();
          j < start.toInt() + maxVisiblePoints && j < data.length;
          j++) {
        spots.add(FlSpot(
          j.toDouble(),
          double.tryParse(data[j][variableIndex].toString()) ?? 0,
        ));
      }

      lineBars.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          barWidth: 2,
          dotData: FlDotData(show: false),
          colors: [_lineColors[variableIndex - 1]],
          belowBarData: BarAreaData(show: false),
        ),
      );
    }

    return lineBars;
  }
}
