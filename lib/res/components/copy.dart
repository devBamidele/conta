/*

import 'package:conta/res/components/shake_error.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:iconly/iconly.dart';

import '../../res/color.dart';
import '../../res/components/custom_back_button.dart';
import '../../res/components/custom_text_field.dart';
import '../../res/style/component_style.dart';
import '../../utils/widget_functions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  static const tag = '/forgot_password_screen';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  late GlobalKey<FormState> _formKey;
  late GlobalKey<ShakeWidgetState> _shakeState;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _formKey = GlobalKey();
    _shakeState = GlobalKey();
    _textEditingController = TextEditingController(text: "");
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _shakeState.currentState?.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Shake Error"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  ShakeWidget(
                    key: _shakeState,
                    shakeCount: 3,
                    shakeOffset: 5,
                    child: TextFormField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Text..."),
                      ),
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return "Value can't be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.validate();
                      if (_textEditingController.text.isEmpty) {
                        _shakeState.currentState?.shake();
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

 */
