import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class CharacteristicsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// 啟用通知事件
class EnableNotification extends CharacteristicsEvent {
  final BluetoothCharacteristic characteristic;

  EnableNotification(this.characteristic);

  @override
  List<Object?> get props => [characteristic];
}

// 讀取 Descriptor 事件
class ReadCharacteristics extends CharacteristicsEvent {
  final BluetoothCharacteristic characteristic;

  ReadCharacteristics(this.characteristic);

  @override
  List<Object?> get props => [characteristic];
}

// 寫入 Descriptor
class WriteCharacteristics extends CharacteristicsEvent {
  final BluetoothCharacteristic characteristic;
  final List<int> value;

  WriteCharacteristics(this.characteristic, this.value);

  @override
  List<Object?> get props => [characteristic, value];
}

// Descriptor Changed
class DescriptorChanged extends CharacteristicsEvent {
  final BluetoothCharacteristic characteristic;
  final List<int> value;

  DescriptorChanged(this.characteristic, this.value);

  @override
  List<Object?> get props => [characteristic, value];
}
