import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_match_app/blocs/login_bloc/login_bloc.dart';
import 'package:tennis_match_app/screens/register/register_screen.dart';
import 'package:tennis_match_app/widgets/text_widget.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, //скрывает Appbar с экрана
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
        child: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              SizedBox(height: 75),
              Image.asset(
                'assets/images/login.png',
                width: double.infinity,
                height: 170,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 25),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                child: Text(
                  'Вход',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                child: Text(
                  'Пожалуйста, войдите, чтобы продолжить',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              LoginForm(),
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
            ],
          )),
        ),

        /*Container(
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xfff2cbd0), Color(0xfff4ced9)],
          )),
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                CurvedWidget(
                  child: Container(
                    padding: const EdgeInsets.only(top: 100, left: 50),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.white.withOpacity(0.4)],
                      ),
                    ),
                    child: Text(
                      'Вход',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color(0xff6a515e),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 230),
                  child: LoginForm(),
                )
              ],
            ),
          ),
        ),*/
      ),
    );
  }
}
