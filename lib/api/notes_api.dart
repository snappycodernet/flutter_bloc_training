import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc_course/models.dart';

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();

  Future<Iterable<Note>?> getNotes({required LoginHandle handle});
}

@immutable class NotesApi implements NotesApiProtocol {
  // singleton pattern
  const NotesApi._();
  static const _instance = NotesApi._();
  factory NotesApi.instance() => _instance;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle handle}) async {
    await Future.delayed(const Duration(seconds: 2));

    if(handle == const LoginHandle.foobar()) {
      return mockNotes;
    }

    return null;
  }
}