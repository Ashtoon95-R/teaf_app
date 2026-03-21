import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'diagnostico_helper.dart';
import 'app_localizations.dart';

class PdfGenerator {
  static Future<void> generateAndSharePdf(
      BuildContext context, Future<String> diagnosticoFuture) async {
    String diagnosticoFinal =
        await diagnosticoFuture; // Esperar el resultado del Future
    final pdf = await _generatePdf(context, diagnosticoFinal);
    await _saveAndSharePdf(pdf);
  }

  static Future<pw.Document> _generatePdf(
      BuildContext context, String diagnosticoTexto) async {
    final pdf = pw.Document();
    String diagnosticoDetalles =
        await DiagnosticoHelper.diagnosticoPaciente(context);

    // Retrieve localized strings outside of the pdf package's Context
    final pdfHeader = AppLocalizations.of(context)!.translate('pdf_header')!;
    final pdfDone = AppLocalizations.of(context)!.translate('pdf_done')!;

    pdf.addPage(
      pw.Page(
        build: (pw.Context pdfContext) {
          return pw.Padding(
            padding: pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    pdfHeader,
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue,
                    ),
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Container(
                  padding: pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue200,
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      diagnosticoTexto,
                      style: pw.TextStyle(
                        fontSize: 20,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(height: 50),
                pw.Text(
                  diagnosticoDetalles,
                  style: pw.TextStyle(
                    fontSize: 18,
                    lineSpacing: 2,
                  ),
                ),
                pw.Spacer(), // This pushes the following widget to the bottom
                pw.Divider(),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    pdfDone,
                    style: pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf;
  }

  static Future<void> _saveAndSharePdf(pw.Document pdf) async {
    try {
      final bytes = await pdf.save();
      
      if (!kIsWeb) {
        final output = await getTemporaryDirectory();
        final file = File("${output.path}/diagnostico.pdf");
        await file.writeAsBytes(bytes);
      }
      
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'diagnostico.pdf',
      );
    } catch (e) {
      print("Error saving or sharing PDF: $e");
    }
  }
}