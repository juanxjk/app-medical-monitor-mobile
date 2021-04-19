import 'package:app_medical_monitor/models/device.dart';

enum PatientStatus {
  none,
  waiting,
  treatment,
  discharged,
}

enum GenderType { masculine, feminine }

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
        this.gender = getGenderFromString(json['gender']),
        this.birthDate = DateTime.parse(json['birthDate']),
        this.status = getStatusFromString(json['status']),
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

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'fullName': this.fullName,
      'cpf': this.cpf,
      'gender': getGenderString(this.gender),
      'birthDate': this.birthDate.toIso8601String(),
      'status': getStatusString(this.status),
      'bed': this.bed,
      'note': this.note,
      'devices': this.devices,
      'illnesses': this.illnesses,
      'comorbidities': this.comorbidities,
      'prognosis': this.prognosis,
    };
  }

  static getGenderFromString(String gender) {
    return GenderType.values
        .firstWhere((e) => e.toString() == 'GenderType.' + gender);
  }

  static getStatusFromString(String status) {
    return PatientStatus.values
        .firstWhere((e) => e.toString() == 'PatientStatus.' + status);
  }

  static String getGenderString(GenderType gender) {
    switch (gender) {
      case GenderType.masculine:
        return 'masculine';
      case GenderType.feminine:
        return "feminine";
      default:
        throw Exception("Invalid gender");
    }
  }

  static String getStatusString(PatientStatus status) {
    switch (status) {
      case PatientStatus.none:
        return 'none';
      case PatientStatus.waiting:
        return 'waiting';
      case PatientStatus.treatment:
        return 'treatment';
      case PatientStatus.discharged:
        return 'discharged';
      default:
        throw Exception("Invalid status");
    }
  }
}
