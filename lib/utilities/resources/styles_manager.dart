import 'package:flutter/material.dart';
import 'package:testing/utilities/resources/font_manager.dart';

TextStyle _getTextStyle(
    double fontSize,
    String fontFamily,
    FontWeight fontWeight,
    Color color,
    double letterSpacing,
    double lineHeight) {
  return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: lineHeight);
}
//regular style

TextStyle getRegularStyle(
    {double fontSize = FontSize.s14,
      required Color color,
      double letterSpacing = 0,
      double lineHeight = 0}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily,
      FontWeightManager.regular, color, letterSpacing, lineHeight);
}

// light text style

TextStyle getLightStyle(
    {double fontSize = FontSize.s14,
      required Color color,
      double letterSpacing = 0,
      double lineHeight = 0}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily,
      FontWeightManager.light, color, letterSpacing, lineHeight);
}

// semi bold text style

TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s14,
      required Color color,
      double letterSpacing = 0,
      double lineHeight = 0}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily,
      FontWeightManager.semiBold, color, letterSpacing, lineHeight);
}

// bold text style

TextStyle getBoldStyle(
    {double fontSize = FontSize.s14,
      required Color color,
      double letterSpacing = 0,
      double lineHeight = 0}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily,
      FontWeightManager.bold, color, letterSpacing, lineHeight);
}

// medium text style

TextStyle getMediumStyle(
    {double fontSize = FontSize.s14,
      required Color color,
      double letterSpacing = 0,
      double lineHeight = 0}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily,
      FontWeightManager.medium, color, letterSpacing, lineHeight);
}
