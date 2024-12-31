import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BleScanState {
  BleScanState();

  List<Object?> get props => [];
}

class BleInitial extends BleScanState {}

class BleScanning extends BleScanState {}

class BleScanSuccess extends BleScanState {
  final List<BluetoothDevice> devices;

  BleScanSuccess(this.devices);

  @override
  List<Object?> get props => [];
}

class BleScanError extends BleScanState {
  final String message;

  BleScanError(this.message);

  @override
  List<Object?> get props => [message];
}
