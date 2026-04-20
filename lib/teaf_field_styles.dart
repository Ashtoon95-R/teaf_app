import 'package:flutter/material.dart';

/// Altura mínima cómoda para campos métricos (toque + texto centrado).
const double kTeafMetricFieldHeight = 48.0;

/// Fondo gris redondeado usado en evaluación (peso, talla, etc.).
BoxDecoration teafMetricFieldShellDecoration() {
  return BoxDecoration(
    color: Colors.grey.shade300,
    borderRadius: BorderRadius.circular(24),
  );
}

/// [TextField] sobre fondo gris: sin subrayado Material y con padding interno claro.
InputDecoration teafMetricTextFieldDecoration(String hintText) {
  const none = InputBorder.none;
  return InputDecoration(
    hintText: hintText,
    border: none,
    enabledBorder: none,
    focusedBorder: none,
    errorBorder: none,
    focusedErrorBorder: none,
    disabledBorder: none,
    isDense: true,
    filled: false,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    hintStyle: TextStyle(
      color: Colors.grey.shade600,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );
}

TextStyle teafMetricTextFieldTextStyle() {
  return const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF262f36),
  );
}

/// Campo de texto en diálogos (nombre, etc.).
InputDecoration teafDialogTextFieldDecoration(
  BuildContext context,
  String hintText,
) {
  final outline = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.shade400),
  );
  return InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: Colors.grey.shade50,
    isDense: true,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    border: outline,
    enabledBorder: outline,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
    ),
    errorBorder: outline,
    focusedErrorBorder: outline,
  );
}
