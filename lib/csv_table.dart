import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'csv_cubit.dart';

class CsvTable extends StatefulWidget {
  @override
  _CsvTableState createState() => _CsvTableState();
}

class _CsvTableState extends State<CsvTable> {
  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CsvCubit, List<List<dynamic>>>(
      builder: (context, data) {
        if (data.isEmpty) {
          return const Center(
              child: Text('No data loaded',
                  style: TextStyle(color: Colors.white)));
        }

        final columns = data.first
            .map((col) => DataColumn(
                label: Text(col.toString(),
                    style: const TextStyle(color: Colors.white))))
            .toList();
        final rows = data.skip(1).map((row) {
          return DataRow(
              cells: row
                  .map((cell) => DataCell(Text(
                        cell.toString(),
                        style: const TextStyle(color: Colors.white),
                      )))
                  .toList());
        }).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Theme(
            data: ThemeData(
              secondaryHeaderColor: Colors.black,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Color.fromARGB(255, 38, 44, 48)),
              bannerTheme: const MaterialBannerThemeData(
                  backgroundColor: Color.fromARGB(255, 38, 44, 48)),
              //textTheme: const TextTheme(caption: TextStyle(color: Colors.white)),
              dataTableTheme: DataTableThemeData(
                headingRowColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  // Set color for heading row
                  return const Color.fromARGB(255, 38, 44, 48); // example color
                }),
                dataRowColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  // Set color for data rows
                  return const Color.fromARGB(255, 38, 44, 48); // example color
                }),
                // Add other customizations here
              ),
            ),
            child: PaginatedDataTable(
              footerStyle: const TextStyle(color: Colors.white),
              headerBackgroundColor: const Color.fromARGB(255, 38, 44, 48),
              footerBackgroundColor: const Color.fromARGB(255, 38, 44, 48),
              header:
                  const Text('CSV Data', style: TextStyle(color: Colors.white)),
              columns: columns,
              source: _DataSource(rows),
              rowsPerPage: rowsPerPage,
              onRowsPerPageChanged: (perPage) {
                setState(() {
                  rowsPerPage = perPage!;
                });
              },
              columnSpacing: 16.0,
              horizontalMargin: 16.0,
              showCheckboxColumn: false,
              arrowHeadColor: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

class _DataSource extends DataTableSource {
  final List<DataRow> _rows;

  _DataSource(this._rows);

  @override
  DataRow? getRow(int index) {
    if (index >= _rows.length) return null;
    return _rows[index];
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
