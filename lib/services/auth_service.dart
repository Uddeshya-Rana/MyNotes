
import 'package:mynotes/services/auth_provider.dart';
import 'package:mynotes/services/auth_user.dart';
import 'package:mynotes/services/firebase_auth_provider.dart';

class AuthService implements AuthProvider{
  final AuthProvider provider; //creating an object or instance of AuthProvider class
  const AuthService(this.provider);

  //factory constructor to initialize AuthService instance with FirebaseAuthProvider constructor
  //we are using same initialization and function implementations as done in FirebaseAuthProvider
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> createUser(
      {required String email,
        required String password,
      }) =>provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn(
      {required String email,
        required String password,
      })=>provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() =>provider.logOut();

}