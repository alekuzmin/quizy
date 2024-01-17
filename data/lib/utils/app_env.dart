import 'dart:io';

abstract class AppEnv {
  AppEnv._();
  static final String secretKey =
      Platform.environment["SECRET_KEY"] ?? "SECRET_KEY";
  static final String port = Platform.environment["PORT"] ?? "6200";
  static final String dbLogin = Platform.environment["DB_LOGIN"] ?? "admin";
  static final String dbPassword =
      Platform.environment["DB_PASSWORD"] ?? "root";
  static final String dbHost = Platform.environment["DB_HOST"] ?? "localhost";
  static final String dbPort = Platform.environment["DB_PORT"] ?? "6201";
  static final String dbName = Platform.environment["DB_NAME"] ?? "postgres";
}
