
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<User> signIn(String email, String password) {
    return dataSource.signIn(email, password);
  }

  @override
  Future<User> signUp(String email, String password) {
    return dataSource.signUp(email, password);
  }

  @override
  Future<void> signOut() {
    return dataSource.signOut();
  }

  @override
  Stream<User?> get authStateChanges => dataSource.authStateChanges;

  @override
  User? get currentUser => dataSource.currentUser;
}
