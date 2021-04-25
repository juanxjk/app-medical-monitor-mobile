import 'dart:convert';

import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/interfaces/service.dart';
import 'package:app_medical_monitor/services/routes.dart';
import 'package:http/http.dart' as http;

class UserService implements Service<User> {
  String _token;

  UserService({required String token}) : this._token = token;

  Future<List<User>> findAll(
      {int page = 1, int size = 10, String name = ""}) async {
    final String path = "/users?page=$page&size=$size&name=$name";
    final url = baseUrl.resolve(path);
    final response = await http
        .get(url, headers: headerWithAuth(_token))
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode == 200) {
      final List<dynamic> bodyJson = jsonDecode(response.body);
      final List<User> users = User.fromJsonList(bodyJson);

      return users;
    }

    throw Exception("Unexpected error on UserService: findAll");
  }

  @override
  Future<User> findByID(String id) async {
    final String path = "/users/$id";
    final url = baseUrl.resolve(path);
    final response = await http
        .get(url, headers: headerWithAuth(_token))
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final user = User.fromJson(body);
      return user;
    }

    throw Exception("Unexpected error on UserService: findByID");
  }

  @override
  Future<void> save(User user) async {
    Uri url = baseUrl.resolve("/users");
    Map<String, dynamic> bodyJson = user.toJson();
    final body = jsonEncode(bodyJson);
    final response = await http
        .post(url, headers: headerWithAuth(_token), body: body)
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode == 201) {
      return;
    }

    throw Exception("Unexpected error on UserService: save");
  }

  @override
  Future<void> update(User data) async {
    String id = data.id!;
    Uri url = baseUrl.resolve("/users/$id");
    Map<String, dynamic> bodyJson = data.toJson();
    final body = jsonEncode(bodyJson);
    final response = await http
        .patch(url, headers: headerWithAuth(_token), body: body)
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode == 200) {
      return;
    }

    throw Exception("Unexpected error on UserService: update");
  }

  @override
  Future<void> remove(String id) async {
    final String path = "/users/$id";
    final Uri url = baseUrl.resolve(path);
    final response = await http
        .delete(url, headers: headerWithAuth(_token))
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode != 204) throw Exception("Remove method has failed");
  }
}
