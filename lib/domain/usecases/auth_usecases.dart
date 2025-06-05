
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository repository;

  AuthUseCases(this.repository);

  Future<User> signIn(String email, String password) {
    return repository.signIn(email, password);
  }

  Future<User> signUp(String email, String password) {
    return repository.signUp(email, password);
  }

  Future<void> signOut() {
    return repository.signOut();
  }

  Stream<User?> get authStateChanges => repository.authStateChanges;

  User? get currentUser => repository.currentUser;
}
