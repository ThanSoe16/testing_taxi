import 'package:flutter/material.dart';
import 'package:testing/customs/widgets/testing_text.dart';
import 'package:testing/utilities/resources/color_manager.dart';
import 'package:testing/utilities/resources/font_manager.dart';
import 'package:testing/utilities/resources/styles_manager.dart';
import 'package:testing/utilities/resources/value_manager.dart';

class TestingBtn extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool isDisable;
  final Color color, textColor;
  final double radius;
  final double height;

  const TestingBtn(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.textColor = Colors.white,
      this.radius = 10,
      this.height = 55,
        this.isDisable = false,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: ColorManager.primaryOpacity70.withOpacity(0.5),
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      colorBrightness: Brightness.light,
      onPressed: isDisable ? null : onPressed,
      minWidth: 500,
      height: height,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color, width: isDisable ? 1 : 0),
        borderRadius: BorderRadius.circular(radius),
      ),
      color:  color,
      child:  TestingText(text,
          style: getBoldStyle(
              color: isDisable ? ColorManager.primaryOpacity70 : textColor == Colors.white
                  ? color == Colors.white ? Colors.black
                  : Colors.white
                  : textColor,
              fontSize: FontSize.s16)),
    );
  }
}
