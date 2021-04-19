import 'package:app_medical_monitor/models/session.dart';

enum UserRole { admin, doctor, nurse, patient, guest }

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
        this.role = getRoleFromString(json['role']);

  Map<String, dynamic> toJson() {
    final json = {
      'id': this.id,
      'username': this.username,
      'fullName': this.fullName,
      'email': this.email,
      'isVerified': this.isVerified,
      'isBanned': this.isBanned,
      'role': getRoleString(this.role),
    };

    if (this.password?.isNotEmpty ?? false) json['password'] = this.password;

    return json;
  }

  static UserRole getRoleFromString(String role) {
    return UserRole.values
        .firstWhere((e) => e.toString() == 'UserRole.' + role);
  }

  static String getRoleString(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'admin';
      case UserRole.doctor:
        return 'doctor';
      case UserRole.nurse:
        return 'nurse';
      case UserRole.patient:
        return 'patient';
      case UserRole.guest:
        return 'guest';
      default:
        throw Exception("Invalid UserRole");
    }
  }
}
