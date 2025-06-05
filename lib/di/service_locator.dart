import 'package:get_it/get_it.dart';

import '../data/datasources/firebase_auth_datasource.dart';
import '../data/datasources/firebase_notes_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/notes_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/notes_repository.dart';
import '../domain/usecases/auth_usecases.dart';
import '../domain/usecases/notes_usecases.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/notes_provider.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Data sources
  getIt.registerLazySingleton<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSourceImpl());
  getIt.registerLazySingleton<FirebaseNotesDataSource>(
      () => FirebaseNotesDataSourceImpl());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<FirebaseAuthDataSource>()));
  getIt.registerLazySingleton<NotesRepository>(
      () => NotesRepositoryImpl(getIt<FirebaseNotesDataSource>()));

  // Use cases
  getIt.registerLazySingleton(() => AuthUseCases(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => NotesUseCases(getIt<NotesRepository>()));

  // Providers
  getIt.registerFactory(() => AuthProvider(getIt<AuthUseCases>()));
  getIt.registerFactory(() => NotesProvider(getIt<NotesUseCases>()));
}
