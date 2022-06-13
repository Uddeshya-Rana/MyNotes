import 'package:flutter/material.dart';

@immutable //internals of this class can't be changed after initialization
class AuthUser{
  final String? userId; //user Id is required and essential, hence can't be null
  final String email;
  const AuthUser(this.email, {required this.userId});
}

