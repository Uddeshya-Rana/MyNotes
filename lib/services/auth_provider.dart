
import 'package:mynotes/services/auth_user.dart';

abstract class AuthProvider{

  Future<void> initialize();
  AuthUser? get currentUser; //returns current user of type AuthUser
  Future<AuthUser> logIn( {required  String email, required String password,});
  Future<AuthUser> createUser( {required  String email, required String password,}); //for registration, returns instance of AuthUser class defined in auth_user.dart
  Future<void> logOut();

}