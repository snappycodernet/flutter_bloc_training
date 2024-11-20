import 'package:flutter/material.dart';
import 'package:testing_bloc_course/strings.dart' show login;

/*
final email = emailController.text;
final password = passwordController.text;

if(email.isEmpty || password.isEmpty) {
  showGeneralDialog<bool>(
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
 */

class LoginButton extends StatelessWidget {
  final VoidCallback onLoginTapped;

  const LoginButton({super.key, required this.onLoginTapped});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onLoginTapped,
      child: const Text(login)
    );
  }
}
