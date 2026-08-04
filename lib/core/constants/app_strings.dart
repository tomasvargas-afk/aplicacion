/// Shared UI copy (Spanish). Screen-specific copy lives inline in the
/// screen that uses it; only strings reused across features live here.
abstract class AppStrings {
  AppStrings._();

  static const appName = 'FitNutri';

  // Generic actions
  static const save = 'Guardar';
  static const cancel = 'Cancelar';
  static const delete = 'Eliminar';
  static const edit = 'Editar';
  static const add = 'Añadir';
  static const retry = 'Reintentar';
  static const confirm = 'Confirmar';
  static const close = 'Cerrar';

  // Generic states
  static const loading = 'Cargando...';
  static const somethingWentWrong = 'Algo salió mal';
  static const noDataYet = 'Todavía no hay datos';

  // Validation
  static const requiredField = 'Este campo es obligatorio';
  static const invalidEmail = 'Correo electrónico inválido';
  static const passwordTooShort = 'La contraseña debe tener al menos 6 caracteres';
  static const passwordsDoNotMatch = 'Las contraseñas no coinciden';
}
