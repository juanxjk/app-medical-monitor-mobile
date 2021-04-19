class ValidationException implements Exception {
  String message;
  ValidationException([this.message = "Erro de validação"]);
}
