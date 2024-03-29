import 'package:auth/models/response_model.dart';
import 'package:auth/models/user.dart';
import 'package:auth/utils/app_env.dart';
import 'package:auth/utils/app_response.dart';
import 'package:auth/utils/app_utils.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class AppAuthController extends ResourceController {
  final ManagedContext managedContext;

  AppAuthController(this.managedContext);

  @Operation.post()
  Future<Response> signIn(@Bind.body() User user) async {
    if (user.password == null || user.login == null) {
      return Response.badRequest(
          body: RespModel(message: "Login or Password is requared!"));
    }

    try {
      final qFindUser = Query<User>(managedContext)
        ..where((table) => table.login).equalTo(user.login)
        ..returningProperties(
            (table) => [table.id, table.salt, table.hashPassword]);

      final findUser = await qFindUser.fetchOne();
      if (findUser == null) {
        return AppResponse.serverError("Auth false", message: "User not found");
      }
      final requestHashPassword =
          generatePasswordHash(user.password ?? "", findUser.salt ?? "");
      if (requestHashPassword == findUser.hashPassword) {
        await _updateTokens(findUser.id ?? -1, managedContext);
        final newUser =
            await managedContext.fetchObjectWithID<User>(findUser.id);
        return AppResponse.ok(
            body: newUser?.backing.contents, message: "Auth Ok");
      } else {
        return AppResponse.ok(message: "Wrong password");
      }
    } catch (error) {
      return AppResponse.serverError(error, message: "Auth false");
    }
  }

  @Operation.put()
  Future<Response> signUp(@Bind.body() User user) async {
    if (user.password == null ||
        user.login == null ||
        user.email == null ||
        user.role == null ||
        user.lastName == null ||
        user.firstName == null) {
      return Response.badRequest(
          body: RespModel(
              message: "Login, Password, Role, FIO, Email is requared!"));
    }
    final salt = generateRandomSalt();
    final hashPassword = generatePasswordHash(user.password ?? "", salt);

    try {
      late final int id;
      await managedContext.transaction((transaction) async {
        final qCreateUser = Query<User>(transaction)
          ..values.login = user.login
          ..values.email = user.email
          ..values.lastName = user.lastName
          ..values.firstName = user.firstName
          ..values.middleName = user.middleName
          ..values.role = user.role
          ..values.salt = salt
          ..values.hashPassword = hashPassword;
        final createdUser = await qCreateUser.insert();
        id = createdUser.asMap()["id"];

        await _updateTokens(id, transaction);
      });
      final userData = await managedContext.fetchObjectWithID<User>(id);
      return AppResponse.ok(
          body: userData?.backing.contents, message: "Registration Ok");
    } catch (error) {
      return AppResponse.serverError(error, message: "Registration false");
    }
  }

  Future<void> _updateTokens(int id, ManagedContext transaction) async {
    final Map<String, dynamic> tokens = _getTokens(id);
    final qUpdateTokens = Query<User>(transaction)
      ..where((user) => user.id).equalTo(id)
      ..values.accessToken = tokens["access"]
      ..values.refreshToken = tokens["refresh"];
    await qUpdateTokens.updateOne();
  }

  @Operation.post("refresh")
  Future<Response> refreshToken(
      @Bind.path("refresh") String refreshToken) async {
    try {
      final id = AppUtils.getIdFromToken(refreshToken);
      final user = await managedContext.fetchObjectWithID<User>(id);
      if (user?.refreshToken != refreshToken) {
        return Response.unauthorized(
            body: RespModel(message: "Token is not valid"));
      } else {
        await _updateTokens(id, managedContext);
        final user = await managedContext.fetchObjectWithID<User>(id);
        return Response.ok(RespModel(
            data: user?.backing.contents, message: "Refresh token ok"));
      }
    } catch (error) {
      return AppResponse.serverError(error, message: "Refresh false");
    }
  }
}

Map<String, dynamic> _getTokens(int id) {
  final key = AppEnv.secretKey;
  final accessClaimSet =
      JwtClaim(maxAge: Duration(minutes: AppEnv.time), otherClaims: {"id": id});
  final refreshClaimSet = JwtClaim(otherClaims: {"id": id});
  final tokens = <String, dynamic>{};
  tokens["access"] = issueJwtHS256(accessClaimSet, key);
  tokens["refresh"] = issueJwtHS256(refreshClaimSet, key);
  return tokens;
}
