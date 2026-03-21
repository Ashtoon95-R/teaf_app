import 'package:flutter/material.dart';
import 'welcome_ui.dart';
import 'diagnostico_helper.dart';
import 'app_language_provider.dart';
import 'app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguageProvider appLanguage = AppLanguageProvider();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final AppLanguageProvider appLanguage;

  MyApp({required this.appLanguage});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => appLanguage,
      child: Consumer<AppLanguageProvider>(builder: (context, model, child) {
        return MaterialApp(
          title: 'TeafAPP',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 53, 133, 182)),
            useMaterial3: true,
          ),
          home: SafeArea(child: WelcomeUI()),
          locale: model.appLocal,
          supportedLocales: const [
            Locale('es', 'ES'),
            Locale('en', 'EN'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          builder: (context, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              DiagnosticoHelper diagnosticohelper = DiagnosticoHelper();
              diagnosticohelper.loadData();
            });
            return child ?? const SizedBox.shrink();
          },
        );
      }),
    );
  }
}
