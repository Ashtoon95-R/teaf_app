import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaf_app/analisis2_ui.dart';
import 'analisis4_ui.dart';
import 'welcome_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_language_provider.dart';
import 'app_localizations.dart';
import 'diagnostico_helper.dart';
import 'package:teaf_app/widgets/teaf_action_button.dart';

class Analisis3UI extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _Analisis3UIState createState() => _Analisis3UIState();
}

class _Analisis3UIState extends State<Analisis3UI> {
  DiagnosticoHelper diagnosticoHelper = DiagnosticoHelper();
  late AppLanguageProvider appLanguage;
  // Variables para manejar el estado de los botones
  final String etnia = 'preguntaEtnia';
  final String genero = 'preguntaGenero';
  bool botoncau = false;
  bool botonafro = false;
  bool botonhom = false;
  bool botonmuj = false;
  @override
  void initState() {
    super.initState();
    _loadEtniaSelectionFromPrefs();
    _loadGeneroSelectionFromPrefs();
    setState(() {
      botonafro = false;
      botoncau = false;
      botonhom = false;
      botonmuj = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 53, 133, 182),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                          builder: (context) => Analisis2UI(),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 303,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .translate('ethnicity')!,
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
                                          botoncau = true;
                                          botonafro = false;
                                        });
                                        _saveEtniaSelectionToPrefs(true);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: botoncau
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
                                            .translate('caucasian')!,
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 64, 64, 66),
                                          fontSize: 16,
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
                                          botoncau = false;
                                          botonafro = true;
                                        });
                                        _saveEtniaSelectionToPrefs(false);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: botonafro
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
                                            .translate('african')!,
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 64, 64, 66),
                                          fontSize: 13,
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
                                    .translate('gender')!,
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
                                          botonhom = true;
                                          botonmuj = false;
                                        });
                                        _saveGeneroSelectionToPrefs(true);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: botonhom
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
                                            .translate('male')!,
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
                                          botonhom = false;
                                          botonmuj = true;
                                        });
                                        _saveGeneroSelectionToPrefs(false);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: botonmuj
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
                                            .translate('female')!,
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TeafActionButton(
                    onPressed: () {
                      if ((botonafro || botoncau) && (botonhom || botonmuj)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Analisis4UI(),
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!
                              .translate('please')!,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //para guardar y cargar el estado de la seleccion del boton etnia
  _saveEtniaSelectionToPrefs(bool botoncau) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('$etnia-botoncau', botoncau);
  }

  _loadEtniaSelectionFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedBotoncau = prefs.getBool('$etnia-botoncau');

    if (savedBotoncau != null) {
      setState(() {
        botoncau = savedBotoncau;
        botonafro = !savedBotoncau;
      });
    } else {
      botonafro = false;
      botoncau = false;
    }
  }

  //para guardar y cargar el estado de la seleccion del boton genero
  _saveGeneroSelectionToPrefs(bool botonhom) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('$genero-botonhom', botonhom);
  }

  _loadGeneroSelectionFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedBotonhom = prefs.getBool('$genero-botonhom');
    if (savedBotonhom != null) {
      setState(() {
        botonhom = savedBotonhom;
        botonmuj = !savedBotonhom;
      });
    } else {
      botonhom = false;
      botonmuj = false;
    }
  }
}
