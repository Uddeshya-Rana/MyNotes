import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                        UserCredential userCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: email,
                            password: password
                        );
                        print(userCredential);
                      }on FirebaseAuthException catch(e){ //catches on the firebase auth type of exceptions
                        if(e.code=='weak-password')
                          print('password is too short');
                        else if(e.code=='email-already-in-use')
                          print('this email is already registred');
                        else if(e.code=='invalid-email')
                          print('Please enter a valid email address');
                      }
                      catch(e){ //catches every other type of error
                        print(e);
                        print(e.runtimeType);
                      }


                    },
                    child: const Text('Register'),
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
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
