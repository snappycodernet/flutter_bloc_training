import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:testing_bloc_course/dialogs/generic_dialog.dart';
import 'package:testing_bloc_course/widgets/email_text_field.dart';
import 'package:testing_bloc_course/widgets/login_button.dart';
import 'package:testing_bloc_course/widgets/password_text_field.dart';

import '../strings.dart';

typedef LoginCallback = void Function(String password, String email);

class LoginScreen extends HookWidget {
  final LoginCallback onLoginTapped;

  const LoginScreen({super.key, required this.onLoginTapped});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          EmailTextField(emailController: emailController),
          PasswordTextField(passwordController: passwordController),
          LoginButton(onLoginTapped: () {
            final email = emailController.text;
            final password = passwordController.text;

            if(email.isEmpty || password.isEmpty) {
              showGenericDialog(
                context: context,
                title: emailOrPasswordEmptyDialogTitle,
                content: emailOrPasswordEmptyDescription,
                optionsBuilder: () => {
                  ok: true,
                },
              );
            }
            else {
              onLoginTapped(email, password);
            }
          })
        ],
      ),
    );
  }
}
