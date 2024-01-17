import 'dart:io';

import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/question.dart';
import 'package:data/utils/app_response.dart';

class AppQuestionController extends ResourceController {
  final ManagedContext managedContext;

  AppQuestionController(this.managedContext);

  @Operation.post()
  Future<Response> createQuestion(@Bind.body() Question question) async {
    try {
      final qCreateQuestion = Query<Question>(managedContext)
        ..values.quizId = question.quizId
        ..values.text = question.text;
      await qCreateQuestion.insert();
      return AppResponse.ok(message: "Create question ok");
    } catch (error) {
      return AppResponse.serverError(error, message: "Create question error");
    }
  }

  @Operation.get("id")
  Future<Response> getQuestion(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id) async {
    try {
      final question = await managedContext.fetchObjectWithID<Question>(id);
      if (question == null) {
        return AppResponse.ok(message: "Question not found");
      }
      question.backing.removeProperty("quizId");
      return AppResponse.ok(
          body: question.backing.contents, message: "Get question ok");
    } catch (error) {
      return AppResponse.serverError(error, message: "Get question error");
    }
  }

  @Operation.get()
  Future<Response> getQuestions(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.query("quizId") int quizId) async {
    try {
      final qGetQuestions = Query<Question>(managedContext)
        ..where((x) => x.quizId).equalTo(quizId);
      final List<Question> questions = await qGetQuestions.fetch();
      if (questions.isEmpty) {
        return Response.notFound();
      }
      return Response.ok(questions);
    } catch (error) {
      return AppResponse.serverError(error,
          message: "Get questions list error");
    }
  }

  @Operation.delete("id")
  Future<Response> deleteQuiz(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id) async {
    try {
      final question = await managedContext.fetchObjectWithID<Question>(id);
      if (question == null) {
        return AppResponse.ok(message: "Quiz not found");
      }
      final qDeleteQuestion = Query<Question>(managedContext)
        ..where((x) => x.id).equalTo(id);
      await qDeleteQuestion.delete();
      return AppResponse.ok(message: "Delete question ok");
    } catch (error) {
      return AppResponse.serverError(error, message: "Get question error");
    }
  }
}
