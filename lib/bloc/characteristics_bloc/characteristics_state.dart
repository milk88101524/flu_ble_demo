import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class CharacteristicsState extends Equatable {
  @override
  List<Object?> get props => [];
}

// 初始狀態
class CharacteristicsInitial extends CharacteristicsState {}

// 操作進行中
class CharacteristicsLoading extends CharacteristicsState {}

// 啟用通知成功
class NotificationEnabled extends CharacteristicsState {}

// Descriptor 讀取成功
class DescriptorReadSuccess extends CharacteristicsState {
  final BluetoothCharacteristic characteristic;
  final List<int> value;

  DescriptorReadSuccess(this.characteristic, this.value);

  @override
  List<Object?> get props => [characteristic, value];
}

// Descriptor 寫入成功
class DescriptorWriteSuccess extends CharacteristicsState {
  final BluetoothCharacteristic characteristic;
  final List<int> value;

  DescriptorWriteSuccess(this.characteristic, this.value);

  @override
  List<Object?> get props => [characteristic, value];
}

// 操作失敗
class CharacteristicsError extends CharacteristicsState {
  final String message;

  CharacteristicsError(this.message);

  @override
  List<Object?> get props => [message];
}
