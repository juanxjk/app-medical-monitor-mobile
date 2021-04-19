import 'dart:convert';

import 'package:app_medical_monitor/exceptions/server_exception.dart';
import 'package:app_medical_monitor/exceptions/validation_exception.dart';
import 'package:app_medical_monitor/models/session.dart';
import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/routes.dart';
import 'package:app_medical_monitor/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class SessionService {
  final Uri _uri = baseUrl.resolve("/sessions");
  Future<User> login(
      {required String username, required String password}) async {
    final body = json.encode({'username': username, 'password': password});
    final response = await http
        .post(_uri, body: body, headers: headers)
        .timeout(Duration(milliseconds: 1000));
    if (response.statusCode == 200) {
      final String token = json.decode(response.body)["token"];
      final String userId = JwtDecoder.decode(token)["id"];
      final User loggedUser = await UserService(token: token).findByID(userId);
      loggedUser.session = Session(token: token);
      return loggedUser;
    }
    if (response.statusCode >= 400 && response.statusCode < 500)
      throw ValidationException();
    if (response.statusCode >= 500) throw ServerException();

    throw Exception("Unexpected error on SessionService: login");
  }
}
