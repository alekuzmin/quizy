import 'dart:async';
import 'package:conduit_core/conduit_core.dart';


class Migration5 extends Migration { 
  @override
  Future upgrade() async {
   		database.deleteColumn("_Question", "quiz");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    