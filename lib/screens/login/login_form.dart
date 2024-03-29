import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tennis_match_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:tennis_match_app/blocs/login_bloc/login_bloc.dart';
import 'package:tennis_match_app/locator.dart';
import 'package:tennis_match_app/screens/phone_auth/phone_auth_screen.dart';
import 'package:tennis_match_app/screens/register/register_screen.dart';
import 'package:tennis_match_app/services/auth_service.dart';
import 'package:tennis_match_app/utils/message_exception.dart';
import 'package:tennis_match_app/widgets/button_widgets.dart';
import 'package:tennis_match_app/widgets/text_widget.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //AuthService fbAuth = AuthService();
  final AuthService _authService = locator<AuthService>();

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            // ignore: deprecated_member_use
            ..removeCurrentSnackBar()
            // ignore: deprecated_member_use
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Ошибка авторизации'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state.isSubmitting) {
          Scaffold.of(context)
            // ignore: deprecated_member_use
            ..removeCurrentSnackBar()
            // ignore: deprecated_member_use
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Авторизация...'),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state.isSuccess) {
          BlocProvider.of<AuthBloc>(context).add(
            AuthLoggedIn(),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 70,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(width: 1.0, color: state.validColor)),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Icon(Icons.email),
                        ),
                        labelText: "Email",
                        contentPadding: EdgeInsets.only(top: 5, bottom: 2),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (_) {
                        //brdEmailColor = Colors.red;
                        return !state.isEmailValid ? 'Неверный Email' : null;
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 70,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(width: 1.0, color: state.validColor)),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Icon(Icons.lock),
                        ),
                        labelText: "Пароль",
                        contentPadding: EdgeInsets.only(top: 5, bottom: 2),
                      ),
                      obscureText: true,
                      autocorrect: false,
                      validator: (_) {
                        //brdPassColor = Colors.red;
                        return !state.isPasswordValid
                            ? 'Неверный Пароль'
                            : null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                    text: 'Войти',
                    onPressed: () {
                      if (isButtonEnabled(state)) {
                        _onFormSubmitted();
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Забыли пароль ?',
                      style: TextStyle(
                        color: Color(0xFFADFF2F),
                      ),
                    ),
                  ),
                  SizedBox(height: 45),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text_Widget(
                        text: 'Нет учетной записи ?', signText: 'СОЗДАТЬ'),
                  ),
                  SizedBox(height: 45),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'ИЛИ',
                      style: TextStyle(
                        color: Color(0xFFADFF2F),
                      ),
                    ),
                  ),
                  socialLink(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChange() {
    _loginBloc.add(LoginEmailChange(email: _emailController.text));
  }

  void _onPasswordChange() {
    _loginBloc.add(LoginPasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }

  //Виджет кнопок входе через соцсети
  Widget socialLink() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(),
            if (Platform.isIOS)
              Icon(
                FontAwesomeIcons.apple,
                color: Colors.green,
                size: 30.0,
              ),
            if (Platform.isAndroid)
              GestureDetector(
                onTap: () {
                  print('Вход через Google');
                  signInGoogle();
                },
                child: Icon(
                  FontAwesomeIcons.google,
                  color: Color(0xFFADFF2F),
                  size: 30.0,
                ),
              ),
            GestureDetector(
              onTap: () {
                print('Вход через VK');

                signInVk();
              },
              child: Icon(
                FontAwesomeIcons.vk,
                color: Color(0xFFADFF2F),
                size: 30.0,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PhoneAuthScreen(),
                  ),
                );
              },
              child: Icon(
                FontAwesomeIcons.phone,
                color: Color(0xFFADFF2F),
                size: 30.0,
              ),
            ),
            Container()
          ],
        ),
      ],
    );
  }

  //Вход с помощью google аккаунта
  signInGoogle() async {
    try {
      await _authService.signInWithGoogle(context);
    } on MessageException catch (e) {
      print(e);
      //_scaffoldKey?.currentState?.showSnackBar(SnackBarScope.show(e.message));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${e.message}'),
        ),
      );
    }
  }

  //Вход с помощью аккаунта vk.com
  signInVk() async {
    try {
      await _authService.signInWithVK(context);
    } on MessageException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${e.message}'),
        ),
      );
    }
  }
}
