import 'dart:async';
import 'dart:io';
import 'package:flu_ble_demo/components/service_item.dart';
import 'package:flu_ble_demo/log_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceDetail extends StatefulWidget {
  final BluetoothDevice device;
  const DeviceDetail({super.key, required this.device});

  @override
  State<DeviceDetail> createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {
  final FocusNode focusNode = FocusNode();
  late StreamSubscription<BluetoothConnectionState> _stateSubscription;
  BluetoothConnectionState _deviceState = BluetoothConnectionState.disconnected;
  List<BluetoothService> services = [];

  @override
  void initState() {
    super.initState();

    // 訂閱裝置狀態變化
    _stateSubscription = widget.device.connectionState.listen((state) {
      if (mounted) {
        setState(() {
          _deviceState = state;
          LogManager.addLog("Device State: $state");
        });
        // 連線成功後取得服務
        if (state == BluetoothConnectionState.connected) {
          getServices();
        }
      }
    });

    // 主動嘗試連線裝置
    connectToDevice();
  }

  @override
  void dispose() {
    _stateSubscription.cancel();
    super.dispose();
  }

  Future<void> connectToDevice() async {
    if (_deviceState != BluetoothConnectionState.connected) {
      await widget.device.connect();
    }
  }

  Future<void> getServices() async {
    try {
      if (widget.device.isConnected) {
        final discoveredServices = await widget.device.discoverServices();
        if (mounted) {
          setState(() {
            services = discoveredServices;
          });
        }
      }
    } catch (e) {
      print("Error discovering services: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String text = _deviceState == BluetoothConnectionState.connected
        ? "Connected"
        : "Disconnected";
    String buttonText = _deviceState == BluetoothConnectionState.connected
        ? "DISCONNECT"
        : "CONNECT";
    TextEditingController mtuController = TextEditingController();

    return GestureDetector(
      onTap: () => focusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.device.advName),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.device.advName),
              Text(widget.device.remoteId.str),
              Text(text),
              ElevatedButton(
                onPressed: () async {
                  if (_deviceState == BluetoothConnectionState.connected) {
                    await widget.device.disconnect();
                  } else {
                    await widget.device.connect();
                  }
                },
                child: Text(buttonText),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        focusNode: focusNode,
                        controller: mtuController,
                        decoration: InputDecoration(
                          label: Text("MTU"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (widget.device.isConnected &&
                              Platform.isAndroid &&
                              mtuController.text.isEmpty) {
                            widget.device
                                .requestMtu(int.parse(mtuController.text));
                          }
                          setState(() {
                            LogManager.addLog("MTU: ${widget.device.mtuNow}");
                          });
                          focusNode.unfocus();
                        },
                        child: Text("Set"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: services.isEmpty
                      ? [const Text("No services found")]
                      : services.map((service) {
                          return ServiceItem(service: service);
                        }).toList(),
                ),
              ),
            ],
          ),
        ),
        endDrawer: Container(
          width: 300,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Text(LogManager.logs[index]);
              },
              itemCount: LogManager.logs.length,
            ),
          ),
        ),
      ),
    );
  }
}
