import 'package:equatable/equatable.dart';

abstract class BleScanEvent extends Equatable {
  const BleScanEvent();

  @override
  List<Object?> get props => [];
}

class StartScan extends BleScanEvent {}

class StopScan extends BleScanEvent {}
