// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaf_app/analisis5_ui.dart';
import 'package:teaf_app/analisis4_ui.dart';
import 'welcome_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_language_provider.dart';
import 'app_localizations.dart';
import 'diagnostico_helper.dart';
import 'package:teaf_app/widgets/teaf_action_button.dart';

class Analisis6UI extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _Analisis6UIState createState() => _Analisis6UIState();
}

class _Analisis6UIState extends State<Analisis6UI> {
  late AppLanguageProvider appLanguage;
  DiagnosticoHelper diagnosticoHelper = DiagnosticoHelper();
  // Variables para manejar el estado de los botones
  final String anomalias = 'preguntaAnomalías';
  final String recurrente = 'preguntaRecurrente';
  bool botonanomaliassi = false;
  bool botonanomaliasno = false;
  bool botonrecurrentesi = false;
  bool botonrecurrenteno = false;
  @override
  void initState() {
    super.initState();
    _loadAnomaliasSelectionFromPrefs();
    _loadRecurrenteSelectionFromPrefs();
    setState(() {
      botonanomaliassi = false;
      botonanomaliasno = false;
      botonrecurrentesi = false;
      botonrecurrenteno = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Analisis4UI(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('img/atras.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
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
                  InkWell(
                    child: Container(
                      child: diagnosticoHelper.buildLanguageMenu(context),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                AppLocalizations.of(context)!.translate('evaluation')!,
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
                  child: Center(
                    // Añadimos un contenedor centrado
                    child: SizedBox(
                      width:
                          350, // Ancho del contenedor para centrar el contenido
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 303,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('cranial_malformations')!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Acción cuando se presiona el botón "Sí"
                                          setState(() {
                                            botonanomaliassi = true;
                                            botonanomaliasno = false;
                                          });
                                          _saveAnomaliasSelectionToPrefs(true);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: botonanomaliassi
                                              ? Colors
                                                  .orange // Color cuando está botonado
                                              : Color(0xFFDFDFDF),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          fixedSize: Size.fromHeight(50.0),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .translate('yes')!,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 64, 64, 66),
                                            fontSize: 22,
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'Inter',
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Acción cuando se presiona el botón "Sí"
                                          setState(() {
                                            botonanomaliassi = false;
                                            botonanomaliasno = true;
                                          });
                                          _saveAnomaliasSelectionToPrefs(false);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: botonanomaliasno
                                              ? Colors
                                                  .orange // Color cuando está botonado
                                              : Color(0xFFDFDFDF),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          fixedSize: Size.fromHeight(50.0),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .translate('no')!,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 64, 64, 66),
                                            fontSize: 22,
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'Inter',
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 303,
                            height: 103.02,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('recurrent_fever')!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Acción cuando se presiona el botón "Sí"
                                          setState(() {
                                            botonrecurrentesi = true;
                                            botonrecurrenteno = false;
                                          });
                                          _saveRecurrenteSelectionToPrefs(true);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: botonrecurrentesi
                                              ? Colors
                                                  .orange // Color cuando está botonado
                                              : Color(0xFFDFDFDF),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          fixedSize: Size.fromHeight(50.0),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .translate('yes')!,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 64, 64, 66),
                                            fontSize: 22,
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'Inter',
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Acción cuando se presiona el botón "No"
                                          setState(() {
                                            botonrecurrentesi = false;
                                            botonrecurrenteno = true;
                                          });
                                          _saveRecurrenteSelectionToPrefs(
                                              false);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: botonrecurrenteno
                                              ? Colors
                                                  .orange // Color cuando está botonado
                                              : Color(0xFFDFDFDF),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          fixedSize: Size.fromHeight(50.0),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .translate('no')!,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 64, 64, 66),
                                            fontSize: 22,
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'Inter',
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TeafActionButton(
                  onPressed: () async {
                    if ((botonanomaliasno || botonanomaliassi) &&
                        (botonrecurrenteno || botonrecurrentesi)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Analisis5UI(),
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.translate('please')!,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Color(0xFF262f36),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  label: AppLocalizations.of(context)!.translate('next')!,
                  buttonStyle: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Color(0xFF262f36)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  //para guardar y cargar el estado de la seleccion del boton anomalias
  _saveAnomaliasSelectionToPrefs(bool botonanomaliassi) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('$anomalias-botonanomaliassi', botonanomaliassi);
  }

  _loadAnomaliasSelectionFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedBotonanomalias = prefs.getBool('$anomalias-botonanomaliassi');

    if (savedBotonanomalias != null) {
      setState(() {
        botonanomaliassi = savedBotonanomalias;
        botonanomaliasno = !savedBotonanomalias;
      });
    } else {
      botonanomaliasno = false;
      botonanomaliassi = false;
    }
  }

  //para guardar y cargar el estado de la seleccion del boton recurrente
  _saveRecurrenteSelectionToPrefs(bool botonrecurrentesi) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('$recurrente-botonrecurrentesi', botonrecurrentesi);
  }

  // Para cargar el estado del botón "Recurrente"
  _loadRecurrenteSelectionFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedBotonrecurrente = prefs.getBool('$recurrente-botonrecurrentesi');
    if (savedBotonrecurrente != null) {
      setState(() {
        botonrecurrentesi = savedBotonrecurrente;
        botonrecurrenteno = !savedBotonrecurrente;
      });
    } else {
      botonrecurrentesi = false;
      botonrecurrenteno = false;
    }
  }
}
