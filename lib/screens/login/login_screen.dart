import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tennis_match_app/blocs/login_bloc/login_bloc.dart';

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
              SvgPicture.asset(
                'assets/images/logotype_yellow.svg',
                height: 150,
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
            ],
          )),
        ),
      ),
    );
  }
}
