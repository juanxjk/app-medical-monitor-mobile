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
  String? bed;
  List<String> illnesses;
  List<String> comorbidities;
  String? prognosis;
  List<Device> devices;

  Patient({
    this.id,
    required this.fullName,
    required this.cpf,
    required this.gender,
    required this.birthDate,
    this.status = PatientStatus.none,
    this.bed,
    this.devices = const [],
    this.illnesses = const [],
    this.comorbidities = const [],
    this.prognosis,
  });
}
