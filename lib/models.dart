import 'package:flutter/foundation.dart' show immutable;

@immutable
class LoginHandle {
  final String token;

  const LoginHandle({required this.token});

  const LoginHandle.foobar() : token = 'foobar';

  @override
  bool operator ==(covariant LoginHandle other) {
    return token == other.token;
  }

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() {
    return 'LoginHandle (token = $token)';
  }
}

enum LoginErrors {
  invalidHandle
}

@immutable
class Note {
  final String title;

  const Note({required this.title});

  @override
  String toString() {
    return 'Note (title = $title)';
  }
}

final mockNotes = Iterable.generate(3, (idx) => Note(title: '${idx + 1}'));

