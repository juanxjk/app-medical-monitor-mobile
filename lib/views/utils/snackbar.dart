import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context, {
  required String message,
  required Color bgColor,
  Duration duration = const Duration(seconds: 1),
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: bgColor,
    duration: duration,
  ));
}

void showErrorSnackBar(BuildContext context,
        {String message = "Desculpe, ocorreu um erro", Duration? duration}) =>
    showSnackBar(context, message: message, bgColor: Colors.red);

void showSuccessSnackBar(BuildContext context,
        {String message = "Operação ocorreu com sucesso!",
        Duration duration = const Duration(seconds: 1)}) =>
    showSnackBar(context, message: message, bgColor: Colors.green);

void showInfoSnackBar(BuildContext context,
        {String message = "Processando..."}) =>
    showSnackBar(context, message: message, bgColor: Colors.blue);
