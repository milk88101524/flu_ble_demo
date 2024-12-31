import 'package:flu_ble_demo/bloc/characteristics_bloc/characteristics_bloc.dart';
import 'package:flu_ble_demo/bloc/characteristics_bloc/characteristics_event.dart';
import 'package:flu_ble_demo/bloc/characteristics_bloc/characteristics_state.dart';
import 'package:flu_ble_demo/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CharacteristicsItem extends StatelessWidget {
  final BluetoothCharacteristic characteristic;

  const CharacteristicsItem({super.key, required this.characteristic});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharacteristicsBloc(),
      child: CharacteristicsItemView(characteristic: characteristic),
    );
  }
}

class CharacteristicsItemView extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  const CharacteristicsItemView({super.key, required this.characteristic});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (characteristic.properties.notify) {
            context
                .read<CharacteristicsBloc>()
                .add(EnableNotification(characteristic));
          } else if (characteristic.properties.write) {
            showWriteCharacteristics(context, (value) {
              context.read<CharacteristicsBloc>().add(
                  WriteCharacteristics(characteristic, makeByteArray(value)));
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Characteristic UUID:\n${characteristic.characteristicUuid.str}\nProperties:[${getProperties(characteristic.properties)}]",
              ),
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  for (final descriptor in characteristic.descriptors)
                    Text(
                        "Descriptor:\n${getDescriptorName(descriptor.descriptorUuid)}"),
                ],
              ),
              BlocBuilder<CharacteristicsBloc, CharacteristicsState>(
                builder: (context, state) {
                  if (state is CharacteristicsLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is NotificationEnabled) {
                    return const Text("Notification enabled!");
                  } else if (state is DescriptorReadSuccess) {
                    return Text(bytesToHesString(state.value));
                  } else if (state is DescriptorWriteSuccess) {
                    return Text(bytesToHesString(state.value));
                  } else if (state is CharacteristicsError) {
                    return Text("Error: ${state.message}");
                  } else if (state is CharacteristicsInitial) {
                    return Text("");
                  }
                  return Text("");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showWriteCharacteristics(BuildContext context, Function(String) onWrite) {
  TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Write Characteristics"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onWrite(controller.text);
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}
