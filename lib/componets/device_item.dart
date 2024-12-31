import 'dart:async';
import 'package:flu_ble_demo/pages/device_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceItem extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceItem({super.key, required this.device});

  @override
  State<DeviceItem> createState() => _DeviceItemState();
}

class _DeviceItemState extends State<DeviceItem> {
  late StreamSubscription<BluetoothConnectionState> _stateSubscription;
  BluetoothConnectionState _deviceState = BluetoothConnectionState.disconnected;

  @override
  void initState() {
    super.initState();

    // 訂閱裝置狀態
    _stateSubscription = widget.device.connectionState.listen((state) {
      setState(() {
        _deviceState = state;
      });
    });
  }

  @override
  void dispose() {
    // 清理狀態訂閱
    _stateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = _deviceState == BluetoothConnectionState.connected
        ? "DISCONNECT"
        : "CONNECT";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card.filled(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.device.advName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.device.remoteId.str),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_deviceState == BluetoothConnectionState.connected) {
                        // 斷開連線
                        await widget.device.disconnect();
                      } else {
                        // 建立連線
                        await widget.device.connect();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                DeviceDetail(device: widget.device),
                          ),
                        );
                      }
                    },
                    child: Text(buttonText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
