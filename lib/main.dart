import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'firebase_options.dart';
//import 'dart:developer' as developer;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),  //our default view
      routes: {
        loginRoute : (context) => const LoginView(),
        registerRoute : (context) =>const RegisterView(),
        notesRoute :(context) =>const NotesView(),
        verifyEmailRoute:(context) => const VerifyEmailView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(  //it tells the core flutter engine to draw this column in future (bcz we want it to be rendered only when firebase has been initialized)
        future: Firebase.initializeApp( //removed await bcz its auto implied inside future parameter of future builder
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

          switch(snapshot.connectionState){
          //Returns a loading screen in every case other than connection established to firebase
            case ConnectionState.done:
               final User? user= FirebaseAuth.instance.currentUser;
              if(user!=null){ //i.e. user is logged in
                  /*if(user.emailVerified){
                    developer.log('email is verified');
                  }
                  //OPTIONAL TO USE, NOT PREFERRED
                  //REMOVED EMAIL VERIFICATION AS IT IS NOT REQUIRED (FB AND GOOGLE SIGN UPS ARE BETTER ALTERNATIVES)
                  else
                    {
                      return const VerifyEmailView();
                    }*/
                  return const NotesView(); //if user is logged in
               }
               else //user is null i.e. not logged in
                 {
                    return const LoginView(); //there is a link bw loginView and RegisterView so no need to make a separate condition to return registerView
                 }

             // return const NotesView();
            default:
              return const CircularProgressIndicator(); //for showing loading in case connection to firebase not established or in progress
          }

        }, //builder

      );

  }


}






