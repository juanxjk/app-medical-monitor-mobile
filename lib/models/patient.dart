import 'package:app_medical_monitor/models/device.dart';
import 'package:flutter/foundation.dart';

enum PatientStatus {
  none,
  waiting,
  treatment,
  discharged,
}

extension PatientStatusExtention on PatientStatus {
  static PatientStatus fromString(String status) {
    return PatientStatus.values
        .firstWhere((value) => describeEnum(value) == status);
  }

  String get name => describeEnum(this);
  String get displayName {
    switch (this) {
      case PatientStatus.none:
        return "nenhum";
      case PatientStatus.waiting:
        return "em espera";
      case PatientStatus.treatment:
        return "em tratamento";
      case PatientStatus.discharged:
        return "com alta";
    }
  }
}

enum GenderType { masculine, feminine }

extension GenderTypeExtention on GenderType {
  static GenderType fromString(String status) {
    return GenderType.values
        .firstWhere((value) => describeEnum(value) == status);
  }

  String get name => describeEnum(this);
  String get displayName {
    switch (this) {
      case GenderType.masculine:
        return "masculino";
      case GenderType.feminine:
        return "feminino";
    }
  }
}

class Patient {
  String? id;
  String fullName;
  String cpf;
  GenderType gender;
  DateTime birthDate;
  PatientStatus status;
  String bed;
  String note;
  List<String> illnesses;
  List<String> comorbidities;
  String prognosis;
  List<Device> devices;

  Patient({
    this.id,
    required this.fullName,
    required this.cpf,
    required this.gender,
    required this.birthDate,
    this.status = PatientStatus.none,
    this.bed = "",
    this.note = "",
    this.devices = const [],
    this.illnesses = const [],
    this.comorbidities = const [],
    this.prognosis = "",
  });

  Patient.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.fullName = json['fullName'],
        this.cpf = json['cpf'],
        this.gender = GenderTypeExtention.fromString(json['gender']),
        this.birthDate = DateTime.parse(json['birthDate']),
        this.status = PatientStatusExtention.fromString(json['status']),
        this.bed = json['bed'] ?? "",
        this.note = json['note'] ?? "",
        this.devices = json['devices'] ?? [],
        this.illnesses = (json['illnesses'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        this.comorbidities = (json['comorbidities'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        this.prognosis = json['prognosis'] ?? "";

  static List<Patient> fromJsonList(List<dynamic>? jsonList) {
    final List<Patient> list =
        List.of(jsonList?.map((e) => Patient.fromJson(e)).toList() ?? []);
    return list;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'fullName': this.fullName,
      'cpf': this.cpf,
      'gender': this.gender.name,
      'birthDate': this.birthDate.toIso8601String(),
      'status': this.status.name,
      'bed': this.bed,
      'note': this.note,
      'devices': this.devices,
      'illnesses': this.illnesses,
      'comorbidities': this.comorbidities,
      'prognosis': this.prognosis,
    };
  }
}
