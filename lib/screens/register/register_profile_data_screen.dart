import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_match_app/blocs/register_bloc/register_bloc.dart';
import 'package:tennis_match_app/screens/register/register_profile_data_form.dart';
import 'package:tennis_match_app/widgets/text_widget.dart';

class RegisterProfileDataScreen extends StatelessWidget {
  const RegisterProfileDataScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Color(0xFFFFFFFF),
        ),
      ),
      body: BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                  child: Text(
                    'Создание аккаунта',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                  child: Text(
                    'Пожалуйста. заполните поля ниже',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: RegisterProfileDateForm(),
                ),
                SizedBox(height: 45),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text_Widget(
                      text: 'Уже есть учетная запись?', signText: 'Войти'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
