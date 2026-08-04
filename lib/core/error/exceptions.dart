/// Datasource-level exceptions. Repositories catch these and map them to
/// a [Failure] before returning to the domain layer.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Error del servidor']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Error de autenticación']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Sin conexión a internet']);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'No se encontró el recurso']);
}
