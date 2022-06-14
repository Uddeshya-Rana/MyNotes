import 'package:flutter/material.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth_service.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

import '../services/auth_exceptions.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

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
        title: const Text('Register'),
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
                    onPressed: () async{

                      final email=_email.text;
                      final password=_password.text;
                      try{
                     await AuthService.firebase().createUser(
                         email: email,
                         password: password
                     );

                        showSuccessfulRegistrationDialog(context);
                      }on EmailAlreadyInUseAuthException{
                        await showErrorDialog(context, 'Email is already in use!');
                      } on WeakPasswordAuthException {
                        await showErrorDialog(context, 'Password is too short!');
                      } on InvalidEmailAuthException {
                        await showErrorDialog(context, 'Not a valid email!');
                      } on GenericAuthException{
                        await showErrorDialog(context, 'Authentication error!');
                      }

                    },
                    child: const Text('Register'),
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil( //Remove Until pushes a screen without the option of going back to previous one
                          loginRoute,
                          (route) => false
                        );
                      },
                      child: const Text('Already registered? Login here!'),
                  )
                ],
              ),


    );
  }
}


Future<void> showSuccessfulRegistrationDialog(BuildContext context){
  return showDialog<bool>(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Registration was successful! proceed to login'),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
                child: const Text('OK')
            ),

          ],
        );
      }
  );

}