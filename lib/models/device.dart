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

  Device.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.title = json['title'],
        this.description = json['description'] ?? "",
        this.status = getStatusFromString(json['status']),
        this.canMeasureO2Pulse = json['canMeasureO2Pulse'] ?? false,
        this.canMeasureHeartRate = json['canMeasureHeartRate'] ?? false,
        this.canMeasureTemp = json['canMeasureTemp'],
        this.patient = json['patient'];

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "description": this.description,
      "status": getStatusString(this.status),
      "canMeasureHeartRate": this.canMeasureHeartRate,
      "canMeasureO2Pulse": this.canMeasureO2Pulse,
      "canMeasureTemp": this.canMeasureTemp,
      "patient": this.patient
    };
  }

  static String getStatusString(DeviceStatus status) {
    switch (status) {
      case DeviceStatus.none:
        return "none";
      case DeviceStatus.active:
        return "active";
      case DeviceStatus.maintenance:
        return "maintenance";
      case DeviceStatus.inactive:
        return "inactive";
      default:
        throw Exception("Error");
    }
  }

  static DeviceStatus getStatusFromString(String status) {
    return DeviceStatus.values
        .firstWhere((e) => e.toString() == 'DeviceStatus.' + status);
  }
}
