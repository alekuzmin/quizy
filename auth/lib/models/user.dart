import 'package:conduit_core/conduit_core.dart';

class User extends ManagedObject<_User> implements _User {}

class _User {
  @primaryKey
  int? id;
  @Column(unique: true, indexed: true)
  String? login;
  @Column(unique: true, indexed: true)
  String? email;
  @Column(unique: false, indexed: true)
  String? lastName;
  @Column(unique: false, indexed: true)
  String? firstName;
  @Column(unique: false, indexed: true)
  String? middleName;
  @Column(unique: false, indexed: true)
  String? role;
  @Serialize(input: true, output: false)
  String? password;
  @Column(nullable: true)
  String? accessToken;
  @Column(nullable: true)
  String? refreshToken;
  @Column(omitByDefault: true)
  String? salt;
  @Column(omitByDefault: true)
  String? hashPassword;
}
