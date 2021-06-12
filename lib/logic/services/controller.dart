import 'package:appentus_app/helper/db.dart';
import 'package:appentus_app/logic/models/user.dart';

class Controller{

  Future<List<Map>> checkIfUserExistsOrNot(String email, String password) async {
    DB db = DB();
    List<Map> list = await db
        .getRecordsFromDB("SELECT * FROM user_master WHERE email='$email' AND password='$password'");
    return list==null? []: list;
  }

  Future<Map> login(User user) async
  {
    List<Map> list = await checkIfUserExistsOrNot(user.email, user.password);
    if(list.isEmpty)
    {
      return null;
    }
    else
      return list[0];
  }

  Future<List<Map>> getUser(String value) async {
    DB db = DB();
    List<Map> list = await db.getRecordsFromDB("SELECT * FROM user_master WHERE email = '$value'");
    return list==null? []: list;
  }


  Future<int> signup(User user) async
  {
    DB db = DB();
    List<Map> list = await getUser(user.email);
    if(list.isEmpty)
    {
      db.insertDataInDB("user_master", user.toJson());
      return 1;
    }
    else
      return 0;

  }

}