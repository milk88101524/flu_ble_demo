import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flu_ble_demo/bloc/ble_scan_bloc/ble_scan_event.dart';
import 'package:flu_ble_demo/bloc/ble_scan_bloc/ble_scan_state.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BleScanBloc extends Bloc<BleScanEvent, BleScanState> {
  BleScanBloc() : super(BleInitial()) {
    on<StartScan>(_onStartScan);
    on<StopScan>(_onStopScan);
  }

  StreamSubscription<List<ScanResult>>? _scanSubscription;

  void _onStartScan(StartScan event, Emitter<BleScanState> emit) async {
    if (Platform.isAndroid) {
      await requestBluetoothPermissions();
    }
    final adapterState = await FlutterBluePlus.adapterState.first;

    if (adapterState == BluetoothAdapterState.on) {
      try {
        emit(BleScanning());
        _scanSubscription?.cancel();

        // 開始掃描
        FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

        await for (final results in FlutterBluePlus.scanResults) {
          final devices = results
              .map((result) => result.device)
              .where((device) => device.advName.isNotEmpty) // 過濾設備名稱
              .toList();

          print(results);
          // 發射成功狀態
          if (!emit.isDone) {
            emit(BleScanSuccess(devices));
          }
        }
      } catch (e) {
        if (!emit.isDone) {
          emit(BleScanError("Failed to start scan: ${e.toString()}"));
        }
      }
    } else {
      if (!emit.isDone) {
        emit(BleScanError("Bluetooth is not supported on this device."));
      }
    }
  }

  void _onStopScan(StopScan event, Emitter<BleScanState> emit) async {
    // 停止掃描並清理訂閱
    await FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();
    emit(BleInitial());
  }

  @override
  Future<void> close() {
    _scanSubscription?.cancel();
    return super.close();
  }
}

Future<void> requestBluetoothPermissions() async {
  if (await Permission.bluetoothScan.isDenied) {
    await Permission.bluetoothScan.request();
  }
  if (await Permission.bluetoothConnect.isDenied) {
    await Permission.bluetoothConnect.request();
  }
  if (await Permission.location.isDenied) {
    await Permission.location.request();
  }
}
