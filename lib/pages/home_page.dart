import 'package:flu_ble_demo/bloc/ble_scan_bloc/ble_scan_bloc.dart';
import 'package:flu_ble_demo/bloc/ble_scan_bloc/ble_scan_event.dart';
import 'package:flu_ble_demo/bloc/ble_scan_bloc/ble_scan_state.dart';
import 'package:flu_ble_demo/components/device_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Scanner'),
      ),
      body: BlocBuilder<BleScanBloc, BleScanState>(
        builder: (context, state) {
          if (state is BleInitial) {
            print("BleInitial");
            return Center(child: Text('Press scan to start.'));
          } else if (state is BleScanning) {
            print("BleScanning");
            return Center(child: CircularProgressIndicator());
          } else if (state is BleScanSuccess) {
            print("BleScanSuccess");
            return ListView.builder(
              itemCount: state.devices.length,
              itemBuilder: (context, index) {
                final device = state.devices[index];
                return DeviceItem(device: device);
              },
            );
          } else if (state is BleScanError) {
            print("BleScanError");
            return Center(child: Text('Error: ${state.message}'));
          }
          return SizedBox.shrink();
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              context.read<BleScanBloc>().add(StartScan());
            },
            child: Icon(Icons.bluetooth_searching),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              context.read<BleScanBloc>().add(StopScan());
            },
            child: Icon(Icons.bluetooth_disabled),
          ),
        ],
      ),
    );
  }
}
