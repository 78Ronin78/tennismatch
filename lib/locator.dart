import 'package:get_it/get_it.dart';
import 'package:tennis_match_app/services/auth_service.dart';
import 'package:tennis_match_app/services/chat_service.dart';
import 'package:tennis_match_app/services/repository_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => RepositoryService());
  locator.registerLazySingleton(() => ChatService());
}
