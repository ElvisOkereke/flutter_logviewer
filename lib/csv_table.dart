import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'csv_cubit.dart';

class CsvTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CsvCubit, List<List<dynamic>>>(
      builder: (context, data) {
        if (data.isEmpty) {
          return const Center(
              child: Text('No data loaded',
                  style: TextStyle(color: Colors.white)));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dataTextStyle: const TextStyle(color: Colors.white),
              headingTextStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              columns: data.first
                  .map((col) => DataColumn(label: Text(col.toString())))
                  .toList(),
              rows: data
                  .skip(1)
                  .map(
                    (row) => DataRow(
                      cells: row
                          .map((cell) => DataCell(Text(cell.toString())))
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
