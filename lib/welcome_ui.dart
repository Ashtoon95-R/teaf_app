import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'info_ui.dart';
import 'app_language_provider.dart';
import 'app_localizations.dart';

class WelcomeUI extends StatefulWidget {
  @override
  _WelcomeUIState createState() => _WelcomeUIState();
}

class _WelcomeUIState extends State<WelcomeUI> {
  late AppLanguageProvider appLanguage;

  @override
  Widget build(BuildContext context) {
    appLanguage = Provider.of<AppLanguageProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo de la imagen
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/bck.jpg'),
                  fit: BoxFit.cover, // Para que ocupe toda la pantalla
                ),
              ),
              child: Container(
                color: Color.fromARGB(200, 49, 61,
                    70), // 0x80 establece la opacidad a aproximadamente 50%
              ),
            ),
            // Contenido centrado
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Texto "VisualTEAF" y logo encima del fondo
                  Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('img/logo.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.translate('appName')!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  // Botón
                  Container(
                    width: 310,
                    height: 60,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InfoUI()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xFFDFDFDF)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.translate('welcome')!,
                        style: TextStyle(
                          color: Color(0xFF262f36),
                          fontSize: 30,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  // Idiomas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          appLanguage.changeLanguage(const Locale("es"));
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('img/esp.png'),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                      GestureDetector(
                        onTap: () {
                          appLanguage.changeLanguage(const Locale("en"));
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('img/ing.png'),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
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
    );
  }
}
