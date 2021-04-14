import 'dart:convert';

import 'package:app_medical_monitor/models/device.dart';
import 'package:app_medical_monitor/services/interfaces/service.dart';
import 'package:app_medical_monitor/services/routes.dart';
import 'package:http/http.dart' as http;

class DeviceService implements Service<Device> {
  String _token;

  DeviceService({required String token}) : this._token = token;

  Future<List<Device>> findAll(
      {int page = 1, int size = 10, String name = ""}) async {
    final String path = "/devices?page=$page&size=$size&name=$name";
    final url = baseUrl.resolve(path);
    final response = await http
        .get(url, headers: headerWithAuth(_token))
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode == 200) {
      final List<dynamic> bodyJson = jsonDecode(response.body);
      final List<Device> devices = [];

      bodyJson.forEach((element) {
        final Map<String, dynamic> e = element;
        final Device device = Device.fromJson(e);
        devices.add(device);
      });
      return devices;
    }

    throw Exception("Unexpected error on DeviceService: findAll");
  }

  @override
  Future<Device> findByID(String id) async {
    final String path = "/devices/$id";
    final url = baseUrl.resolve(path);
    final response = await http
        .get(url, headers: headerWithAuth(_token))
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final device = Device.fromJson(body);
      return device;
    }

    throw Exception("Unexpected error on DeviceService: findByID");
  }

  @override
  Future<void> save(Device device) async {
    Uri url = baseUrl.resolve("/devices");
    Map<String, dynamic> bodyJson = device.toJson();
    final body = jsonEncode(bodyJson);
    final response = await http
        .post(url, headers: headerWithAuth(_token), body: body)
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode == 201) {
      return;
    }

    throw Exception("Unexpected error on DeviceService: save");
  }

  @override
  Future<void> update(Device data) async {
    String id = data.id!;
    Uri url = baseUrl.resolve("/devices/$id");
    Map<String, dynamic> bodyJson = data.toJson();
    final body = jsonEncode(bodyJson);
    final response = await http
        .patch(url, headers: headerWithAuth(_token), body: body)
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode == 200) {
      return;
    }

    throw Exception("Unexpected error on DeviceService: update");
  }

  @override
  Future<void> remove(String id) async {
    final String path = "/devices/$id";
    final Uri url = baseUrl.resolve(path);
    final response = await http
        .delete(url, headers: headerWithAuth(_token))
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode != 204) throw Exception("Remove method has failed");
  }
}
