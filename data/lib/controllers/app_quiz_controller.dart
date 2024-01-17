import 'dart:io';

import 'package:data/utils/app_response.dart';
import 'package:data/utils/app_utils.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/quiz.dart';

class AppQuizController extends ResourceController {
  final ManagedContext managedContext;

  AppQuizController(this.managedContext);

  @Operation.post()
  Future<Response> createQuizs(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() Quiz quiz) async {
    try {
      final id = AppUtils.getIdFromHeaders(header);
      final qCreateQuiz = Query<Quiz>(managedContext)
        ..values.userId = id
        ..values.name = quiz.name
        ..values.status = quiz.status;
      await qCreateQuiz.insert();
      return AppResponse.ok(message: "Create quiz ok");
    } catch (error) {
      return AppResponse.serverError(error, message: "Create quiz error");
    }
  }

  @Operation.get("id")
  Future<Response> getQuiz(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id) async {
    try {
      final userId = AppUtils.getIdFromHeaders(header);
      final quiz = await managedContext.fetchObjectWithID<Quiz>(id);
      if (quiz == null) {
        return AppResponse.ok(message: "Quiz not found");
      }
      if (userId != quiz.userId) {
        return AppResponse.ok(message: "Access denied");
      }
      quiz.backing.removeProperty("userId");
      return AppResponse.ok(
          body: quiz.backing.contents, message: "Get quiz ok");
    } catch (error) {
      return AppResponse.serverError(error, message: "Get quiz error");
    }
  }

  @Operation.delete("id")
  Future<Response> deleteQuiz(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id) async {
    try {
      final userId = AppUtils.getIdFromHeaders(header);
      final quiz = await managedContext.fetchObjectWithID<Quiz>(id);
      if (quiz == null) {
        return AppResponse.ok(message: "Quiz not found");
      }
      if (userId != quiz.userId) {
        return AppResponse.ok(message: "Access denied");
      }
      final qDeleteQuiz = Query<Quiz>(managedContext)
        ..where((x) => x.id).equalTo(id);
      await qDeleteQuiz.delete();
      return AppResponse.ok(message: "Delete quiz ok");
    } catch (error) {
      return AppResponse.serverError(error, message: "Get quiz error");
    }
  }

  @Operation.get()
  Future<Response> getQuizs(
      @Bind.header(HttpHeaders.authorizationHeader) String header) async {
    try {
      final userId = AppUtils.getIdFromHeaders(header);
      final qGetQuizs = Query<Quiz>(managedContext)
        ..where((x) => x.userId).equalTo(userId);
      final List<Quiz> quizs = await qGetQuizs.fetch();
      if (quizs.isEmpty) {
        return Response.notFound();
      }
      return Response.ok(quizs);
    } catch (error) {
      return AppResponse.serverError(error, message: "Get quizs list error");
    }
  }
}
