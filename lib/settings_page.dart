import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return SwitchListTile(
                  title: Text('Show Table'),
                  value: state.showTable,
                  onChanged: (value) {
                    context.read<SettingsCubit>().toggleShowTable();
                  },
                );
              },
            ),
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return ListTile(
                  title: Text('Max Visible Points'),
                  subtitle: Slider(
                    value: state.maxVisiblePoints.toDouble(),
                    min: 10,
                    max: 100,
                    divisions: 9,
                    label: state.maxVisiblePoints.toString(),
                    onChanged: (value) {
                      context
                          .read<SettingsCubit>()
                          .setMaxVisiblePoints(value.toInt());
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
