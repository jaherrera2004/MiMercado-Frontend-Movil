import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget para títulos de páginas reutilizable
class PageTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? padding;

  const PageTitle({
    super.key,
    required this.title,
    this.fontSize = 32,
    this.fontWeight = FontWeight.bold,
    this.color,
    this.textAlign = TextAlign.center,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget titleWidget = Text(
      title,
      textAlign: textAlign,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Theme.of(context).textTheme.headlineLarge?.color ?? Colors.black,
      ),
    );

    return padding != null
        ? Padding(
            padding: padding!,
            child: titleWidget,
          )
        : titleWidget;
  }
}