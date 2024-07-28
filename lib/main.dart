import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'csv_cubit.dart';
import 'csv_table.dart';
import 'file_picker.dart';
import 'csv_parser.dart';
import 'csv_line_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CsvCubit(),
        child: CsvHomePage(),
      ),
    );
  }
}

class CsvHomePage extends StatefulWidget {
  @override
  _CsvHomePageState createState() => _CsvHomePageState();
}

class _CsvHomePageState extends State<CsvHomePage> {
  int _numberOfCharts = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Data Viewer'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final path = await pickFile();
                    if (path != null) {
                      final data = await parseCsv(path);
                      context.read<CsvCubit>().loadCsvData(data);
                    }
                  },
                  child: Text('Load CSV'),
                ),
                SizedBox(height: 16),
                DropdownButton<int>(
                  value: _numberOfCharts,
                  onChanged: (int? newValue) {
                    setState(() {
                      _numberOfCharts = newValue!;
                    });
                  },
                  items:
                      <int>[1, 2, 3, 4].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value Chart${value > 1 ? 's' : ''}'),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                Expanded(
                  flex: constraints.maxWidth > 600 ? 1 : 0,
                  child: CsvTable(),
                ),
                SizedBox(height: 16),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: _numberOfCharts,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          //height: 200, // Set a fixed height for each chart
                          child: CsvLineChart(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
