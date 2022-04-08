import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:tennis_match_app/locator.dart';
import 'package:tennis_match_app/services/auth_service.dart';
import 'package:tennis_match_app/theme.dart';
import 'package:tennis_match_app/utils/message_exception.dart';
import 'package:tennis_match_app/widgets/button_widgets.dart';

class PhoneAuthForm extends StatefulWidget {
  const PhoneAuthForm({Key key}) : super(key: key);

  @override
  State<PhoneAuthForm> createState() => _PhoneAuthFormState();
}

class _PhoneAuthFormState extends State<PhoneAuthForm> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _phoneController = TextEditingController();
  final _pinPutController = TextEditingController();
  final AuthService _authService = locator<AuthService>();
  String _verificationID;
  bool codeSumbit = false;
  int numScreen = 1;
  bool codeVerify = true;

  @override
  Widget build(BuildContext context) {
    //final mediaQuery = MediaQuery.of(context).size.height - 110;
    var maskFormatter = new MaskTextInputFormatter(
        mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: numScreen != 4
            ? Form(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 70,
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [maskFormatter],
                        controller: _phoneController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Icon(Icons.email),
                          ),
                          labelText: "Номер телефона",
                          hintText: '+7 XXX XXX XX XX',
                          contentPadding: EdgeInsets.only(top: 5, bottom: 2),
                        ),
                        autocorrect: false,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ButtonWidget(
                      text: 'Получить код',
                      onPressed: () {
                        try {
                          _phoneAuth();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Отправка СМС с кодом'),
                            ),
                          );
                        } on MessageException catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${e.message}'),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            : Form(
                child: Column(
                children: <Widget>[
                  PinPut(
                    onSubmit: (value) async {
                      try {
                        bool value = await _authService.submitCode(
                            code: _pinPutController.text,
                            verificationId: _verificationID,
                            context: context);
                        if (!value) {
                          setState(() {
                            codeVerify = false;
                          });
                        }
                      } on MessageException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${e.message}'),
                          ),
                        );
                      }
                    },
                    controller: _pinPutController,
                    fieldsCount: 6,
                    fieldsAlignment: MainAxisAlignment.spaceAround,
                    animationDuration: Duration(seconds: 0),
                    textStyle:
                        TextStyle(fontSize: 28, color: Color(0xFF323232)),
                    preFilledWidget: Container(
                      width: 12,
                      height: 2,
                      color: Color.fromRGBO(197, 206, 224, 1),
                    ),
                  ),
                  if (!codeVerify) Text('Неверный код', style: validateText),
                  SizedBox(
                    height: 74,
                  ),
                  ButtonWidget(
                    text: 'Отправить повторно',
                    onPressed: () {
                      try {
                        _phoneAuth();
                      } on MessageException catch (e) {
                        print(e);
                        //_scaffoldKey?.currentState?.showSnackBar(SnackBarScope.show(e.message));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${e.message}'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              )));
  }

  _phoneAuth() async {
    try {
      await _authService.signInWithPhone(
          phoneNumber: _phoneController.text,
          func: (value) {
            setState(() {
              _verificationID = value;
            });
            if (_verificationID != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('СМС код был выслан'),
                ),
              );
              setState(() {
                codeSumbit = false;
                numScreen = 4;
              });
              // Navigator.push(context,
              //   MaterialPageRoute(builder: (context) {
              //     return ReceiveSmsScreen(verificationId: _verificationID, phoneNumber: _phone.text);
              // }));
            }
          },
          durationCode: () {
            setState(() {
              codeSumbit = true;
            });
          });
    } on MessageException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${e.message}}'),
        ),
      );
    }
  }
}
