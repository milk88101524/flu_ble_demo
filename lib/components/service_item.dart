import 'package:flu_ble_demo/components/characteristics_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ServiceItem extends StatelessWidget {
  final BluetoothService service;
  const ServiceItem({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Services UUID:\n${service.serviceUuid.str128}"),
            Flexible(
              fit: FlexFit.loose,
              child: ListView(
                primary: false, // 避免衝突
                shrinkWrap: true, // 讓 ListView 根據內容大小調整
                children: [
                  for (final characteristic in service.characteristics)
                    CharacteristicsItem(characteristic: characteristic),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
