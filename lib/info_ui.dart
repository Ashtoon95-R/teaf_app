import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:teaf_app/inicio_ui.dart';
import 'welcome_ui.dart';
import 'app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:teaf_app/widgets/teaf_action_button.dart';

Future<void> _launchURL(String url) async {
  Uri url0 = Uri.parse(url);
  if (!await launchUrl(url0)) {
    throw 'Could not launch $url0';
  }
}

// ignore: must_be_immutable
class InfoUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dividiendo el texto en partes
    final String part1 = AppLocalizations.of(context)!.translate('introText1')!;
    final String part2 = AppLocalizations.of(context)!.translate('introText2')!;
    final String part3 = AppLocalizations.of(context)!.translate('introText3')!;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 53, 133, 182),
      body: SafeArea(
        child: Stack(
          children: [
            // Logo
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('img/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.translate('appName')!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
            // Título
            Positioned(
              right: 0,
              left: 0,
              top: 100,
              child: Padding(
                padding:
                    EdgeInsets.all(20.0), // Agrega un margen a su alrededor
                child: Text(
                  AppLocalizations.of(context)!.translate('welcome')!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Texto de información dentro de un SingleChildScrollView
            Positioned(
              left: 0,
              right: 0,
              top: 180,
              bottom: 80,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 30,
                  ),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(text: part1),
                            TextSpan(
                              text: part2,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 4, 60, 105),
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _launchURL(
                                      'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4960726/');
                                },
                            ),
                            TextSpan(text: part3),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _launchURL('https://www.sanidad.gob.es/');
                            },
                            child: Image.asset(
                              'img/ministerio.png',
                              width: 150,
                              height: 150,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL('https://www.uc3m.es/');
                            },
                            child: Image.asset(
                              'img/uc3m.png',
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Fila con dos botones centrados y separados
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: LayoutBuilder(
                builder: (context, _) {
                  return Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TeafActionButton(
                            applyScreenWidthConstraint: false,
                            outerHorizontalMargin: 8,
                            innerHorizontalPadding: 18,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WelcomeUI(),
                                ),
                              );
                            },
                            label: AppLocalizations.of(context)!
                                .translate('back')!,
                            buttonStyle: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Color(0xFFDFDFDF)),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            textColor: Color(0xFF262f36),
                            fontSize: 30,
                          ),
                          TeafActionButton(
                            applyScreenWidthConstraint: false,
                            outerHorizontalMargin: 8,
                            innerHorizontalPadding: 18,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InicioUI(),
                                ),
                              );
                            },
                            label: AppLocalizations.of(context)!
                                .translate('next')!,
                            buttonStyle: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Color(0xFFDFDFDF)),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            textColor: Color(0xFF262f36),
                            fontSize: 27,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
