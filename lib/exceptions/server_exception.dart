class ServerException implements Exception {
  String message;
  ServerException([this.message = "Erro no servidor"]);
}
