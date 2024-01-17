import 'dart:async';
import 'package:conduit_core/conduit_core.dart';


class Migration4 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_Question", SchemaColumn("quizId", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    