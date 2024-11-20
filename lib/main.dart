import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/api/login_api.dart';
import 'package:testing_bloc_course/api/notes_api.dart';
import 'package:testing_bloc_course/bloc/actions.dart';
import 'package:testing_bloc_course/bloc/app_bloc.dart';
import 'package:testing_bloc_course/dialogs/generic_dialog.dart';
import 'package:testing_bloc_course/dialogs/loading_screen.dart';
import 'package:testing_bloc_course/extensions/app_extensions.dart';
import 'package:testing_bloc_course/models.dart';
import 'package:testing_bloc_course/screens/login_screen.dart';
import 'package:testing_bloc_course/strings.dart';

import 'bloc/app_state.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Bloc Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage()
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi.instance(),
        notesApi: NotesApi.instance()
      ),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.yellow.shade700,
            centerTitle: true,
            title: const Text(homePage),
          ),
          body: BlocConsumer<AppBloc, AppState>(
            listener: (context, state) {
              // list and display loading screen
              if(state.isLoading) {
                LoadingScreen.instance().show(
                  context: context,
                  text: pleaseWait
                );
              }
              else {
                LoadingScreen.instance().hide();
              }

              // listen and display possible errors
              final loginError = state.loginError;
              
              if(loginError != null) {
                showGenericDialog(
                  context: context,
                  title: loginErrorDialogTitle,
                  content: loginErrorDialogContent,
                  optionsBuilder: () => {
                    ok: true
                  }
                );
              }

              // if we are logged in, have no login errors, and app is not loading,
              // but we have no fetched notes, fetch them now
              if(
                state.isLoading == false &&
                state.loginError == null &&
                state.loginHandle == const LoginHandle.foobar() &&
                state.fetchedNotes == null
              ) {
                context.read<AppBloc>().add(const LoadNotesAction());
              }
            },
            builder: (context, state) {
              final notes = state.fetchedNotes;
              
              if(notes == null) {
                return LoginScreen(
                  onLoginTapped: (email, password) {
                    context.read<AppBloc>().add(LoginAction(email: email, password: password));
                  }
                );
              }
              else {
                return notes.toListView();
              }
            },
          )
      ),
    );
  }
}