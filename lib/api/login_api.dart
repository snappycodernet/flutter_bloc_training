import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc_course/models.dart';

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({required String email, required String password});
}

@immutable
class LoginApi implements LoginApiProtocol {
  // singleton pattern
  const LoginApi._();
  static const _instance = LoginApi._();
  factory LoginApi.instance() => _instance;

  @override
  Future<LoginHandle?> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));

    if(email == 'foo@bar.com' && password == 'foobar') {
      return const LoginHandle.foobar();
    }

    return null;
  }

}