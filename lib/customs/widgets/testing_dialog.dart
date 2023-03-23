
import 'package:flutter/material.dart';
import 'package:testing/customs/widgets/testing_text.dart';
import 'package:testing/utilities/constants.dart';
import 'package:testing/utilities/resources/color_manager.dart';
import 'package:testing/utilities/resources/font_manager.dart';
import 'package:testing/utilities/resources/styles_manager.dart';

class TestingDialog extends StatelessWidget {
  final BuildContext context;
  final String message;
  final String type;

  const TestingDialog({Key? key,required this.context,
    required this.message,
    required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text;
    var msg = message.split(':');
    if (msg.length == 1) {
      text = msg[0];
    } else {
      text = msg[1];
    }
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        backgroundColor: Colors.white,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          height: 210,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TestingText(
                  type == Constants.error ? "Uh Oh." : "You're all set!",
                  style: getMediumStyle(
                      color: ColorManager.black, fontSize: FontSize.s16),
                  isCenter: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorManager.black, width: 2),
                        borderRadius: BorderRadius.circular(50)),
                    child: type == Constants.error
                        ? Icon(
                      Icons.close,
                      color: ColorManager.black,
                      size: 40,
                    )
                        : Icon(
                      Icons.check,
                      color: ColorManager.black,
                      size: 40,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  type == Constants.error
                      ? (text.length > 130 ? "Try Again" : text)
                      : (text.length > 130
                      ? "Congratulation, successful"
                      : text),
                  style: getRegularStyle(color: ColorManager.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  height: 30,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: ColorManager.primaryOpacity70,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  elevation: 0,
                  child:  TestingText(
                      type == Constants.error ? "Try again" : "Got it!",
                      isCenter: true,
                      style: getBoldStyle(color: ColorManager.white, )
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
