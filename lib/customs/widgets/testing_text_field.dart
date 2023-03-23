import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:testing/utilities/currency_input_formatter.dart';
import 'package:testing/utilities/resources/color_manager.dart';
import 'package:testing/utilities/resources/styles_manager.dart';

class TestingTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maximumCount;
  final Widget trailing,leading;
  final bool isPass,

      isLeading,
      isEnabled,
      isMoneyFormat,
      isBtn,
      isWord,
      isDigit,
      isShowCount;
  final Color? color;
  final TextInputType textInputType;
  final ValidationBuilder validationBuilder;

  const TestingTextField(
      {Key? key,
        this.isMoneyFormat = false,
        required this.controller,
        required this.hint,
        this.isBtn = false,
        this.isDigit = false,
        this.isWord = false,
        this.isPass = false,
        this.isLeading = false,
        this.isShowCount = false,
        this.maximumCount = 50,
        this.isEnabled = true,
        this.trailing = const SizedBox(),
        this.leading = const SizedBox(),
        this.color,
        required this.validationBuilder,
        this.textInputType = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isBtn,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1,
            ),
            child: TextFormField(
              controller: controller,
              obscureText: isPass,
              enabled: isEnabled,
              maxLength: maximumCount,
              style: getRegularStyle(color: isEnabled
                  ?  ColorManager.black
                  : ColorManager.grey),
              keyboardType: textInputType,
              validator: validationBuilder.build(),

              inputFormatters: isMoneyFormat
                  ? [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter()
              ]
                  : isDigit
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : isWord
                  ? [
                FilteringTextInputFormatter.allow(
                    RegExp('[A-Z a-z]'))
              ]
                  : [],
              decoration: InputDecoration(
                suffixIcon: trailing,
                prefixIcon: isLeading ? leading : null,
                filled: true,
                counterText: "",
                fillColor: ColorManager.white,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                hintText: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
