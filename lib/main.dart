import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/services/auth_service.dart';
import 'core/services/update_service.dart';
import 'core/config/update_config.dart';
import 'shared/widgets/update_dialog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Orientación preferida para PDA
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await AuthService.restoreSession();

  runApp(const RegistroSalidasEmbarquesApp());
}

/// Aplicación principal: Registro de Salidas de Embarques.
class RegistroSalidasEmbarquesApp extends StatefulWidget {
  final bool enableStartupUpdateCheck;

  const RegistroSalidasEmbarquesApp({
    super.key,
    this.enableStartupUpdateCheck = true,
  });

  /// Acceso global al state para cambio de tema (mockup).
  static RegistroSalidasEmbarquesAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<RegistroSalidasEmbarquesAppState>();

  @override
  State<RegistroSalidasEmbarquesApp> createState() =>
      RegistroSalidasEmbarquesAppState();
}

class RegistroSalidasEmbarquesAppState
    extends State<RegistroSalidasEmbarquesApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  ThemeMode _themeMode = ThemeMode.dark;
  bool _startupUpdateCheckStarted = false;

  ThemeMode get themeMode => _themeMode;

  @override
  void initState() {
    super.initState();
    if (widget.enableStartupUpdateCheck) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkForStartupUpdates();
      });
    }
  }

  void setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  Future<void> _checkForStartupUpdates() async {
    if (_startupUpdateCheckStarted || !UpdateConfig.checkOnStartup) {
      return;
    }

    _startupUpdateCheckStarted = true;

    final updateInfo = await UpdateService.checkForUpdate();
    if (!mounted || updateInfo == null) {
      return;
    }

    final navigatorContext = _navigatorKey.currentContext;
    if (navigatorContext == null || !navigatorContext.mounted) {
      return;
    }

    await UpdateDialog.show(navigatorContext, updateInfo);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      initialRoute: AuthService.isAuthenticated
          ? AppConstants.homeRoute
          : AppConstants.loginRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
