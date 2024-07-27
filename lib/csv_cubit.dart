import 'package:flutter_bloc/flutter_bloc.dart';

class CsvCubit extends Cubit<List<List<dynamic>>> {
  CsvCubit() : super([]);

  void loadCsvData(List<List<dynamic>> data) {
    emit(data);
  }
}
