import 'dart:async';
import 'package:conduit_core/conduit_core.dart';


class Migration3 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_Quiz", SchemaColumn("userId", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
		database.deleteColumn("_Quiz", "login");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    