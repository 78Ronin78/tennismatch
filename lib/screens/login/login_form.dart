import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_match_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:tennis_match_app/blocs/login_bloc/login_bloc.dart';
import 'package:tennis_match_app/screens/register/register_screen.dart';
import 'package:tennis_match_app/widgets/button_widgets.dart';
import 'package:tennis_match_app/widgets/gradient_button.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
            ..removeCurrentSnackBar()
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
            ..removeCurrentSnackBar()
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
                    ),
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
                    ),
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
                        /*errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.red)),*/
                      ),
                      obscureText: true,
                      autocorrect: false,
                      validator: (_) {
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
                  /*GradientButton(
                    width: 210,
                    height: 45,
                    onPressed: () {
                      if (isButtonEnabled(state)) {
                        _onFormSubmitted();
                      }
                    },
                    text: Text(
                      'Войти',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),*/
                  SizedBox(
                    height: 10,
                  ),
                  /*GradientButton(
                    width: 220,
                    height: 45,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return RegisterScreen();
                      }));
                    },
                    text: Text(
                      'Зарегистрироваться',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),*/
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
}
