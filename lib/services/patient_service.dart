import 'dart:convert';

import 'package:app_medical_monitor/models/patient.dart';
import 'package:app_medical_monitor/services/interfaces/service.dart';
import 'package:app_medical_monitor/services/routes.dart';
import 'package:http/http.dart' as http;

class PatientService implements Service<Patient> {
  String _token;

  PatientService({required String token}) : this._token = token;

  Future<List<Patient>> findAll({int page = 1, int size = 10}) async {
    final String path = "/patients?page=$page&size=$size";
    final url = baseUrl.resolve(path);
    final response = await http
        .get(url, headers: headerWithAuth(_token))
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode == 200) {
      final List<dynamic> bodyJson = jsonDecode(response.body);
      final List<Patient> patients = [];

      bodyJson.forEach((element) {
        final Map<String, dynamic> e = element;
        final Patient patient = Patient.fromJson(e);
        patients.add(patient);
      });
      return patients;
    }

    throw Exception("Unexpected error on PatientService: findAll");
  }

  @override
  Future<Patient> findByID(String id) async {
    final String path = "/patients/$id";
    final url = baseUrl.resolve(path);
    final response = await http
        .get(url, headers: headerWithAuth(_token))
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final patient = Patient.fromJson(body);
      return patient;
    }

    throw Exception("Unexpected error on PatientService: findByID");
  }

  @override
  Future<void> save(Patient patient) async {
    Uri url = baseUrl.resolve("/patients");
    Map<String, dynamic> bodyJson = patient.toJson();
    final body = jsonEncode(bodyJson);
    final response = await http
        .post(url, headers: headerWithAuth(_token), body: body)
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode == 201) {
      return;
    }

    throw Exception("Unexpected error on PatientService: save");
  }

  @override
  Future<void> update(Patient data) async {
    String id = data.id!;
    Uri url = baseUrl.resolve("/patients/$id");
    Map<String, dynamic> bodyJson = data.toJson();
    final body = jsonEncode(bodyJson);
    final response = await http
        .patch(url, headers: headerWithAuth(_token), body: body)
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode == 200) {
      return;
    }

    throw Exception("Unexpected error on PatientService: update");
  }

  @override
  Future<void> remove(String id) async {
    final String path = "/patients/$id";
    final Uri url = baseUrl.resolve(path);
    final response = await http
        .delete(url, headers: headerWithAuth(_token))
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode != 204) throw Exception("Remove failed");

    throw Exception("Unexpected error on PatientService: remove");
  }
}
