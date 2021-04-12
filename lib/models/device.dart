import 'package:app_medical_monitor/models/patient.dart';

enum DeviceStatus { none, active, maintenance, inactive }

class Device {
  String? id;
  String title;
  String description;
  DeviceStatus status;
  bool canMeasureHeartRate;
  bool canMeasureO2Pulse;
  bool canMeasureTemp;
  double? heartRate;
  double? o2pulse;
  double? temperature;
  Patient? patient;

  Device(
      {this.id,
      required this.title,
      this.description = "",
      this.status = DeviceStatus.none,
      this.canMeasureO2Pulse = false,
      this.canMeasureHeartRate = false,
      this.canMeasureTemp = false,
      this.patient});
}
