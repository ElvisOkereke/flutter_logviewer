import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'csv_cubit.dart';

class CsvTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CsvCubit, List<List<dynamic>>>(
      builder: (context, data) {
        if (data.isEmpty) {
          return Center(child: Text('No data loaded'));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
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
