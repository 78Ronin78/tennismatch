import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_match_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:tennis_match_app/blocs/home_bloc/home_bloc.dart';
import 'package:tennis_match_app/blocs/simple_bloc_observer.dart';
import 'package:tennis_match_app/locator.dart';
import 'package:tennis_match_app/screens/home_screen.dart';
import 'package:tennis_match_app/screens/login/login_screen.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  setupLocator();
  runApp(
    BlocProvider(
      create: (context) => AuthBloc()..add(AuthStarted()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF201A31),
        primaryColor: Color(0xFF201A31),
      ),
      title: 'TENNISMATCH',
      /*theme: ThemeData(
          primaryColor: Color(0xfffae7e9),
          accentColor: Color(0xfff2cbd0),
          appBarTheme: AppBarTheme(
            elevation: 0.0,
            color: Colors.transparent,
          )),*/
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthFailure) {
            return LoginScreen();
          }

          if (state is AuthSuccess) {
            return BlocProvider(
              create: (context) => HomeBloc(),
              child: HomeScreen(
                user: state.user,
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(),
            body: Container(
              child: Center(
                child: Text('Загрузка данных...'),
              ),
            ),
          );
        },
      ),
    );
  }
}
