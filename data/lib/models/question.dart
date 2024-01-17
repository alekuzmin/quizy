import 'package:conduit_core/conduit_core.dart';

class Question extends ManagedObject<_Question> implements _Question {}

class _Question {
  @primaryKey
  int? id;
  int? quizId;
  String? text;
}
