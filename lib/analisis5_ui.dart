// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaf_app/analisis7_ui.dart';
import 'analisis4_ui.dart';
import 'solucion_ui.dart';
import 'welcome_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'diagnostico_helper.dart';
import 'app_language_provider.dart';
import 'app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'image_popup.dart';
import 'package:teaf_app/widgets/teaf_action_button.dart';

class Analisis5UI extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _Analisis5UIState createState() => _Analisis5UIState();
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
  } //labio superior

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
    // Construye el mensaje del popup
    String popupMessage =
        '${AppLocalizations.of(context)!.translate('age')}: $edadText ${AppLocalizations.of(context)!.translate('months')}\n'
        '${AppLocalizations.of(context)!.translate('adopted')}: ${adoptado ? '${AppLocalizations.of(context)!.translate('yes')}' : '${AppLocalizations.of(context)!.translate('no')}'}\n'
        '${AppLocalizations.of(context)!.translate('receptionTime')}: ${tiempoAcogida ? '${AppLocalizations.of(context)!.translate('less24')}' : '${AppLocalizations.of(context)!.translate('more24')}'}\n'
        '${AppLocalizations.of(context)!.translate('domains')}: ${dominiosBoton0 ? '${AppLocalizations.of(context)!.translate('0')}' : ''}${dominiosBoton1 ? '${AppLocalizations.of(context)!.translate('1')}' : ''}${dominiosBoton2 ? '${AppLocalizations.of(context)!.translate('2')}' : ''}\n'
        '${AppLocalizations.of(context)!.translate('alcohol')}: ${alcohol ? '${AppLocalizations.of(context)!.translate('yes')}' : '${AppLocalizations.of(context)!.translate('no')}'}\n'
        '${AppLocalizations.of(context)!.translate('ethnicity')}: ${etnia ? '${AppLocalizations.of(context)!.translate('caucasian')}' : '${AppLocalizations.of(context)!.translate('african')}'}\n'
        '${AppLocalizations.of(context)!.translate('gender')}: ${genero ? '${AppLocalizations.of(context)!.translate('male')}' : '${AppLocalizations.of(context)!.translate('female')}'}\n'
        '${AppLocalizations.of(context)!.translate('weight')}: $pesoText kg\n'
        '${AppLocalizations.of(context)!.translate('height')}: $tallaText cm\n'
        '${AppLocalizations.of(context)!.translate('head_circumference')}: $perimetroCranealText cm\n'
        '${AppLocalizations.of(context)!.translate('palpebral_distance')}: $distanciaPalpebralText mm\n'
        '${AppLocalizations.of(context)!.translate('filtrum')}: $imagenseleccionadafiltrum \n'
        '${AppLocalizations.of(context)!.translate('upper_lip')}: $imagenseleccionadalabio \n'
        '${AppLocalizations.of(context)!.translate('cranial_malformations')}: ${anomalias ? '${AppLocalizations.of(context)!.translate('yes')}' : '${AppLocalizations.of(context)!.translate('na')}'}\n'
        '${AppLocalizations.of(context)!.translate('recurrent_fever')}: ${recurrente ? '${AppLocalizations.of(context)!.translate('yes')}' : '${AppLocalizations.of(context)!.translate('na')}'}\n';

    // Muestra el diálogo con el mensaje
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
              ),
            ),
          ],
        );
      },
    );
  }
}

Future<void> _launchURL(String url) async {
  Uri url0 = Uri.parse(url);
  if (await launchUrl(url0)) {
    await launchUrl(url0);
  } else {
    throw 'Could not launch $url0';
  }
}

class _Analisis5UIState extends State<Analisis5UI> {
  late AppLanguageProvider appLanguage;
  DiagnosticoHelper diagnosticoHelper = DiagnosticoHelper();
  late SharedPreferences prefs;
  late bool isCaucasian = true;
  List<String> filtrumImages = []; // Inicializa directamente
  List<String> labioSuperiorImages = []; // Inicializa directamente
  int imagenseleccionadafiltrum =
      -1; // Índice de la imagen seleccionada en la columna 1
  int imagenseleccionadalabio =
      -1; // Índice de la imagen seleccionada en la columna 2
  @override
  void initState() {
    super.initState();
    initPreferences();
  }

  Future<void> initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    isCaucasian = await SharedPreferencesHelper
        .getEtniaButtonState(); // Obtiene el valor de etnia
    filtrumImages = isCaucasian
        ? ['fc5', 'fc4', 'fc3', 'fc2', 'fc1'] // Imágenes para caucásicos
        : ['fa5', 'fa4', 'fa3', 'fa2', 'fa1']; // Imágenes para afroamericanos
    labioSuperiorImages = isCaucasian
        ? ['lc5', 'lc4', 'lc3', 'lc2', 'lc1'] // Imágenes para caucásicos
        : ['la5', 'la4', 'la3', 'la2', 'la1']; // Imágenes para afroamericanos
    setState(() {
      imagenseleccionadafiltrum =
          prefs.getInt('imagenseleccionadafiltrum') ?? -1;
      imagenseleccionadalabio = prefs.getInt('imagenseleccionadalabio') ?? -1;
    });
  }

  void savePreferences() {
    prefs.setInt('imagenseleccionadafiltrum', imagenseleccionadafiltrum);
    prefs.setInt('imagenseleccionadalabio', imagenseleccionadalabio);
  }

  @override
  Widget build(BuildContext context) {
    DiagnosticoHelper diagnosticoHelper = DiagnosticoHelper();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 60, 152, 209),
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
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ImagePopup(imagePath: 'img/faciales.png');
                    },
                  );
                },
                child: Image.asset(
                  'img/creditos.png',
                  width: 400,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              ///cuerpo
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('filtrum')!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: List.generate(
                                    5,
                                    (index) {
                                      final reversedIndex = 5 - index;
                                      final imageName = isCaucasian
                                          ? filtrumImages[index]
                                          : filtrumImages[index];
                                      final isSelected =
                                          imagenseleccionadafiltrum ==
                                              reversedIndex;

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            imagenseleccionadafiltrum =
                                                isSelected ? -1 : reversedIndex;
                                          });
                                          savePreferences();
                                        },
                                        child: Container(
                                          height: 80,
                                          width: 120,
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'img/$imageName.png'),
                                              fit: BoxFit.cover,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.orange
                                                  : Colors.transparent,
                                              width: 5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 50),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('upper_lip')!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: List.generate(
                                    5,
                                    (index) {
                                      final reversedIndex = 5 - index;
                                      final imageName = isCaucasian
                                          ? labioSuperiorImages[
                                              index] // Aquí debes usar labioSuperiorImages
                                          : labioSuperiorImages[
                                              index]; // También aquí

                                      final isSelected =
                                          imagenseleccionadalabio ==
                                              reversedIndex;

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            imagenseleccionadalabio =
                                                isSelected ? -1 : reversedIndex;
                                          });
                                          savePreferences();
                                        },
                                        child: Container(
                                          height: 80,
                                          width: 120,
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'img/$imageName.png'),
                                              fit: BoxFit.cover,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.orange
                                                  : Colors.transparent,
                                              width: 5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchURL('https://fasdpn.org/');
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                                10), // Espacio alrededor de la imagen
                            decoration: BoxDecoration(
                              color: Color.fromARGB(136, 204, 204, 204), // Fondo de color (puedes cambiarlo)
                              borderRadius: BorderRadius.circular(
                                  10), // Esquinas redondeadas
                              border: Border.all(
                                  color: Colors.black,
                                  width: 2), // Borde blanco (puedes cambiarlo)
                            ),
                            child: Image.asset(
                              'img/creditos2.png',
                              width: 350,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomCenter,
                child: TeafActionButton(
                  onPressed: () async {
                    if (imagenseleccionadafiltrum != -1 &&
                        imagenseleccionadalabio != -1) {
                      Map<String, int> resultados =
                          await diagnosticoHelper.rasgosYDominios();
                      int? rasgos = resultados['rasgos'];
                      print('rasgos: $rasgos');
                      int? dominios = resultados['dominios'];
                      print('dominios: $dominios');
                      if ((rasgos! >= 2 && dominios == 0) ||
                          (rasgos < 2 && dominios! < 2)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Analisis7UI(),
                          ),
                        );
                      } else {
                        SharedPreferencesHelper.showResumenDialog(context);
                      }
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
    );
  }
}
