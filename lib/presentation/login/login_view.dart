import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:testing/customs/widgets/testing_button.dart';
import 'package:testing/customs/widgets/testing_dialog.dart';
import 'package:testing/customs/widgets/testing_text.dart';
import 'package:testing/customs/widgets/testing_text_field.dart';
import 'package:testing/domain/models/login_model.dart';
import 'package:testing/domain/repository/auth_repository.dart';
import 'package:testing/utilities/constants.dart';
import 'package:testing/utilities/resources/color_manager.dart';
import 'package:testing/utilities/resources/font_manager.dart';
import 'package:testing/utilities/resources/routes_manager.dart';
import 'package:testing/utilities/resources/styles_manager.dart';
import 'package:testing/utilities/resources/value_manager.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final LoginModel _loginModel = LoginModel();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _userNameController.text = "601114308483";
    _passwordController.text = "12345678";
    super.initState();
  }

  void handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loginModel.mobile = _userNameController.text;
        _loginModel.password = _passwordController.text;
        _loginModel.device_name = "Driver's Device";
      });
      Provider.of<AuthRepository>(context, listen: false)
          .login(_loginModel)
          .then(_onSuccess)
          .catchError(_onError);
    }

  }

  void _onSuccess(value) async {
    showDialog(
        context: context,
        builder: (_) => TestingDialog(
            context: context,
            message: "Successful Login",
            type: Constants.success));
    Navigator.of(context).pushReplacementNamed(Routes.homeRoute);
  }

  void _onError(value) {
    showDialog(
        context: context,
        builder: (_) => TestingDialog(
            context: context,
            message: "Invalid credential",
            type: Constants.error));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p36),
            child: Column(
              children: [
                TestingText("Hello Again!",
                    style: getMediumStyle(
                        color: ColorManager.black, fontSize: FontSize.s32)),
                const SizedBox(
                  height: AppSize.s12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p28),
                  child: TestingText("Welcome back you've been missed!",
                      isCenter: true,
                      style: getRegularStyle(
                          color: ColorManager.black, fontSize: FontSize.s24)),
                ),
                const SizedBox(
                  height: AppSize.s40,
                ),
                TestingTextField(
                    controller: _userNameController,
                    hint: "Phone",
                    isDigit: true,
                    validationBuilder: ValidationBuilder().phone()),
                const SizedBox(
                  height: AppSize.s16,
                ),
                TestingTextField(
                  controller: _passwordController,
                  hint: "Password",
                  validationBuilder:
                      ValidationBuilder().minLength(6).maxLength(20),
                  isPass: true,
                ),
                const SizedBox(
                  height: AppSize.s40,
                ),
                TestingBtn(
                    text: "Sign In",
                    onPressed: handleLogin,
                    color: ColorManager.primary)
              ],
            ),
          ),
        ),
      )),
    );
  }
}
