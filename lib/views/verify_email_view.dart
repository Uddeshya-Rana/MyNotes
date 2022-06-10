
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Column(
        children: [
          const Text('Please verify your email address:'),

          TextButton(
            onPressed: () async {
              try{
                User? u= FirebaseAuth.instance.currentUser;
                await u?.sendEmailVerification();
              }catch(e){
                developer.log(e.toString());
              }
              
            },
            child:  const Text('Send email Verification') ,
          ),

        ],
      ),
    );
  }
}

