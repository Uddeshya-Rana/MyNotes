
import 'package:mynotes/services/auth_provider.dart';
import 'package:mynotes/services/auth_user.dart';

class AuthService implements AuthProvider{
  final AuthProvider provider; //creating an object or instance of AuthProvider class
  const AuthService(this.provider);

  //simply calling the functions of provider instance for overriding 
  @override
  Future<AuthUser> createUser(
      {required String email,
        required String password,
      }) =>provider.createUser(email: email, password: password);

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn(
      {required String email,
        required String password,
      })=>provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() =>provider.logOut();

}