import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Botón con etiqueta en una sola línea; ancho intrínseco y tope al ancho de pantalla.
class TeafActionButton extends StatelessWidget {
  const TeafActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.buttonStyle,
    required this.textColor,
    required this.fontSize,
    this.fontWeight = FontWeight.w600,
    this.fontStyle,
    this.height = 60.0,
    this.outerHorizontalMargin = 10.0,
    this.innerHorizontalPadding = 22.0,
    this.applyScreenWidthConstraint = true,
    this.singleLine = true,
    this.matchGroupWidth = false,
  });

  final VoidCallback onPressed;
  final String label;
  final ButtonStyle buttonStyle;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle? fontStyle;
  final double height;
  final double outerHorizontalMargin;
  final double innerHorizontalPadding;
  final bool applyScreenWidthConstraint;
  final bool singleLine;
  /// Si es true, el botón se expande al ancho del padre (p. ej. [IntrinsicWidth] + [Column.stretch]).
  final bool matchGroupWidth;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.inter(
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );

    final mergedStyle = buttonStyle.merge(
      ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: innerHorizontalPadding,
            vertical: singleLine ? 10 : 14,
          ),
        ),
      ),
    );

    final text = Text(
      label,
      maxLines: singleLine ? 1 : null,
      softWrap: !singleLine,
      textAlign: singleLine
          ? (matchGroupWidth ? TextAlign.center : TextAlign.start)
          : TextAlign.center,
      style: textStyle,
    );

    final button = singleLine
        ? SizedBox(
            height: height,
            child: ElevatedButton(
              onPressed: onPressed,
              style: mergedStyle,
              child: text,
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: mergedStyle,
            child: text,
          );

    Widget core = button;
    if (applyScreenWidthConstraint) {
      final maxW =
          MediaQuery.sizeOf(context).width - outerHorizontalMargin * 2;
      core = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: button,
      );
    }

    if (matchGroupWidth) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: outerHorizontalMargin),
        child: SizedBox(
          width: double.infinity,
          child: core,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: outerHorizontalMargin),
      child: Align(
        alignment: Alignment.center,
        child: core,
      ),
    );
  }
}
