import 'package:flu_ble_demo/log_manager.dart';
import 'package:flu_ble_demo/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'characteristics_event.dart';
import 'characteristics_state.dart';

class CharacteristicsBloc
    extends Bloc<CharacteristicsEvent, CharacteristicsState> {
  CharacteristicsBloc() : super(CharacteristicsInitial()) {
    on<EnableNotification>(_enableNotification);
    on<DescriptorChanged>(_onDescriptorChanged);
    on<ReadCharacteristics>(_readCharacteristics);
    on<WriteCharacteristics>(_writeCharacteristicsState);
  }

  Future<void> _enableNotification(
      EnableNotification event, Emitter<CharacteristicsState> emit) async {
    emit(CharacteristicsInitial());
    emit(CharacteristicsLoading());

    try {
      await event.characteristic.setNotifyValue(true);
      LogManager.addLog("Notification enable");
      // 監聽特徵值變化
      event.characteristic.onValueReceived.listen((value) {
        // 新增 DescriptorChanged 事件
        add(DescriptorChanged(event.characteristic, value));
      });
      emit(NotificationEnabled());
    } catch (e) {
      emit(CharacteristicsError(e.toString()));
    }
  }

  // 處理 DescriptorChanged 事件
  Future<void> _onDescriptorChanged(
      DescriptorChanged event, Emitter<CharacteristicsState> emit) async {
    emit(CharacteristicsInitial());
    LogManager.addLog("Descriptor Changed:\n${bytesToHesString(event.value)}");
    print(event.value);
    emit(DescriptorReadSuccess(event.characteristic, event.value));
  }

  void _readCharacteristics(
      ReadCharacteristics event, Emitter<CharacteristicsState> emit) {
    emit(CharacteristicsInitial());
    try {
      event.characteristic.onValueReceived.listen((value) {
        LogManager.addLog("Characteristic Read:\n${bytesToHesString(value)}");
        emit(DescriptorReadSuccess(event.characteristic, value));
      });
    } catch (e) {
      emit(CharacteristicsError(e.toString()));
    }
  }

  void _writeCharacteristicsState(
      WriteCharacteristics event, Emitter<CharacteristicsState> emit) {
    emit(CharacteristicsInitial());
    try {
      event.characteristic.write(event.value);
      LogManager.addLog(
          "Characteristic Write:\n${bytesToHesString(event.value)}");
      print(event.value);
      emit(DescriptorWriteSuccess(event.characteristic, event.value));
    } catch (e) {
      emit(CharacteristicsError(e.toString()));
    }
  }
}
