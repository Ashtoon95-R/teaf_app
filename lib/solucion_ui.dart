import 'package:flutter/material.dart';
import 'package:teaf_app/analisis1_ui.dart';
import 'package:teaf_app/inicio_ui.dart';
import 'resumen_ui.dart';
import 'welcome_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'diagnostico_helper.dart';
import 'app_language_provider.dart';
import 'app_localizations.dart';
import 'package:teaf_app/widgets/teaf_action_button.dart';

// ignore: must_be_immutable
class SolucionUI extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _SolucionUIState createState() => _SolucionUIState();
}

class _SolucionUIState extends State<SolucionUI> {
  Future<void> _launchURL(String url) async {
    Uri url0 = Uri.parse(url);
    if (await launchUrl(url0)) {
      await launchUrl(url0);
    } else {
      throw 'Could not launch $url0';
    }
  }

  @override
  void initState() {
    super.initState();
    diagnosticoHelper.loadData();
  }

  DiagnosticoHelper diagnosticoHelper = DiagnosticoHelper();
  late AppLanguageProvider appLanguage;

  @override
  Widget build(BuildContext context) {
    String? diagnosticoResult;
    DiagnosticoHelper diagnosticoHelper = DiagnosticoHelper();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 53, 133, 182),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Encabezado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                  ),
                  // Logo y nombre en una Columna
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          // Acción a realizar cuando se hace clic en el botón
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelcomeUI(),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('img/logo.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Puedes ajustar el tamaño del contenedor según tus necesidades
                              width: 50.0,
                              height: 50.0,
                            ),
                            SizedBox(height: 10),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('appName')!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Icono de idiomas
                  InkWell(
                    child: Container(
                      child: diagnosticoHelper.buildLanguageMenu(
                          context), // Llama a la función para construir el menú de idiomas
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                AppLocalizations.of(context)!.translate('diagnosis')!,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 50,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: 200.0, // Diámetro del círculo
                    height: 200.0, // Diámetro del círculo
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Forma circular
                    ),
                    child: Center(
                      child: FutureBuilder<String>(
                        future: diagnosticoHelper.diagnostico(
                            context), // Tu función para obtener los datos
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              diagnosticoResult = snapshot.data;
                              // Definir circleColor y cambiarlo según el resultado del diagnóstico
                              Color circleColor = Colors.transparent;
                              Color textColor = Colors.transparent;
                              double fontSize =
                                  14.0; // Tamaño de letra predeterminado

                              if (diagnosticoResult ==
                                  AppLocalizations.of(context)!
                                      .translate('incomplete')!) {
                                circleColor = Colors.orange;
                                textColor = Color(0xFF262f36);
                                fontSize = 28.0;
                              } else if (diagnosticoResult ==
                                  AppLocalizations.of(context)!
                                      .translate('error')!) {
                                circleColor = Colors.black;
                                textColor = Colors.white;
                                fontSize = 30.0;
                              } else {
                                circleColor =
                                    Color.fromARGB(255, 182, 223, 255);
                                textColor = Color(0xFF262f36);
                                fontSize = 40.0;
                              }

                              // Devolver el widget del círculo con el color y el tamaño de letra cambiado
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: circleColor,
                                      border: Border.all(
                                        color: Color(0xFF262f36),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    snapshot.data ??
                                        AppLocalizations.of(context)!.translate(
                                            'diagnosis_not_available')!,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // Mostrar el pop-up al tocar la imagen
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                AppLocalizations.of(context)!
                                    .translate('result_info')!,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate('visit_link_diagnosis')!,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _launchURL(
                                          'https://cursoteaf.com/'); // Llama a la función para abrir el enlace
                                    },
                                    child: Text(
                                      "https://cursoteaf.com/",
                                      style: TextStyle(
                                        color: const Color.fromARGB(255, 4, 60,
                                            105), // Estilo para que parezca un enlace
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .end, // Esto alineará el botón "Cerrar" a la derecha
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cerrar'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('img/pregunta.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TeafActionButton(
                      matchGroupWidth: true,
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Analisis1UI(),
                          ),
                        );
                      },
                      label: AppLocalizations.of(context)!.translate('edit')!,
                      buttonStyle: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xFF262f36)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      textColor: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 25,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TeafActionButton(
                      matchGroupWidth: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ResumenUI(diagnosticoResult: diagnosticoResult),
                          ),
                        );
                      },
                      label:
                          AppLocalizations.of(context)!.translate('summary')!,
                      buttonStyle: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xFF262f36)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      textColor: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 25,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TeafActionButton(
                      matchGroupWidth: true,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                AppLocalizations.of(context)!
                                    .translate('back_to_home')!,
                              ),
                              content: Text(
                                AppLocalizations.of(context)!
                                    .translate('data_loss_confirmation')!,
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('cancel')!,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    DiagnosticoHelper.resetPreferences(
                                        context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InicioUI(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('accept')!,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: AppLocalizations.of(context)!.translate('home')!,
                      buttonStyle: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xFF262f36)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      textColor: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 25,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
