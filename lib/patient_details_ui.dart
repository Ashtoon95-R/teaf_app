import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaf_app/patients_ui.dart';
import 'welcome_ui.dart';
import 'app_localizations.dart';
import 'diagnostico_helper.dart';
import 'package:teaf_app/widgets/teaf_action_button.dart';

class PatientDetailsScreen extends StatelessWidget {
  final String patientName;

  const PatientDetailsScreen({Key? key, required this.patientName})
      : super(key: key);

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
                  // Botón de regreso
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientUI(),
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
                      width: 30.0,
                      height: 30.0,
                    ),
                  ),
                  // Logo y nombre
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
                  // Icono de idiomas
                  InkWell(
                    child: Container(
                      child: diagnosticoHelper.buildLanguageMenu(
                          context), // Llama a la función para construir el menú de idiomas
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                AppLocalizations.of(context)!.translate('details')!,
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
              Expanded(
                child: FutureBuilder<String>(
                  future: _loadPatientDetails(context, patientName),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Center(
                                child: Text(
                                  snapshot.data!,
                                  style: TextStyle(
                                    color: Colors.white, // Color del texto
                                    fontSize: 20, // Tamaño de fuente
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: TeafActionButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        AppLocalizations.of(context)!
                                            .translate('delete')!,
                                      ),
                                      content: Text(
                                        AppLocalizations.of(context)!
                                            .translate('sure')!,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate('cancel')!,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _deletePatient(
                                                context, patientName);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PatientUI(),
                                              ),
                                            );
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
                              label: AppLocalizations.of(context)!
                                  .translate('delete')!,
                              buttonStyle: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Color(0xFF262f36)),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                              textColor: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('error_details')!,
                          style: TextStyle(
                            color: Colors.black, // Color del texto
                            fontSize: 20, // Tamaño de fuente
                            fontWeight: FontWeight.bold, // Negrita
                          ),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _loadPatientDetails(
      BuildContext context, String patientName) async {
    if (!context.mounted) return ''; // Check if the widget is still mounted

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve patient details associated with the name
    String? age = prefs.getString('${patientName}_age');
    bool? gender = prefs.getBool('${patientName}_gender');
    bool? adoptado = prefs.getBool('${patientName}_adoptado');
    bool? tiempoacogida = prefs.getBool('${patientName}_tiempoacogida');
    bool? alcohol = prefs.getBool('${patientName}_alcohol');
    double? peso = prefs.getDouble('${patientName}_peso');
    double? talla = prefs.getDouble('${patientName}_talla');
    double? perimetro = prefs.getDouble('${patientName}_perimetro');
    double? distancia = prefs.getDouble('${patientName}_distancia');
    int? filtrum = prefs.getInt('${patientName}_filtrum');
    int? labio = prefs.getInt('${patientName}_labio');
    int? dominios = prefs.getInt('${patientName}_dominios');
    bool? anomalias = prefs.getBool('${patientName}_anomalias');
    bool? recurrente = prefs.getBool('${patientName}_recurrente');
    // Build a string with the patient details
    return '''
    ${AppLocalizations.of(context)!.translate('name')}: $patientName
    ${AppLocalizations.of(context)!.translate('age')}: $age ${AppLocalizations.of(context)!.translate('months')}
    ${AppLocalizations.of(context)!.translate('gender')}: ${gender != null ? (gender ? AppLocalizations.of(context)!.translate('male') : AppLocalizations.of(context)!.translate('female')) : ''}
    ${AppLocalizations.of(context)!.translate('adopted')}: ${adoptado != null ? (adoptado ? AppLocalizations.of(context)!.translate('yes') : AppLocalizations.of(context)!.translate('no')) : ''}
    ${AppLocalizations.of(context)!.translate('receptionTime')}: ${tiempoacogida != null ? (tiempoacogida ? AppLocalizations.of(context)!.translate('less24') : AppLocalizations.of(context)!.translate('more24')) : ''}
    ${AppLocalizations.of(context)!.translate('alcohol')}: ${alcohol != null ? (alcohol ? AppLocalizations.of(context)!.translate('yes') : AppLocalizations.of(context)!.translate('no')) : ''}
    ${AppLocalizations.of(context)!.translate('weight')}: $peso kg
    ${AppLocalizations.of(context)!.translate('height')}: $talla cm
    ${AppLocalizations.of(context)!.translate('domains')}: $dominios
    ${AppLocalizations.of(context)!.translate('head_circumference')}: $perimetro cm
    ${AppLocalizations.of(context)!.translate('palpebral_distance')}: $distancia mm
    ${AppLocalizations.of(context)!.translate('filtrum')}: $filtrum
    ${AppLocalizations.of(context)!.translate('upper_lip')}: $labio
    ${AppLocalizations.of(context)!.translate('cranial_malformations')}: ${anomalias != null ? (anomalias ? AppLocalizations.of(context)!.translate('yes') : AppLocalizations.of(context)!.translate('na')) : ''}
    ${AppLocalizations.of(context)!.translate('recurrent_fever')}: ${recurrente != null ? (recurrente ? AppLocalizations.of(context)!.translate('yes') : AppLocalizations.of(context)!.translate('na')) : ''}
  ''';
  }

  Future<void> _deletePatient(BuildContext context, String patientName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> patientList = prefs.getStringList('patient_list') ?? [];
    patientList.remove(patientName);
    await prefs.setStringList('patient_list', patientList);
    await prefs.remove('${patientName}_age');
    await prefs.remove('${patientName}_gender');
    await prefs.remove('${patientName}_adoptado');
    await prefs.remove('${patientName}_tiempoacogida');
    await prefs.remove('${patientName}_alcohol');
    await prefs.remove('${patientName}_peso');
    await prefs.remove('${patientName}_talla');
    await prefs.remove('${patientName}_perimetro');
    await prefs.remove('${patientName}_distancia');
    await prefs.remove('${patientName}_filtrum');
    await prefs.remove('${patientName}_labio');
    await prefs.remove('${patientName}_dominios');
    await prefs.remove('${patientName}_anomalias');
    await prefs.remove('${patientName}_recurrente');
    await prefs.remove('${patientName}_malformaciones');

    // Volver a la pantalla anterior después de eliminar al paciente
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}
