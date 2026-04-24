/// Constantes de la aplicacion.
abstract class AppConstants {
  static const String appName = 'Registro Salidas Embarques';
  static const String appVersion = '1.0.2'; // Debe coincidir con UpdateConfig.currentVersion
  static const String appDescription =
      'Registro de salidas de productos del almacen de embarques';

  // Rutas de navegacion
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String scanRoute = '/scan';
  static const String scanResultRoute = '/scan-result';
  static const String historyRoute = '/history';
  static const String settingsRoute = '/settings';
}
