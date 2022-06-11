import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';


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
        future: AuthService.firebase().initialize(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

          switch(snapshot.connectionState){
          //Returns a loading screen in every case other than connection established to firebase
            case ConnectionState.done:
               final user= AuthService.firebase().currentUser;
              if(user!=null){ //i.e. user is logged in

                  return const NotesView(); //if user is logged in
               }
               else //user is null i.e. not logged in
                 {
                    return const LoginView();
                 }

            default:
              return const CircularProgressIndicator(); //for showing loading in case connection to firebase not established or in progress
          }

        }, //builder

      );

  }


}






