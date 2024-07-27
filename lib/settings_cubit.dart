import 'package:bloc/bloc.dart';

class SettingsState {
  final bool showTable;
  final int maxVisiblePoints;

  SettingsState({
    required this.showTable,
    required this.maxVisiblePoints,
  });

  SettingsState copyWith({
    bool? showTable,
    int? maxVisiblePoints,
  }) {
    return SettingsState(
      showTable: showTable ?? this.showTable,
      maxVisiblePoints: maxVisiblePoints ?? this.maxVisiblePoints,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
          showTable: true,
          maxVisiblePoints: 50,
        ));

  void toggleShowTable() {
    emit(state.copyWith(showTable: !state.showTable));
  }

  void setMaxVisiblePoints(int points) {
    emit(state.copyWith(maxVisiblePoints: points));
  }
}
