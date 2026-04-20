// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaf_app/analisis5_ui.dart';
import 'welcome_ui.dart';
import 'solucion_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_language_provider.dart';
import 'app_localizations.dart';
import 'diagnostico_helper.dart';
import 'package:teaf_app/widgets/teaf_action_button.dart';

class Analisis7UI extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _Analisis6UIState createState() => _Analisis6UIState();
}

class SharedPreferencesHelper {
  //edad
  static Future<String> getEdadText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('edad') ?? '';
  }

//adoptado - si no
  static Future<bool> getAdoptadoButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('preguntaAdoptado-botonSi') ?? false;
  }

//tiempo acogida - mayor menor
  static Future<bool> getTiempoAcogidaButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('preguntaTiempoAcogida-botonmenor') ?? false;
  }

  //dominios - 0 1 2
  static Future<bool> getDominiosButtonState(int buttonNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('preguntaDominios-boton$buttonNumber') ?? false;
  }

  //alcohol - si no
  static Future<bool> getAlcoholButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('preguntaAlcohol-botonSi') ?? false;
  }

  //etnia - cau afro
  static Future<bool> getEtniaButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('preguntaEtnia-botoncau') ?? false;
  }

  //genero - hom muj
  static Future<bool> getGeneroButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('preguntaGenero-botonhom') ?? false;
  }

  //peso
  static Future<String> getPesoText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('preguntaPeso') ?? '';
  }

  //talla
  static Future<String> getTallaText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('preguntaTalla') ?? '';
  }

  //perimetro craneal
  static Future<String> getPerimetroCranealText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('preguntaPerimetroCraneal') ?? '';
  }

  //distancia palpebral
  static Future<String> getDistanciaPalpebralText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('distanciaPalpebral') ?? '';
  }

  //filtrum
  static Future<int> getFiltrum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('imagenseleccionadafiltrum') ?? -1;
  }

  //labio superior
  static Future<int> getLabioSuperior() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('imagenseleccionadalabio') ?? -1;
  }

  //anomalias
  static Future<bool> getAnomalias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('preguntaAnomalías-botonanomaliassi') ?? false;
  }

  //recurrente
  static Future<bool> getRecurrente() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('preguntaRecurrente-botonrecurrentesi') ?? false;
  }

  //malformaciones
  static Future<bool> getMalformaciones() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('preguntaMalformaciones-botonmalformacionessi') ??
        false;
  }

  static Future<void> showResumenDialog(BuildContext context) async {
    String edadText = await getEdadText();
    bool adoptado = await getAdoptadoButtonState();
    bool tiempoAcogida = await getTiempoAcogidaButtonState();
    bool dominiosBoton0 = await getDominiosButtonState(0);
    bool dominiosBoton1 = await getDominiosButtonState(1);
    bool dominiosBoton2 = await getDominiosButtonState(2);
    bool alcohol = await getAlcoholButtonState();
    bool etnia = await getEtniaButtonState();
    bool genero = await getGeneroButtonState();
    String pesoText = await getPesoText();
    String tallaText = await getTallaText();
    String perimetroCranealText = await getPerimetroCranealText();
    String distanciaPalpebralText = await getDistanciaPalpebralText();
    int imagenseleccionadafiltrum = await getFiltrum();
    int imagenseleccionadalabio = await getLabioSuperior();
    bool anomalias = await getAnomalias();
    bool recurrente = await getRecurrente();
    bool malformaciones = await getMalformaciones();

    // Construye el mensaje del popup
    String popupMessage =
        '${AppLocalizations.of(context)!.translate('age')}: $edadText ${AppLocalizations.of(context)!.translate('months')}\n'
        '${AppLocalizations.of(context)!.translate('adopted')}: ${adoptado ? '${AppLocalizations.of(context)!.translate('yes')}' : '${AppLocalizations.of(context)!.translate('no')}'}\n'
        '${AppLocalizations.of(context)!.translate('receptionTime')}: ${tiempoAcogida ? '${AppLocalizations.of(context)!.translate('less24')}' : '${AppLocalizations.of(context)!.translate('more24')}'}\n'
        '${AppLocalizations.of(context)!.translate('domains')}: ${dominiosBoton0 ? '${AppLocalizations.of(context)!.translate('0')}' : ''}${dominiosBoton1 ? '${AppLocalizations.of(context)!.translate('1')}' : ''}${dominiosBoton2 ? '${AppLocalizations.of(context)!.translate('2')}' : ''}\n'
        '${AppLocalizations.of(context)!.translate('alcohol')}: $alcohol\n'
        '${AppLocalizations.of(context)!.translate('ethnicity')}: ${etnia ? '${AppLocalizations.of(context)!.translate('caucasian')}' : '${AppLocalizations.of(context)!.translate('african')}'}\n'
        '${AppLocalizations.of(context)!.translate('gender')}: ${genero ? '${AppLocalizations.of(context)!.translate('male')}' : '${AppLocalizations.of(context)!.translate('female')}'}\n'
        '${AppLocalizations.of(context)!.translate('weight')}: $pesoText kg\n'
        '${AppLocalizations.of(context)!.translate('height')}: $tallaText cm\n'
        '${AppLocalizations.of(context)!.translate('head_circumference')}: $perimetroCranealText cm\n'
        '${AppLocalizations.of(context)!.translate('palpebral_distance')}: $distanciaPalpebralText mm\n'
        '${AppLocalizations.of(context)!.translate('filtrum')}: $imagenseleccionadafiltrum \n'
        '${AppLocalizations.of(context)!.translate('upper_lip')}: $imagenseleccionadalabio \n'
        '${AppLocalizations.of(context)!.translate('cranial_malformations')}: ${anomalias ? '${AppLocalizations.of(context)!.translate('yes')}' : '${AppLocalizations.of(context)!.translate('na')}'}\n'
        '${AppLocalizations.of(context)!.translate('recurrent_fever')}: ${recurrente ? '${AppLocalizations.of(context)!.translate('yes')}' : '${AppLocalizations.of(context)!.translate('na')}'}\n'
        '${AppLocalizations.of(context)!.translate('major_malformations')}: ${malformaciones ? '${AppLocalizations.of(context)!.translate('yes')}' : '${AppLocalizations.of(context)!.translate('no')}'}\n';

    // Muestra el diálogo con el mensaje
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate('summary')!,
          ),
          content: Text(popupMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.translate('edit')!,
                style: TextStyle(
                  color: Color(
                      0xFF262f36), // Aquí puedes cambiar el color del texto
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SolucionUI(),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.translate('continue')!,
                style: TextStyle(
                  color: Color(
                      0xFF262f36), // Aquí puedes cambiar el color del texto
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Analisis6UIState extends State<Analisis7UI> {
  DiagnosticoHelper diagnosticoHelper = DiagnosticoHelper();
  late AppLanguageProvider appLanguage;
  // Variables para manejar el estado de los botones
  final String malformaciones = 'preguntaMalformaciones';
  bool botonmalformacionessi = false;
  bool botonmalformacionesno = false;
  @override
  void initState() {
    super.initState();
    _loadMalformacionesSelectionFromPrefs();
    setState(() {
      botonmalformacionessi = false;
      botonmalformacionesno = false;
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          builder: (context) => Analisis5UI(),
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
                  color: Colors.white,
                  fontSize: 50,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 303,
                        height: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('major_malformations')!,
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
                                        botonmalformacionessi = true;
                                        botonmalformacionesno = false;
                                      });
                                      _saveMalformacionesSelectionToPrefs(true);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: botonmalformacionessi
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
                                        color: Color.fromARGB(255, 64, 64, 66),
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
                                        botonmalformacionessi = false;
                                        botonmalformacionesno = true;
                                      });
                                      _saveMalformacionesSelectionToPrefs(
                                          false);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: botonmalformacionesno
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
                                        color: Color.fromARGB(255, 64, 64, 66),
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
                height: 30,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TeafActionButton(
                  onPressed: () {
                    if ((botonmalformacionessi || botonmalformacionesno)) {
                      SharedPreferencesHelper.showResumenDialog(context);
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
                  textColor: Colors.white,
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
  _saveMalformacionesSelectionToPrefs(bool botonmalformacionessi) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(
        '$malformaciones-botonmalformacionessi', botonmalformacionessi);
  }

  _loadMalformacionesSelectionFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedBotonmalformaciones =
        prefs.getBool('$malformaciones-botonmalformacionessi');

    if (savedBotonmalformaciones != null) {
      setState(() {
        botonmalformacionessi = savedBotonmalformaciones;
        botonmalformacionesno = !savedBotonmalformaciones;
      });
    } else {
      botonmalformacionesno = false;
      botonmalformacionessi = false;
    }
  }
}
