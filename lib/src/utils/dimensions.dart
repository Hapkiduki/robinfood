import 'package:flutter/material.dart';

class Dimensions {
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// se puede utilizar en margin o padding de un widget toma como referencia el ancho de la pantalla
  static fromLTRB(BuildContext context, double left, double top, double right,
      double bottom) {
    return EdgeInsets.fromLTRB(
      width(context) * left,
      width(context) * top,
      width(context) * right,
      width(context) * bottom,
    );
  }

  /// se puede utilizar en margin o padding de un widget toma como referencia el ancho de la pantalla
  static symetric(BuildContext context, double horizontal, double vertical) {
    return EdgeInsets.symmetric(
      vertical: width(context) * vertical,
      horizontal: width(context) * horizontal,
    );
  }

  /// se puede utilizar en margin o padding de un widget toma como referencia el ancho de la pantalla
  static all(BuildContext context, double value) {
    return EdgeInsets.all(
      width(context) * value,
    );
  }

  /// se puede utilizar en margin o padding de un widget toma como referencia el ancho de la pantalla
  static horizontal(BuildContext context, double value) {
    return EdgeInsets.symmetric(
      horizontal: width(context) * value,
    );
  }

  /// se puede utilizar en margin o padding de un widget toma como referencia el ancho de la pantalla
  static vertical(BuildContext context, double value) {
    return EdgeInsets.symmetric(
      vertical: width(context) * value,
    );
  }

  /// se puede utilizar en margin o padding de un widget toma como referencia el ancho de la pantalla
  static top(BuildContext context, double value) {
    return EdgeInsets.only(
      top: width(context) * value,
    );
  }

  /// se puede utilizar en margin o padding de un widget toma como referencia el ancho de la pantalla
  static left(BuildContext context, double value) {
    return EdgeInsets.only(
      left: width(context) * value,
    );
  }

  /// se puede utilizar en margin o padding de un widget toma como referencia el ancho de la pantalla
  static right(BuildContext context, double value) {
    return EdgeInsets.only(
      right: width(context) * value,
    );
  }

  /// se puede utilizar en margin o padding de un widget toma como referencia el ancho de la pantalla
  static bottom(BuildContext context, double value) {
    return EdgeInsets.only(
      bottom: width(context) * value,
    );
  }

  static layoutPadding(BuildContext context) {
    return EdgeInsets.fromLTRB(
        width(context) * .05, width(context) * .05, width(context) * .05, 0);
  }

  static cardRaduis(BuildContext context) {
    return borderRadius(15.0);
  }

  static borderRadius(double radius) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static borderRadiusContainer(double radius) {
    return BorderRadius.all(Radius.circular(radius));
  }
}
