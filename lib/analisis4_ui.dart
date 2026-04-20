import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'diagnostico_helper.dart';
import 'package:teaf_app/analisis3_ui.dart';
import 'package:teaf_app/analisis6_ui.dart';
import 'analisis5_ui.dart';
import 'welcome_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_language_provider.dart';
import 'app_localizations.dart';
import 'package:teaf_app/teaf_field_styles.dart';
import 'package:teaf_app/widgets/teaf_action_button.dart';

class Analisis4UI extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _Analisis4UIState createState() => _Analisis4UIState();
}

class SharedPreferencesHelper {
  //edad
  static Future<String> getEdadText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('edad') ?? '';
  } //genero - hom muj

  static Future<bool> getGeneroButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('preguntaGenero-botonhom') ?? false;
  } //perimetro craneal

  static Future<String> getPerimetroCranealText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('preguntaPerimetroCraneal') ?? '';
  }
}

class _Analisis4UIState extends State<Analisis4UI> {
  late AppLanguageProvider appLanguage;
  final String pesoText = 'preguntaPeso';
  final String tallaText = 'preguntaTalla';
  final String perimetroCranealText = 'preguntaPerimetroCraneal';
  final String distanciaPalpebralText = 'distanciaPalpebral';

  TextEditingController pesoController = TextEditingController();
  TextEditingController tallaController = TextEditingController();
  TextEditingController perimetroCranealController = TextEditingController();
  TextEditingController distanciaPalpebralController = TextEditingController();

  List<String> urls = [
    'https://vimeo.com/766536749', //peso
    'https://vimeo.com/766536770', //talla
    'https://vimeo.com/766536717', //perímetro craneal
    'https://vimeo.com/766536975', //distancia palpebral
  ];

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
    _loadTextFieldsFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Analisis3UI(),
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
                height: 40,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('weight')!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // Mostrar el pop-up al tocar la imagen
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        AppLocalizations.of(context)!
                                            .translate('weight_info')!,
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate(
                                                    'watch_weight_video')!,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _launchURL(urls[
                                                  0]); // Llama a la función para abrir el enlace
                                            },
                                            child: Text(
                                              'https://vimeo.com/766536749',
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255,
                                                    4,
                                                    60,
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
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .translate('close')!),
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
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: kTeafMetricFieldHeight,
                                alignment: Alignment.center,
                                decoration: teafMetricFieldShellDecoration(),
                                child: TextField(
                                  controller: pesoController,
                                  style: teafMetricTextFieldTextStyle(),
                                  decoration: teafMetricTextFieldDecoration('kg'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('height')!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                      // Mostrar el pop-up al tocar la imagen
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              AppLocalizations.of(context)!
                                                  .translate('height_info')!,
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .translate(
                                                          'watch_height_video')!,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _launchURL(urls[
                                                        1]); // Llama a la función para abrir el enlace
                                                  },
                                                  child: Text(
                                                    'https://vimeo.com/766536770',
                                                    style: TextStyle(
                                                      color: const Color
                                                          .fromARGB(255, 4, 60,
                                                          105), // Estilo para que parezca un enlace
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .end, // Esto alineará el botón "Cerrar" a la derecha
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .translate(
                                                                  'close')!),
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
                                        image:
                                            AssetImage('img/pregunta.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: kTeafMetricFieldHeight,
                                alignment: Alignment.center,
                                decoration: teafMetricFieldShellDecoration(),
                                child: TextField(
                                  controller: tallaController,
                                  style: teafMetricTextFieldTextStyle(),
                                  decoration:
                                      teafMetricTextFieldDecoration('cm'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('head_circumference')!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                      // Mostrar el pop-up al tocar la imagen
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              AppLocalizations.of(context)!
                                                  .translate(
                                                      'head_circumference_info')!,
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .translate(
                                                          'measure_head_circumference')!,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _launchURL(urls[
                                                        2]); // Llama a la función para abrir el enlace
                                                  },
                                                  child: Text(
                                                    'https://vimeo.com/766536717',
                                                    style: TextStyle(
                                                      color: const Color
                                                          .fromARGB(255, 4, 60,
                                                          105), // Estilo para que parezca un enlace
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .end, // Esto alineará el botón "Cerrar" a la derecha
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .translate(
                                                                  'close')!),
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
                                        image:
                                            AssetImage('img/pregunta.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: kTeafMetricFieldHeight,
                                alignment: Alignment.center,
                                decoration: teafMetricFieldShellDecoration(),
                                child: TextField(
                                  controller: perimetroCranealController,
                                  style: teafMetricTextFieldTextStyle(),
                                  decoration:
                                      teafMetricTextFieldDecoration('cm'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('palpebral_distance')!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                      // Mostrar el pop-up al tocar la imagen
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              AppLocalizations.of(context)!
                                                  .translate(
                                                      'palpebral_distance_info')!,
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .translate(
                                                          'watch_palpebral_video')!,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _launchURL(urls[
                                                        3]); // Llama a la función para abrir el enlace
                                                  },
                                                  child: Text(
                                                    'https://vimeo.com/766536975',
                                                    style: TextStyle(
                                                      color: const Color
                                                          .fromARGB(255, 4, 60,
                                                          105), // Estilo para que parezca un enlace
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .end, // Esto alineará el botón "Cerrar" a la derecha
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .translate(
                                                                  'close')!),
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
                                        image:
                                            AssetImage('img/pregunta.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: kTeafMetricFieldHeight,
                                alignment: Alignment.center,
                                decoration: teafMetricFieldShellDecoration(),
                                child: TextField(
                                  controller: distanciaPalpebralController,
                                  style: teafMetricTextFieldTextStyle(),
                                  decoration:
                                      teafMetricTextFieldDecoration('mm'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                    String edad = await SharedPreferencesHelper.getEdadText();
                    String generoPaciente =
                        await SharedPreferencesHelper.getGeneroButtonState()
                            ? 'Hombre'
                            : 'Mujer';
                    int? peso = int.tryParse(pesoController.text);
                    int? talla = int.tryParse(tallaController.text);
                    int? percra =
                        int.tryParse(perimetroCranealController.text);

                    int? distpal =
                        int.tryParse(distanciaPalpebralController.text);
                    bool perimetroValido =
                        await diagnosticoHelper.verificarPerimetroCraneal(
                            perimetroCranealController.text,
                            edad,
                            generoPaciente);
                    print(perimetroValido);
                    if (pesoController.text.isNotEmpty &&
                        tallaController.text.isNotEmpty &&
                        perimetroCranealController.text.isNotEmpty &&
                        distanciaPalpebralController.text.isNotEmpty) {
                      if (peso! > 0 &&
                          talla! > 0 &&
                          percra! > 0 &&
                          distpal! > 0) {
                        if (!perimetroValido) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Analisis6UI(),
                            ),
                          );
                          _saveTextFieldsToPrefs();
                        } else {
                          print(tallaController.text);
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Analisis5UI(),
                            ),
                          );
                          _saveTextFieldsToPrefs();
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "Por favor, introduce un valor mayor de 0",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Color(0xFF262f36),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Por favor, rellene todos los campos",
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
    );
  }

  // Guardar datos introducidos en Shared Preferences
  _saveTextFieldsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(pesoText, pesoController.text);
    prefs.setString(tallaText, tallaController.text);
    prefs.setString(perimetroCranealText, perimetroCranealController.text);
    prefs.setString(distanciaPalpebralText, distanciaPalpebralController.text);
  }

  // Cargar datos introducidos desde Shared Preferences
  _loadTextFieldsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pesoController.text = prefs.getString(pesoText) ?? '';
      tallaController.text = prefs.getString(tallaText) ?? '';
      perimetroCranealController.text =
          prefs.getString(perimetroCranealText) ?? '';
      distanciaPalpebralController.text =
          prefs.getString(distanciaPalpebralText) ?? '';
    });
  }
}
