import 'dart:convert';

import 'package:appentus_app/helper/db.dart';
import 'package:appentus_app/logic/models/apidata.dart';
import 'package:appentus_app/logic/models/user.dart';
import 'package:http/http.dart' as http;

class Controller{

  Future<List<ApiData>> getDataFromAPI() async
  {
    List<ApiData> list;
    final response =
      await http.get(Uri.parse('https://picsum.photos/v2/list'));

    if (response.statusCode == 200)
    {
      var data = jsonDecode(response.body);
      data.forEach((e)
      {
        list.add(ApiData.fromJson(e));
        print(e);
      });
    }
    else
    {
      print('API call not successful');
    }
    return list;
  }


  Future<Map> login(User user) async
  {

    List<Map> list = await checkLogin(user.email, user.password);
    if(list.isEmpty)
    {
      return null;
    }
    else
      return list[0];
  }


  Future<int> saveDataInDB(User user) async
  {
    DB db = DB();
    db.createTableIfNotExists("user", "CREATE TABLE user(id INTEGER PRIMARY KEY, "
        "name varchar, "
        "email varchar, "
        "password varchar, "
        "number varchar, "
        "image varchar "
        ")");

    List<Map> list = await getDataList("email",user.email);
    if(list.isEmpty)
      {
        db.insert("user", user.toJson());
        return 1;
      }
    else
      return 0;

  }

  Future<List<Map>> getDataList(String fieldName, String value) async {
    DB db = DB();
    List<Map> list = await db
        .getRecords("SELECT * FROM user WHERE ${fieldName} = '${value}'");
    return list==null? []: list;
  }

  Future<List<Map>> checkLogin(String email, String password) async {
    DB db = DB();
    List<Map> list = await db
        .getRecords("SELECT * FROM user WHERE email='${email}' AND password='${password}'");
    return list==null? []: list;
  }
}