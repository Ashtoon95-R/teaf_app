import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaf_app/inicio_ui.dart';
import 'package:teaf_app/patient_details_ui.dart';
import 'package:teaf_app/solucion_ui.dart';
import 'welcome_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'diagnostico_helper.dart';
import 'app_language_provider.dart';
import 'app_localizations.dart';
import 'dialog.dart';
import 'pdfgenerator.dart';
import 'package:teaf_app/widgets/teaf_action_button.dart';

class SharedPreferencesHelper {
  DiagnosticoHelper diagnosticoHelper = DiagnosticoHelper();
  //dominios - 0 1 2
  static Future<bool> getDominiosButtonState(int buttonNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('preguntaDominios-boton$buttonNumber') ?? false;
  }

  static Future<int> dominios() async {
    bool dominiosBoton0 = await getDominiosButtonState(0);
    bool dominiosBoton1 = await getDominiosButtonState(1);
    bool dominiosBoton2 = await getDominiosButtonState(2);
    int dominios = 0;
    if (dominiosBoton0) {
      dominios = 0;
    }
    if (dominiosBoton1) {
      dominios = 1;
    }
    if (dominiosBoton2) {
      dominios = 2;
    }
    return dominios;
  }

  //edad
  static Future<String> getEdadText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('edad') ?? '';
  }

  //genero - hom muj
  static Future<bool> getGeneroButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('preguntaGenero-botonhom') ?? false;
  }

  //alcohol - si no
  static Future<bool> getAlcoholButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('preguntaAlcohol-botonSi') ?? false;
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
}

Future<void> _launchURL(String url) async {
  Uri url0 = Uri.parse(url);
  if (await launchUrl(url0)) {
    await launchUrl(url0);
  } else {
    throw 'Could not launch $url0';
  }
}

// ignore: must_be_immutable
class ResumenUI extends StatelessWidget {
  final String? diagnosticoResult;

  // Constructor que acepta el diagnóstico como parámetro
  ResumenUI({required this.diagnosticoResult});
  late AppLanguageProvider appLanguage;
  Color _getColorRasgos(int? data) {
    if (data == null) {
      return Colors.grey; // Color para cuando no hay datos
    }

    if (data >= 4) {
      return Color(0xFFFFB35B);
    } else {
      return Colors.grey;
    }
  }

  Color _getColorAlcohol(bool? data) {
    if (data == true) {
      return Color(0xFFFFB35B);
    } else {
      return Colors.grey;
    }
  }

  Color _getColorDominios(int? data) {
    if (data == null) {
      return Colors.grey; // Color para cuando no hay datos
    }
    if (data >= 1) {
      return Color(0xFFFFB35B);
    } else {
      return Colors.grey;
    }
  }

  Color _getColorComparacion(double valorpaciente, double? tabla) {
    if (tabla == null) {
      return Colors.grey; // Color cuando no hay valor correspondiente
    }

    if (valorpaciente <= tabla) {
      return Color(0xFFFFB35B);
    } else {
      return Colors.grey;
    }
  }

  Color _getColorDistancia(
      double distanciaGuardada, double? distanciaCorrespondiente) {
    if (distanciaCorrespondiente == null) {
      return Colors.grey; // Color cuando no hay distancia correspondiente
    }

    if (distanciaGuardada <= distanciaCorrespondiente) {
      return Color(0xFFFFB35B);
    } else {
      return Colors.grey;
    }
  }

  Color _getColorPerimetro(bool data) {
    if (data) {
      return Color(
          0xFFFFB35B); // Color cuando el perímetro craneal es menor al de la tabla
    } else {
      return Colors
          .grey; // Color cuando el perímetro craneal es mayor al de la tabla
    }
  }

  @override
  Widget build(BuildContext context) {
    DiagnosticoHelper diagnosticoHelper = DiagnosticoHelper();
    Future<String> diagnosticoPdf = diagnosticoHelper.diagnostico(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 53, 133, 182),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(children: [
            // Encabezado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SolucionUI(),
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
                            AppLocalizations.of(context)!.translate('appName')!,
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
              AppLocalizations.of(context)!.translate('summary')!,
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
            TeafActionButton(
              singleLine: false,
              onPressed: () {
                _launchURL('https://cursoteaf.com/');
              },
              label: diagnosticoResult ??
                  AppLocalizations.of(context)!
                      .translate('diagnosis_not_available')!,
              buttonStyle: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Color.fromARGB(255, 182, 223, 255)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFF262f36), width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              textColor: Colors.black,
              fontSize: 25,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate('explanation')!,
                      style: TextStyle(
                        color: const Color.fromARGB(186, 255, 255, 255),
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 310,
                      height: 74,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 145,
                            height: 74,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0, // Ajusta la posición según necesites
                                  child: FutureBuilder<List<String>>(
                                    future: Future.wait([
                                      SharedPreferencesHelper.getEdadText(),
                                      SharedPreferencesHelper
                                              .getGeneroButtonState()
                                          .then((genero) =>
                                              genero ? "male" : "female"),
                                      SharedPreferencesHelper.getTallaText(),
                                    ]),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        String edad = snapshot.data![0];
                                        String genero = snapshot.data![1];
                                        String tallaGuardada =
                                            snapshot.data![2];

                                        return FutureBuilder<double?>(
                                          future: diagnosticoHelper
                                              .obtenerTallaCorrespondiente(
                                                  edad, genero),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              double? tallaCorrespondiente =
                                                  snapshot.data;

                                              double tallaGuardadaValue =
                                                  double.tryParse(
                                                          tallaGuardada) ??
                                                      0;

                                              Color tallaColor =
                                                  _getColorComparacion(
                                                      tallaGuardadaValue,
                                                      tallaCorrespondiente);

                                              return Container(
                                                width: 145,
                                                height: 74,
                                                decoration: ShapeDecoration(
                                                  color: tallaColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Positioned(
                                  left: 90,
                                  top: 25,
                                  child: Image.asset(
                                    'img/altura.png',
                                    fit: BoxFit.cover,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                                Positioned(
                                  left: 13,
                                  top: 10,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('height')!,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Font Awesome 5 Free',
                                      fontWeight: FontWeight.w900,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 19,
                                  top: 40,
                                  child: FutureBuilder<String>(
                                    future:
                                        SharedPreferencesHelper.getTallaText(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          AppLocalizations.of(context)!
                                              .translate('error')!,
                                        );
                                      } else {
                                        return Text(
                                          '${snapshot.data ?? 'N/A'} cm',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Font Awesome 5 Free',
                                            fontWeight: FontWeight.w900,
                                            height: 0,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 165,
                            top: 0,
                            child: SizedBox(
                              width: 145,
                              height: 74,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: FutureBuilder<List<String>>(
                                      future: Future.wait([
                                        SharedPreferencesHelper.getEdadText(),
                                        SharedPreferencesHelper
                                                .getGeneroButtonState()
                                            .then((genero) =>
                                                genero ? "male" : "female"),
                                        SharedPreferencesHelper.getPesoText(),
                                      ]),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          String edad = snapshot.data![0];
                                          String genero = snapshot.data![1];
                                          String pesoPaciente =
                                              snapshot.data![2];

                                          return FutureBuilder<double?>(
                                            future: diagnosticoHelper
                                                .obtenerPesoCorrespondiente(
                                                    edad, genero),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else {
                                                double? pesoTabla =
                                                    snapshot.data;

                                                double pesoPacienteValue =
                                                    double.tryParse(
                                                            pesoPaciente) ??
                                                        0;

                                                Color pesoColor =
                                                    _getColorComparacion(
                                                        pesoPacienteValue,
                                                        pesoTabla);

                                                return Container(
                                                  width: 145,
                                                  height: 74,
                                                  decoration: ShapeDecoration(
                                                    color: pesoColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 17,
                                    top: 37,
                                    child: FutureBuilder<String>(
                                      future:
                                          SharedPreferencesHelper.getPesoText(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            AppLocalizations.of(context)!
                                                .translate('error')!,
                                          );
                                        } else {
                                          return Text(
                                            '${snapshot.data ?? 'N/A'} kg',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: 'Font Awesome 5 Free',
                                              fontWeight: FontWeight.w900,
                                              height: 0,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 90,
                                    top: 14,
                                    child: Image.asset(
                                      'img/peso.png',
                                      fit: BoxFit.cover,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Positioned(
                                    left: 13,
                                    top: 10,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('weight')!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Font Awesome 5 Free',
                                        fontWeight: FontWeight.w900,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 310,
                      height: 74,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 145,
                            height: 74,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: FutureBuilder<String>(
                                    future: SharedPreferencesHelper
                                        .getDistanciaPalpebralText(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        Future<String> edad =
                                            SharedPreferencesHelper
                                                .getEdadText();
                                        String distanciaPalpebralGuardada =
                                            snapshot.data!;

                                        return FutureBuilder<String>(
                                          future: edad,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              String edadValue = snapshot.data!;

                                              return FutureBuilder<double?>(
                                                future: diagnosticoHelper
                                                    .obtenerDistanciaPalpebralCorrespondiente(
                                                        edadValue),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return CircularProgressIndicator();
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                        'Error: ${snapshot.error}');
                                                  } else {
                                                    double?
                                                        distanciaCorrespondiente =
                                                        snapshot.data;
                                                    double distanciaGuardada =
                                                        double.tryParse(
                                                                distanciaPalpebralGuardada) ??
                                                            0;

                                                    // Comparar las distancias y obtener el color correspondiente
                                                    Color containerColor =
                                                        _getColorDistancia(
                                                            distanciaGuardada,
                                                            distanciaCorrespondiente);

                                                    return Container(
                                                      width: 145,
                                                      height: 74,
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: containerColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Positioned(
                                  left: 17,
                                  top: 37,
                                  child: FutureBuilder<String>(
                                    future: SharedPreferencesHelper
                                        .getDistanciaPalpebralText(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error');
                                      } else {
                                        return Text(
                                          '${snapshot.data ?? 'N/A'} mm',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Font Awesome 5 Free',
                                            fontWeight: FontWeight.w900,
                                            height: 0,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Positioned(
                                  left: 90,
                                  top: 25,
                                  child: Image.asset(
                                    'img/distancia.png',
                                    fit: BoxFit.cover,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                                Positioned(
                                  left: 13,
                                  top: 10,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('palpebral_distance')!,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Font Awesome 5 Free',
                                      fontWeight: FontWeight.w900,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 165,
                            top: 0,
                            child: SizedBox(
                              width: 145,
                              height: 74,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: FutureBuilder<bool>(
                                      future: SharedPreferencesHelper
                                          .getAlcoholButtonState(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            'Error: ${snapshot.error}',
                                          );
                                        } else {
                                          // Llamamos a la función _getColorRasgos con el dato
                                          Color containerColor =
                                              _getColorAlcohol(snapshot.data);

                                          return Container(
                                            width: 145,
                                            height: 74,
                                            decoration: ShapeDecoration(
                                              color: containerColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 17,
                                    top: 37,
                                    child: FutureBuilder<bool>(
                                      future: SharedPreferencesHelper
                                          .getAlcoholButtonState(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text('Error');
                                        } else if (snapshot.hasData) {
                                          // Asegurar que snapshot.data es un bool antes de usarlo
                                          bool estado = snapshot.data!;
                                          String respuesta = estado
                                              ? AppLocalizations.of(context)!
                                                  .translate('yes')!
                                              : AppLocalizations.of(context)!
                                                  .translate('no')!;
                                          return Text(
                                            respuesta,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: 'Font Awesome 5 Free',
                                              fontWeight: FontWeight.w900,
                                              height: 0,
                                            ),
                                          );
                                        } else {
                                          return Text('N/A');
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 90,
                                    top: 14,
                                    child: Image.asset(
                                      'img/alcohol.png',
                                      fit: BoxFit.cover,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Positioned(
                                    left: 13,
                                    top: 10,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('alcohol')!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Font Awesome 5 Free',
                                        fontWeight: FontWeight.w900,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 310,
                      height: 74,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 145,
                            height: 74,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: FutureBuilder<int>(
                                    future:
                                        SharedPreferencesHelper.getFiltrum(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          'Error: ${snapshot.error}',
                                        );
                                      } else {
                                        // Llamamos a la función _getColorRasgos con el dato
                                        Color containerColor =
                                            _getColorRasgos(snapshot.data);

                                        return Container(
                                          width: 145,
                                          height: 74,
                                          decoration: ShapeDecoration(
                                            color: containerColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Positioned(
                                  left: 90,
                                  top: 14,
                                  child: Image.asset(
                                    'img/filtrum.png',
                                    fit: BoxFit.cover,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                                Positioned(
                                  left: 13,
                                  top: 10,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('filtrum')!,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Font Awesome 5 Free',
                                      fontWeight: FontWeight.w900,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 19,
                                  top: 40,
                                  child: FutureBuilder<int>(
                                    future:
                                        SharedPreferencesHelper.getFiltrum(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error');
                                      } else {
                                        return Text(
                                          '${snapshot.data ?? 'N/A'}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Font Awesome 5 Free',
                                            fontWeight: FontWeight.w900,
                                            height: 0,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 165,
                            top: 0,
                            child: SizedBox(
                              width: 145,
                              height: 74,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: FutureBuilder<int>(
                                      future: SharedPreferencesHelper
                                          .getLabioSuperior(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            'Error: ${snapshot.error}',
                                          );
                                        } else {
                                          // Llamamos a la función _getColorRasgos con el dato
                                          Color containerColor =
                                              _getColorRasgos(snapshot.data);

                                          return Container(
                                            width: 145,
                                            height: 74,
                                            decoration: ShapeDecoration(
                                              color: containerColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 17,
                                    top: 37,
                                    child: FutureBuilder<int>(
                                      future: SharedPreferencesHelper
                                          .getLabioSuperior(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            AppLocalizations.of(context)!
                                                .translate('error')!,
                                          );
                                        } else {
                                          return Text(
                                            '${snapshot.data ?? 'N/A'}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: 'Font Awesome 5 Free',
                                              fontWeight: FontWeight.w900,
                                              height: 0,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 90,
                                    top: 14,
                                    child: Image.asset(
                                      'img/labio.png',
                                      fit: BoxFit.cover,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Positioned(
                                    left: 13,
                                    top: 10,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('upper_lip')!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Font Awesome 5 Free',
                                        fontWeight: FontWeight.w900,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 310,
                      height: 74,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: SizedBox(
                              width: 145,
                              height: 74,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: FutureBuilder<int>(
                                      future:
                                          SharedPreferencesHelper.dominios(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            'Error: ${snapshot.error}',
                                          );
                                        } else {
                                          // Llamamos a la función _getColorRasgos con el dato
                                          Color containerColor =
                                              _getColorDominios(snapshot.data);

                                          return Container(
                                            width: 145,
                                            height: 74,
                                            decoration: ShapeDecoration(
                                              color: containerColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 90,
                                    top: 25,
                                    child: Image.asset(
                                      'img/cerebro.png',
                                      fit: BoxFit.cover,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Positioned(
                                    left: 13,
                                    top: 10,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('neurobehavioral')!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Font Awesome 5 Free',
                                        fontWeight: FontWeight.w900,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 19,
                                    top: 40,
                                    child: FutureBuilder<int>(
                                      future:
                                          SharedPreferencesHelper.dominios(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            AppLocalizations.of(context)!
                                                .translate('error')!,
                                          );
                                        } else {
                                          return Text(
                                            '${snapshot.data ?? 'N/A'}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: 'Font Awesome 5 Free',
                                              fontWeight: FontWeight.w900,
                                              height: 0,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 165,
                            top: 0,
                            child: SizedBox(
                              width: 145,
                              height: 74,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: FutureBuilder<String>(
                                      future: SharedPreferencesHelper
                                          .getPerimetroCranealText(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            'Error: ${snapshot.error}',
                                          );
                                        } else {
                                          Future<String> edad =
                                              SharedPreferencesHelper
                                                  .getEdadText();
                                          Future<String> perimetro =
                                              SharedPreferencesHelper
                                                  .getPerimetroCranealText();
                                          Future<bool> genero =
                                              SharedPreferencesHelper
                                                  .getGeneroButtonState();

                                          return FutureBuilder<List<dynamic>>(
                                            future: Future.wait(
                                                [edad, perimetro, genero]),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                  'Error: ${snapshot.error}',
                                                );
                                              } else {
                                                String edadValue =
                                                    snapshot.data![0];
                                                String perimetroValue =
                                                    snapshot.data![1];
                                                bool generoValue =
                                                    snapshot.data![2];
                                                String gender = generoValue
                                                    ? "male"
                                                    : "female";

                                                return FutureBuilder<bool>(
                                                  future: diagnosticoHelper
                                                      .verificarPerimetroCraneal(
                                                          perimetroValue,
                                                          edadValue,
                                                          gender),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return CircularProgressIndicator();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                        'Error: ${snapshot.error}',
                                                      );
                                                    } else {
                                                      bool perimetroValido =
                                                          snapshot.data!;
                                                      Color containerColor =
                                                          _getColorPerimetro(
                                                              perimetroValido);

                                                      return Container(
                                                        width: 145,
                                                        height: 74,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: containerColor,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                );
                                              }
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 17,
                                    top: 37,
                                    child: FutureBuilder<String>(
                                      future: SharedPreferencesHelper
                                          .getPerimetroCranealText(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            AppLocalizations.of(context)!
                                                .translate('error')!,
                                          );
                                        } else {
                                          return Text(
                                            '${snapshot.data ?? 'N/A'} cm',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: 'Font Awesome 5 Free',
                                              fontWeight: FontWeight.w900,
                                              height: 0,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 90,
                                    top: 25,
                                    child: Image.asset(
                                      'img/perimetro.png',
                                      fit: BoxFit.cover,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Positioned(
                                    left: 13,
                                    top: 10,
                                    child: Text(
                                      AppLocalizations.of(context)!.translate(
                                          'head_circumference_short')!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Font Awesome 5 Free',
                                        fontWeight: FontWeight.w900,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MyDialog();
                      },
                    ).then((value) {
                      // El cuadro de diálogo ha sido cerrado, puedes manejar el valor devuelto aquí
                      if (value != null) {
                        // Aquí puedes hacer algo con el valor devuelto, como guardarlo en algún lugar
                        print('El nombre introducido es: $value');
                        // Navegar a la página PatientDetails
                        diagnosticoHelper.savePatient(context, value, diagnosticoResult!);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                PatientDetailsScreen(patientName: value),
                          ),
                        );
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 74,
                        height: 74,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 176, 176, 176),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: Image.asset(
                          'img/save.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                GestureDetector(
                  onTap: () async {
                    PdfGenerator.generateAndSharePdf(context, diagnosticoPdf);
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 74,
                        height: 74,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 176, 176, 176),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: Image.asset(
                          'img/descargar.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                GestureDetector(
                  onTap: () async {
                    DiagnosticoHelper.resetPreferences(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InicioUI(),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 74,
                        height: 74,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 176, 176, 176),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: Image.asset(
                          'img/papelera.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
