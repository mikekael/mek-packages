import 'package:mek_data_class/mek_data_class.dart';

part 'reader.g.dart';

@DataClass()
class StripeReader with _$StripeReader {
  final LocationStatus locationStatus;
  final double batteryLevel;
  final DeviceType deviceType;
  final bool simulated, availableUpdate;
  final String? locationId;
  final String serialNumber;
  final String? label;

  const StripeReader({
    required this.locationStatus,
    required this.batteryLevel,
    required this.deviceType,
    required this.simulated,
    required this.availableUpdate,
    required this.serialNumber,
    required this.locationId,
    required this.label,
  });
}

enum LocationStatus {
  unknown,
  set,
  notSet,
}

enum DeviceType {
  chipper1X,
  chipper2X,
  stripeM2,
  cotsDevice,
  verifoneP400,
  wiseCube,
  wisepad3,
  wisepad3s,
  wiseposE,
  wiseposEDevkit,
  etna,
  stripeS700,
  stripeS700Devkit,
  unknown
}

enum ConnectionStatus { notConnected, connected, connecting }