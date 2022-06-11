import 'package:flutter/material.dart';

@immutable //internals of this class can't be changed after initialization
class AuthUser{
  final String userId;
  const AuthUser(this.userId);
}

