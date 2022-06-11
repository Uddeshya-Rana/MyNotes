import 'package:flutter/material.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth_exceptions.dart';
import 'package:mynotes/services/auth_service.dart';

import '../utilities/show_error_dialog.dart';


class LoginView extends StatefulWidget{
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState(){
    _email=TextEditingController();
    _password=TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

              return Scaffold(
                appBar: AppBar(
                  title: const Text('Login'),
                ),
                body: Column(
                  children: [
                    TextField(
                      controller: _email,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'Enter your email here' //hint on text fields: to help the user understand purpose of text field
                      ),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,// text must be obscured for password
                      enableSuggestions: false, //we don't want suggestion from keyboard
                      decoration: const InputDecoration(
                          hintText: 'Enter your password here' //hint on text fields: to help the user understand purpose of text field
                      ),
                    ),
                    TextButton(
                      onPressed: () async{//registration of firebase user is an asynchronous task i.e. it doesn't complete immediately

                        final email=_email.text;
                        final password=_password.text;
                          try{
                            await AuthService.firebase().logIn(
                                email: email,
                                password: password
                            );

                                Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);

                             }on UserNotFoundAuthException catch(e){ //catches on the firebase auth type of exceptions
                              await showErrorDialog(context, 'User not found!');
                            } on WrongPasswordAuthException {
                              await showErrorDialog(context, 'Wrong password!');
                            } on InvalidEmailAuthException {
                              await showErrorDialog(context, 'Not a valid email!');
                            } on GenericAuthException{
                            await showErrorDialog(context, 'Authentication error!');
                          }


                      },
                      child: const Text('Login'),
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pushNamedAndRemoveUntil(
                                  registerRoute,
                                  (route) => false);
                        },
                        child: const Text('Not registered yet? Register here!'),
                    )
                  ],
                ),
              );

  }

 
}

