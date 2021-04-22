import 'package:app_medical_monitor/models/patient.dart';
import 'package:flutter/foundation.dart';

enum DeviceStatus { none, active, maintenance, inactive }

extension DeviceStatusExtention on DeviceStatus {
  static DeviceStatus fromString(String status) {
    return DeviceStatus.values
        .firstWhere((value) => describeEnum(value) == status);
  }

  String get name => describeEnum(this);
  String get displayName {
    switch (this) {
      case DeviceStatus.none:
        return "nenhum";
      case DeviceStatus.active:
        return "funcionando";
      case DeviceStatus.maintenance:
        return "em manutenção";
      case DeviceStatus.inactive:
        return "inativado";
    }
  }
}

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
        this.status = DeviceStatusExtention.fromString(json['status']),
        this.canMeasureO2Pulse = json['canMeasureO2Pulse'] ?? false,
        this.canMeasureHeartRate = json['canMeasureHeartRate'] ?? false,
        this.canMeasureTemp = json['canMeasureTemp'],
        this.patient = json['patient'];

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "description": this.description,
      "status": this.status.name,
      "canMeasureHeartRate": this.canMeasureHeartRate,
      "canMeasureO2Pulse": this.canMeasureO2Pulse,
      "canMeasureTemp": this.canMeasureTemp,
      "patient": this.patient
    };
  }
}
