import 'package:conduit_core/conduit_core.dart';

class Quiz extends ManagedObject<_Quiz> implements _Quiz {}

class _Quiz {
  @primaryKey
  int? id;
  int? userId;
  String? name;
  String? status;
}
