import 'package:bloc/bloc.dart';
import 'package:testing_bloc_course/api/login_api.dart';
import 'package:testing_bloc_course/api/notes_api.dart';
import 'package:testing_bloc_course/bloc/actions.dart';
import 'package:testing_bloc_course/bloc/app_state.dart';
import 'package:testing_bloc_course/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({required this.loginApi, required this.notesApi}) : super(const AppState.empty()) {
    on<LoginAction>(_onLoginAction);
    on<LoadNotesAction>(_onLoadNotesAction);
  }

  Future<void> _onLoginAction(LoginAction event, emit) async {
    // start loading
    emit(const AppState(
      isLoading: true,
      loginError: null,
      loginHandle: null,
      fetchedNotes: null,
    ));

    // log the user in
    final handle = await loginApi.login(email: event.email, password: event.password);
    final hasError = handle == null;

    emit(AppState(
      isLoading: false,
      loginError: hasError ? LoginErrors.invalidHandle : null,
      loginHandle: handle,
      fetchedNotes: null
    ));
  }

  Future<void> _onLoadNotesAction(LoadNotesAction event, emit) async {
    // start loading
    emit(AppState(
      isLoading: true,
      loginError: null,
      loginHandle: state.loginHandle,
      fetchedNotes: null,
    ));

    // load the notes if we have a valid login handle
    final notes = await notesApi.getNotes(handle: state.loginHandle!);
    var hasError = state.loginHandle == null || notes == null;

    emit(AppState(
      isLoading: false,
      loginError: hasError ? LoginErrors.invalidHandle : null,
      loginHandle: state.loginHandle,
      fetchedNotes: notes
    ));
  }
}