//Importing all the custom service classes

import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';
import 'auth_exceptions.dart';
import 'auth_provider.dart';
import 'auth_user.dart';

//Importing firebase Auth

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthProvider implements AuthProvider{

  @override
  Future<void> initialize() async{
    Firebase.initializeApp( //removed await bcz its auto implied inside future parameter of future builder
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }//initialize

  @override
  //  currentUser getter
  AuthUser? get currentUser{
    final User? u= FirebaseAuth.instance.currentUser;
    if(u!=null){
      return AuthUser(u.email!,userId: u.uid); //returns and initialize AuthUser instance with uid string
    }else{
      return null;
    }

  }

  @override
  Future<AuthUser> createUser({required String email, required String password}) async {
   try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
         email: email,
         password: password
      ); //createUserWithEmailAndPassword
     final user= currentUser; //calling currentUser getter
     if(user!=null){
       return user;
     }
     else{
       throw UserNotLoggedInAuthException();
     }
   } //try
   on FirebaseAuthException catch(e){
     if(e.code=='weak-password') {
        throw WeakPasswordAuthException();
     } else if(e.code=='email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
     } else if(e.code=='invalid-email') {
        throw InvalidEmailAuthException();
     }
     else{
        throw GenericAuthException();
     }

   } //FirebaseAuthException
   catch(e){ //for generic exceptions
    throw GenericAuthException();
   }

  }//createUser

  @override
  Future<AuthUser> logIn({required String email, required String password}) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      final user= currentUser; //calling currentUser getter
      if(user!=null){
        return user;
      }
      else{
        throw UserNotLoggedInAuthException();
      }

    }//try
    on FirebaseAuthException catch(e){
      if(e.code=='user-not-found') {
        throw UserNotFoundAuthException();
      } else if(e.code=='wrong-password') {
        throw WrongPasswordAuthException();
      } else if(e.code=='invalid-email') {
        throw InvalidEmailAuthException();
      }
      else{
        throw GenericAuthException();
      }
    }//FirebaseAuthException
    catch(e){ //for generic exceptions
      throw GenericAuthException();
    }

  }//login


  @override
  Future<void> logOut() async{
   final user = FirebaseAuth.instance.currentUser;
   if(user!=null){
     await FirebaseAuth.instance.signOut();
   }
   else{
     throw UserNotLoggedInAuthException();
   }
  }//logOut

  
}
