import 'package:flutter/material.dart';
import 'package:teaf_app/info_ui.dart';
import 'welcome_ui.dart';
import 'analisis1_ui.dart';
import 'app_language_provider.dart';
import 'app_localizations.dart';
import 'patients_ui.dart';
import 'diagnostico_helper.dart';
import 'package:teaf_app/widgets/teaf_action_button.dart';

// ignore: must_be_immutable
class InicioUI extends StatelessWidget {
  DiagnosticoHelper diagnosticoHelper = DiagnosticoHelper();
  late AppLanguageProvider appLanguage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 53, 133, 182),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
                          builder: (context) => InfoUI(),
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
                height: 80,
              ),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('img/user.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TeafActionButton(
                      matchGroupWidth: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Analisis1UI(),
                          ),
                        );
                      },
                      label: AppLocalizations.of(context)!
                          .translate('startAnalysis')!,
                      buttonStyle: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xFFDFDFDF)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color(0xFF262f36), width: 2.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      textColor: Color(0xFF262f36),
                      fontSize: 25,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TeafActionButton(
                      matchGroupWidth: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientUI(),
                          ),
                        );
                      },
                      label:
                          AppLocalizations.of(context)!.translate('patient')!,
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
                      height: 30,
                    ),
                    TeafActionButton(
                      matchGroupWidth: true,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              content: Container(
                                color: Colors.white,
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('instructions')!,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              insetPadding: EdgeInsets.all(20),
                            );
                          },
                        );
                      },
                      label:
                          AppLocalizations.of(context)!.translate('guide')!,
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
