import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

String getDescriptorName(Guid uuid) {
  switch (uuid.toString()) {
    case "2900":
      return "Characteristic Extended Properties";
    case "2901":
      return "Characteristic User Description";
    case "2902":
      return "Client Characteristic Configuration";
    case "2903":
      return "Server Characteristic Configuration";
    case "2904":
      return "Characteristic Presentation Format";
    case "2905":
      return "Characteristic Aggregate Format";
    case "2906":
      return "Valid Range";
    case "2907":
      return "External Report Reference";
    case "2908":
      return "Report Reference";
    case "2909":
      return "Number of Digitals";
    case "290A":
      return "Value Trigger Setting";
    case "290B":
      return "Environmental Sensing Configuration";
    case "290C":
      return "Environmental Sensing Measurement";
    case "290D":
      return "Environmental Sensing Trigger Setting";
    case "290E":
      return "Time Trigger Setting";
    case "290F":
      return "Complete BR-EDR Transport Block Data";
    case "2910":
      return "Observation Schedule";
    case "2911":
      return "Valid Range and Accuracy";
    default:
      return "Unknown Descriptor";
  }
}

String getProperties(CharacteristicProperties properties) {
  if (properties.extendedProperties) {
    return "EXTENDED_PROPS";
  } else if (properties.authenticatedSignedWrites) {
    return "SIGNED_WRITE";
  } else if (properties.indicate) {
    return "INDICATE";
  } else if (properties.notify) {
    return "NOTIFY";
  } else if (properties.write) {
    return "WRITE";
  } else if (properties.writeWithoutResponse) {
    return "WRITE_NO_RESPONSE";
  } else if (properties.read) {
    return "READ";
  } else if (properties.broadcast) {
    return "BROADCAST";
  } else {
    return "";
  }
}

List<int> makeByteArray(String szParams) {
  StringBuffer buffer = StringBuffer();

  // 加入 ASCII \002 (Start of Text)
  buffer.writeCharCode(2);

  // 若 szParams 非空，則加入內容
  if (szParams.isNotEmpty) {
    buffer.write(szParams);
  }

  // 加入 ASCII \r (Carriage Return)
  buffer.write('\r');

  // 將結果轉換為位元組陣列 (UTF-8 編碼)
  return utf8.encode(buffer.toString());
}

String bytesToHesString(List<int> bytes) {
  return bytes.map((byte) => byte.toRadixString(16).padLeft(2, "0")).join(" ");
}
