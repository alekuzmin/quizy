import 'package:auth/models/response_model.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class AppResponse extends Response {
  AppResponse.serverError(dynamic error, {String? message})
      : super.serverError(body: _getresponseModel(error, message));

  static _getresponseModel(error, String? message) {
    if (error is QueryException) {
      return RespModel(
          error: error.toString(), message: message ?? error.message);
    }
    if (error is JwtException) {
      return RespModel(
          error: error.toString(), message: message ?? error.message);
    }

    return RespModel(
        error: error.toString(), message: message ?? "Unknown exception");
  }

  AppResponse.ok({dynamic body, String? message})
      : super.ok(RespModel(data: body, message: message));

  AppResponse.badRequest({String? message})
      : super.badRequest(body: RespModel(message: message ?? "Error"));

  AppResponse.unauthorized(dynamic error, {String? message})
      : super.unauthorized(body: _getresponseModel(error, message));
}
