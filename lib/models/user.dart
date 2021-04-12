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
}
