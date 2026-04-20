import 'package:flutter/material.dart';
import 'package:teaf_app/analisis1_ui.dart';
import 'package:teaf_app/analisis2_ui.dart';
import 'package:teaf_app/inicio_ui.dart';
import 'welcome_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_localizations.dart';
import 'diagnostico_helper.dart';
import 'package:teaf_app/widgets/teaf_action_button.dart';

class Analisis0UI extends StatefulWidget {
  @override
  _Analisis0UIState createState() => _Analisis0UIState();
}

class _Analisis0UIState extends State<Analisis0UI> {
  bool? respuesta; // null, true (Sí), false (No)
  DiagnosticoHelper diagnosticoHelper = DiagnosticoHelper();

  void mostrarMensajeNoEvaluable(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate('notEvaluableTitle')!,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.translate('notEvaluableMessage')!,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InicioUI(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                AppLocalizations.of(context)!.translate('accept')!,
                style: TextStyle(
                  color: Color(0xFF262f36),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
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
                          builder: (context) => Analisis1UI(),
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
                  color: Colors.white,
                  fontSize: 50,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Expanded(
                child: SingleChildScrollView(
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
                                  .translate('question0')!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        respuesta = true; // "Sí"
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: respuesta == true
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
                                        fontSize: 22,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        respuesta = false; // "No"
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: respuesta == false
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
                                        fontSize: 22,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Inter',
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomCenter,
                child: TeafActionButton(
                  onPressed: () {
                    if (respuesta == null) {
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
                    } else if (respuesta == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Analisis2UI(),
                        ),
                      );
                    } else {
                      mostrarMensajeNoEvaluable(context);
                    }
                  },
                  label: AppLocalizations.of(context)!.translate('next')!,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF262f36),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
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
}
