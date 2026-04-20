import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inicio_ui.dart';
import 'analisis2_ui.dart';
import 'analisis0_ui.dart';
import 'welcome_ui.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_language_provider.dart';
import 'app_localizations.dart';
import 'diagnostico_helper.dart';
import 'package:teaf_app/teaf_field_styles.dart';
import 'package:teaf_app/widgets/teaf_action_button.dart';

class Analisis1UI extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _Analisis1UIState createState() => _Analisis1UIState();
}

class _Analisis1UIState extends State<Analisis1UI> {
  late AppLanguageProvider appLanguage;

  final String? edadText = 'edad';
  final String adoptado = 'preguntaAdoptado';
  final String tiempoacogida = 'preguntaTiempoAcogida';
  bool botonSi = false;
  bool botonNo = false;
  bool botonmenor = false;
  bool botonmayor = false;
  bool isAdopted = false;
  TextEditingController edadController = TextEditingController();

  DiagnosticoHelper diagnosticoHelper = DiagnosticoHelper();

  @override
  void initState() {
    super.initState();
    appLanguage = AppLanguageProvider();
    _loadAdoptadoSelectionFromPrefs();
    _loadTiempoAcogidaSelectionFromPrefs();
    _loadTextFieldsFromPrefs();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InicioUI(),
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
              SizedBox(height: 50),
              Text(
                AppLocalizations.of(context)!.translate('evaluation')!,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 50,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 303,
                        height: 103.02,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('age')!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            AppLocalizations.of(context)!
                                                .translate('infoAge')!,
                                          ),
                                          content: Text(
                                            AppLocalizations.of(context)!
                                                .translate('infoAgeText')!,
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
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
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Container(
                                  width: 303.0,
                                  height: kTeafMetricFieldHeight,
                                  alignment: Alignment.center,
                                  decoration: teafMetricFieldShellDecoration(),
                                  child: TextField(
                                    controller: edadController,
                                    style: teafMetricTextFieldTextStyle(),
                                    decoration: teafMetricTextFieldDecoration(
                                      AppLocalizations.of(context)!
                                          .translate('months')!,
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: 303,
                        height: 103.02,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('adopted')!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        botonSi = true;
                                        botonNo = false;
                                        isAdopted = true;
                                      });
                                      _saveAdoptadoSelectionToPrefs(true);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: botonSi
                                          ? Colors.orange
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
                                        fontSize: 25,
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
                                      setState(() {
                                        botonSi = false;
                                        botonNo = true;
                                        isAdopted = false;
                                      });
                                      _saveAdoptadoSelectionToPrefs(false);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: botonNo
                                          ? Colors.orange
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
                                        fontSize: 25,
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
                      SizedBox(height: 20),
                      SizedBox(
                        width: 303,
                        height: 103.02,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('receptionTime')!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: isAdopted
                                        ? () {
                                            setState(() {
                                              botonmenor = true;
                                              botonmayor = false;
                                            });
                                            _saveTiempoAcogidaSelectionToPrefs(
                                                true);
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: botonmenor
                                          ? Colors.orange
                                          : Color(0xFFDFDFDF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      fixedSize: Size.fromHeight(50.0),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('less24')!,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 64, 64, 66),
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
                                    onPressed: isAdopted
                                        ? () {
                                            setState(() {
                                              botonmayor = true;
                                              botonmenor = false;
                                            });
                                            _saveTiempoAcogidaSelectionToPrefs(
                                                false);
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: botonmayor
                                          ? Colors.orange
                                          : Color(0xFFDFDFDF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      fixedSize: Size.fromHeight(50.0),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('more24')!,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 64, 64, 66),
                                        fontSize: 16,
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
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: TeafActionButton(
                  onPressed: () {
                    String texto = edadController.text;
                    int? edad = int.tryParse(
                        texto); // Intenta convertir el texto a un entero

                    bool camposCompletos = edadController.text.isNotEmpty &&
                        (botonSi || botonNo);

                    if (botonSi) {
                      camposCompletos =
                          camposCompletos && (botonmayor || botonmenor);
                    }
                    if (edad != null && camposCompletos) {
                      // Si la conversión fue exitosa y se cumplen las condiciones
                      if (edad >= 24) {
                        _saveTextFieldsToPrefs();
                        // Si el tiempo de acogida es menor de 24 meses
                        if (botonmenor == true && botonSi == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Analisis0UI(),
                            ),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Analisis2UI(),
                          ),
                        );
                      } else {
                        // Manejo si la edad es menor que 24
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!
                              .translate('higher')!,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Color(0xFF262f36),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    } else {
                      // Manejo si la conversión falló o no se cumplen las condiciones
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
    );
  }

  // Método para guardar el campo de edad en las preferencias
  _saveTextFieldsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String texto = edadController.text;
    if (texto.isNotEmpty) {
      await prefs.setString(edadText!, texto);
    } else {
      // Manejo si el texto está vacío
      print('El texto de edad está vacío');
    }
  }

// Método para cargar el campo de edad desde las preferencias
  _loadTextFieldsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEdad = prefs.getString(edadText!);
    if (savedEdad != null) {
      setState(() {
        edadController.text = savedEdad;
      });
    } else {
      // Manejo si no se encuentra el valor en las preferencias
      setState(() {
        edadController.text =
            ''; // Asignar un valor por defecto o vaciar el campo
      });
    }
  }

// Método para cargar la selección de 'adoptado' desde las preferencias
  _loadAdoptadoSelectionFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedAdoptadoSelection = prefs.getBool('$adoptado-botonSi');

    setState(() {
      botonSi = savedAdoptadoSelection ?? false;
      botonNo =
          savedAdoptadoSelection != null ? !savedAdoptadoSelection : false;
      isAdopted =
          botonSi; // Actualizar isAdopted basado en la selección guardada
    });
  }

  // Método para guardar la selección de 'adoptado' en las preferencias
  _saveAdoptadoSelectionToPrefs(bool botonSi) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$adoptado-botonSi', botonSi);
  }

  // Método para cargar la selección de 'tiempo de acogida' desde las preferencias
  _loadTiempoAcogidaSelectionFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedTiempoAcogidaSelection =
        prefs.getBool('$tiempoacogida-botonmenor');

    setState(() {
      botonmenor = savedTiempoAcogidaSelection ?? false;
      botonmayor = savedTiempoAcogidaSelection != null
          ? !savedTiempoAcogidaSelection
          : false;
    });
  }

  // Método para guardar la selección de 'tiempo de acogida' en las preferencias
  _saveTiempoAcogidaSelectionToPrefs(bool botonmenor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$tiempoacogida-botonmenor', botonmenor);
  }
}
