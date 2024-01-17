import 'package:data/controllers/app_question_controller.dart';
import 'package:data/controllers/app_quiz_controller.dart';
import 'package:data/controllers/app_token_controller.dart';
import 'package:data/utils/app_env.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_postgresql/conduit_postgresql.dart';

class AppService extends ApplicationChannel {
  late final ManagedContext managedContext;

  @override
  Future prepare() {
    final persistentStore = _initDatabase();
    managedContext = ManagedContext(
        ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    return super.prepare();
  }

  @override
  Controller get entryPoint => Router()
    ..route("quizs/[:id]")
        .link(() => AppTokenController())!
        .link(() => AppQuizController(managedContext))
    ..route("question/[:id]")
        .link(() => AppTokenController())!
        .link(() => AppQuestionController(managedContext));

  PostgreSQLPersistentStore _initDatabase() {
    return PostgreSQLPersistentStore(AppEnv.dbLogin, AppEnv.dbPassword,
        AppEnv.dbHost, int.tryParse(AppEnv.dbPort), AppEnv.dbName);
  }
}
