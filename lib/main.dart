import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login_view.dart';
import 'firebase_options.dart';

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
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder(  //it tells the core flutter engine to draw this column in future (bcz we want it to be rendered only when firebase has been initialized)
        future: Firebase.initializeApp( //removed await bcz its auto implied inside future parameter of future builder
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

          switch(snapshot.connectionState){
          //Returns text 'done' in case the Future firebase object gets completed successfully
            case ConnectionState.done:
              User? user= FirebaseAuth.instance.currentUser;
              if(user?.emailVerified ?? false){ // 'if' can only take absolute true or false values not optional null
                print('You are a verified user');
              }
              else
                {print('You are not a verified user');}
              return const Text('Done');
          //Returns text of loading in every other state
            default:
              return const Text('Loading....');
          }

        }, //builder

      ),
    );
  }


}




