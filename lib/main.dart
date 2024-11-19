import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

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
        home: BlocProvider(
          create: (context) => PersonsBloc(),
          child: const HomePage()
        )
    );
  }
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final PersonUrl url;

  const LoadPersonsAction({required this.url}) : super();
}

enum PersonUrl {
  persons1,
  persons2,
}

extension JsonString on PersonUrl {
  Future<dynamic> get jsonData async {
    String path;

    switch(this) {
      case PersonUrl.persons1:
        path = "https://jsonplaceholder.typicode.com/users/1";
      case PersonUrl.persons2:
        path = "https://jsonplaceholder.typicode.com/users/2";
    }

    final url = Uri.parse(path);
    final response = await http.get(url);

    if(response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }
}

@immutable
class Person {
  final String name;
  final String email;

  const Person({required this.name, required this.email});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      email: json['email']
    );
  }
}

Future<Iterable<Person>> getPersons(PersonUrl url) async {
  var json = await url.jsonData as dynamic;

  return [Person.fromJson(json)];
}

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResult({required this.persons, required this.isRetrievedFromCache});

  @override
  String toString() => 'FetchResult (isRetrievedFromCache = $isRetrievedFromCache, persons = $persons';
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cache = {};

  PersonsBloc() : super(null) {
    on<LoadPersonsAction>(_loadPersons);
  }

  Future<void> _loadPersons(event, emit) async {
    final PersonUrl url = event.url;

    if(_cache.containsKey(url)) {
      final cachedPersons = _cache[url]!;
      final result = FetchResult(
          persons: cachedPersons,
          isRetrievedFromCache: true
      );

      emit(result);
    }
    else {
      final persons = await getPersons(url);
      _cache[url] = persons;
      final result = FetchResult(
          persons: persons,
          isRetrievedFromCache: false
      );

      emit(result);
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow.shade700,
          centerTitle: true,
          title: const Text('Home Page'),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<PersonsBloc>().add(const LoadPersonsAction(url: PersonUrl.persons1));
                  },
                  child: const Text('Load JSON #1')
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<PersonsBloc>().add(const LoadPersonsAction(url: PersonUrl.persons2));
                  },
                  child: const Text('Load JSON #2')
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocBuilder<PersonsBloc, FetchResult?>(
              buildWhen: (previous, current) {
                // this ensures we dont rebuild unnecessarily when
                // isRetrievedFromCache value is changed?
                return previous?.persons != current?.persons;
              },
              builder: (context, state) {
                if(state == null || state.persons.isEmpty) {
                  return const Text('No persons loaded');
                }

                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (_, idx) {
                      var person = state.persons.elementAt(idx);

                      return ListTile(
                        title: Row(
                          children: [
                            Text(person.name),
                            Text(person.email),
                          ],
                        )
                      );
                    },
                    shrinkWrap: true,
                    itemCount: state.persons.length,
                  )
                );
              }
            )
          ],
        )
    );
  }
}