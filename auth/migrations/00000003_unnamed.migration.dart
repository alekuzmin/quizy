import 'dart:async';
import 'package:conduit_core/conduit_core.dart';


class Migration3 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_User", SchemaColumn("lastName", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: false));
		database.addColumn("_User", SchemaColumn("firstName", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: false));
		database.addColumn("_User", SchemaColumn("middleName", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: false));
		database.addColumn("_User", SchemaColumn("role", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: true, isNullable: false, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    