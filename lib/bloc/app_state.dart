import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc_course/models.dart';

@immutable class AppState {
  final bool isLoading;
  final LoginErrors? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNotes;

  const AppState({
    required this.isLoading,
    required this.loginError,
    required this.loginHandle,
    required this.fetchedNotes,
  });

  const AppState.empty() :
    isLoading = false,
    loginError = null,
    loginHandle = null,
    fetchedNotes = null;

  @override
  String toString() {
    Map<String, Object?> dataMap = {
      'isLoading': isLoading,
      'loginError': loginError,
      'loginHandle': loginHandle,
      'fetchedNotes': fetchedNotes,
    };

    return dataMap.toString();
  }
}