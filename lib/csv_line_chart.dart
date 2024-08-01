import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'csv_cubit.dart';
import 'normilize.dart';

class CsvLineChart extends StatefulWidget {
  @override
  _CsvLineChartState createState() => _CsvLineChartState();
}
//Features to add:
//1. Calculated Fields
//2. data legend min/max values
//3. color match lines and data legend
//4. add cursor to chart

class _CsvLineChartState extends State<CsvLineChart> {
  List<int?> selectedVariables =
      List.filled(5, null); // Default selected variables to None
  final List<Color> _lineColors = [
    const Color.fromARGB(255, 255, 0, 0), // Bright Red
    const Color.fromARGB(255, 0, 255, 0), // Bright Green
    const Color.fromARGB(255, 0, 255, 255), // Bright Cyan
    const Color.fromARGB(255, 255, 255, 0), // Bright Yellow
    const Color.fromARGB(255, 255, 0, 255), // Bright Magenta
  ];
  double _sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CsvCubit, List<List<dynamic>>>(
      builder: (
        context,
        data,
      ) {
        if (data.isEmpty) {
          return const Center(
              child: Text('No data loaded',
                  style: TextStyle(color: Colors.white)));
        }

        int maxVisiblePoints = 100; // Number of points visible at a time
        int maxPoints = data.length - 1;

        // Calculate minY and maxY based on the selected variables
        double minY = double.infinity;
        double maxY = double.negativeInfinity;
        for (int? variableIndex in selectedVariables) {
          if (variableIndex != null) {
            for (int j = 0; j < data.length; j++) {
              double value =
                  double.tryParse(data[j][variableIndex].toString()) ?? 0;
              if (value < minY) minY = value;
              if (value > maxY) maxY = value;
            }
          }
        }

        if (minY == double.infinity || maxY == double.negativeInfinity) {
          minY = 0;
          maxY = 1;
        }

        return Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: List.generate(5, (index) {
                        return DropdownButton<int?>(
                          dropdownColor: const Color.fromARGB(255, 175, 122, 8),
                          style: const TextStyle(color: Colors.white),
                          value: selectedVariables[index],
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('None'),
                            ),
                            ...List.generate(
                              data.first.length - 1,
                              (i) => DropdownMenuItem<int?>(
                                value: i + 1,
                                child: Text(data[0][i + 1].toString()),
                              ),
                            ),
                          ],
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedVariables[index] = newValue;
                            });
                          },
                        );
                      }),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: GestureDetector(
                          onTapUp: (details) {
                            double halfWidth =
                                MediaQuery.of(context).size.width / 2;
                            if (details.localPosition.dx > halfWidth) {
                              setState(() {
                                _sliderValue = min(
                                    _sliderValue + 10, maxPoints.toDouble());
                              });
                            } else {
                              setState(() {
                                _sliderValue = max(_sliderValue - 10, 0);
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Container(
                              width: (maxPoints + 1) *
                                  20.0, // Adjust the width based on the data length
                              height: 400, // Set a fixed height for the chart
                              color:
                                  Colors.black, // Set background color to black
                              child: LineChart(
                                LineChartData(
                                  backgroundColor: Colors
                                      .black, // Set the background color of the chart
                                  titlesData: FlTitlesData(
                                    leftTitles: SideTitles(
                                      showTitles: true,
                                      //add getTextStyle to see y axis values
                                    ),
                                    bottomTitles: SideTitles(
                                      showTitles: true,
                                      getTextStyles: (value) =>
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: false, // Disable grid lines
                                  ),
                                  lineBarsData: _getLineChartBarData(
                                      data,
                                      _sliderValue,
                                      maxVisiblePoints,
                                      minY,
                                      maxY),
                                  borderData: FlBorderData(
                                    show: false,
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                  ),
                                  minX: _sliderValue,
                                  maxX: _sliderValue + maxVisiblePoints,
                                  //minY: -1,
                                  //maxY: 1,
                                  lineTouchData: LineTouchData(
                                    enabled: false, // Disable touch events
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                color: Colors.white.withOpacity(0.8),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...selectedVariables.map((variableIndex) {
                      if (variableIndex == null) return Container();
                      double value = double.tryParse(data[_sliderValue.toInt()]
                                  [variableIndex]
                              .toString()) ??
                          0;
                      return Text(
                        '${data[0][variableIndex]}: $value',
                        style: const TextStyle(color: Colors.black),
                      );
                    })
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<LineChartBarData> _getLineChartBarData(List<List<dynamic>> data,
      double start, int maxVisiblePoints, double minY, double maxY) {
    List<LineChartBarData> lineBars = [];

    for (int i = 0; i < selectedVariables.length; i++) {
      int? variableIndex = selectedVariables[i];
      if (variableIndex == null) {
        continue; // Skip if 'None' is selected
      }
      List<FlSpot> spots = [];
      for (int j = start.toInt();
          j < start.toInt() + maxVisiblePoints && j < data.length;
          j++) {
        spots.add(FlSpot(
          //key,value
          j.toDouble(),
          normalizeData(
              double.tryParse(data[j][variableIndex].toString()) ?? 0,
              minY,
              maxY), //check if data element is a double, if not (meaning it a label or string) set it to 0, then normilize
        ));
      }

      lineBars.add(
        LineChartBarData(
          spots: spots,
          isCurved: false, // Set to false to make the lines straight
          barWidth: 2,
          dotData: FlDotData(show: true), //ADD SETTINGS TO ENABLE/DISABLE DOTS
          colors: [_lineColors[i]],
          belowBarData: BarAreaData(show: false),
        ),
      );
    }

    return lineBars;
  }
}
