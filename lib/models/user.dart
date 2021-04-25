import 'package:app_medical_monitor/models/session.dart';
import 'package:flutter/foundation.dart';

enum UserRole { admin, doctor, nurse, patient, guest }

extension UserRoleExtention on UserRole {
  static UserRole fromString(String status) {
    return UserRole.values.firstWhere((value) => describeEnum(value) == status);
  }

  String get name => describeEnum(this);
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return "administrador";
      case UserRole.doctor:
        return "médico";
      case UserRole.nurse:
        return "enfermeiro";
      case UserRole.patient:
        return "paciente";
      case UserRole.guest:
        return "convidado";
    }
  }
}

class User {
  String? id;
  String username;
  String? password;
  String fullName;
  String email;
  bool isVerified;
  bool isBanned;
  Session? session;
  UserRole role;

  User({
    this.id,
    required this.fullName,
    required this.username,
    required this.email,
    this.password,
    this.isBanned = false,
    this.session,
    this.isVerified = false,
    this.role = UserRole.guest,
  });

  User.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.fullName = json['fullName'],
        this.username = json['username'],
        this.email = json['email'],
        this.isBanned = json['isBanned'],
        this.isVerified = json['isVerified'],
        this.role = UserRoleExtention.fromString(json['role']);

  static List<User> fromJsonList(List<dynamic>? jsonList) {
    final List<User> list =
        List.of(jsonList?.map((e) => User.fromJson(e)).toList() ?? []);
    return list;
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': this.id,
      'username': this.username,
      'fullName': this.fullName,
      'email': this.email,
      'isVerified': this.isVerified,
      'isBanned': this.isBanned,
      'role': this.role.name,
    };

    if (this.password?.isNotEmpty ?? false) json['password'] = this.password;

    return json;
  }
}
