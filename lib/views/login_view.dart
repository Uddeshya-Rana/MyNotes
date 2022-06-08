import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';



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
      body: FutureBuilder(  //it tells the core flutter engine to draw this column in future (bcz we want it to be rendered only when firebase has been initialized)
        future: Firebase.initializeApp( //removed await bcz its auto implied inside future parameter of future builder
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

          switch(snapshot.connectionState){
          //Returns column in case the Future firebase object gets completed successfully
            case ConnectionState.done:
              return Column(
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
                              UserCredential userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: email,
                                  password: password
                                  );
                              print(userCredential);
                           }on FirebaseAuthException catch(e){ //catches on the firebase auth type of exceptions
                          if(e.code=='user-not-found')
                            print('The user has not been registered');
                          else if(e.code=='wrong-password')
                            print('enter correct password');
                          else if(e.code=='invalid-email')
                            print('Please enter a valid email address');
                        }
                        catch(e){ //catches every other type of error
                          print(e);
                          print(e.runtimeType);
                        }

                    },
                    child: const Text('Login'),
                  ),
                ],
              );
          //Returns text of loading in every other state
            default:
              return const Text('Loading....');
          }

        }, //builder

      ),
    );
  }

 
}
