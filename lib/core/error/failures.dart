import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Domain-level error type. Repositories return `Either<Failure, T>` so
/// UI code never has to catch raw exceptions from datasources.
@freezed
sealed class Failure with _$Failure {
  const factory Failure.server([String? message]) = ServerFailure;
  const factory Failure.auth([String? message]) = AuthFailure;
  const factory Failure.network([String? message]) = NetworkFailure;
  const factory Failure.validation([String? message]) = ValidationFailure;
  const factory Failure.notFound([String? message]) = NotFoundFailure;
  const factory Failure.unknown([String? message]) = UnknownFailure;
}

extension FailureMessage on Failure {
  String get displayMessage => map(
        server: (e) => e.message ?? 'Error del servidor. Intenta de nuevo.',
        auth: (e) => e.message ?? 'Error de autenticación.',
        network: (e) => e.message ?? 'Sin conexión a internet.',
        validation: (e) => e.message ?? 'Datos inválidos.',
        notFound: (e) => e.message ?? 'No se encontró el recurso.',
        unknown: (e) => e.message ?? 'Ocurrió un error inesperado.',
      );
}

/// Best-effort human-readable message for anything an `AsyncValue.error`
/// might carry — a [Failure] thrown by a provider, or a raw exception.
String describeError(Object error) {
  if (error is Failure) return error.displayMessage;
  return 'Algo salió mal: $error';
}
