import 'dart:convert';

import 'package:appentus_app/helper/db.dart';
import 'package:appentus_app/logic/models/apidata.dart';
import 'package:appentus_app/logic/models/user.dart';
import 'package:http/http.dart' as http;

class Controller{

  Future<List<ApiData>> getDataFromAPI() async
  {
    List<ApiData> list=[];
    final response =
      await http.get(Uri.parse('https://picsum.photos/v2/list'));

    print("response.body: ${response.body}");
    print("response.statusCode: ${response.statusCode}");
    if (response.statusCode == 200)
    {
      var data = jsonDecode(response.body);
      print("data: $data");
      data.forEach((e)
      {
        list.add(ApiData.fromJson(e));
        print("e: $e");
      });
    }
    else
    {
      print('API call not successful');
    }
    print("LIST: $list");
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


  Future<int> signup(User user) async
  {
    DB db = DB();
    db.createTableIfNotExists("user_master", "CREATE TABLE user(id INTEGER PRIMARY KEY, "
        "name varchar, "
        "email varchar, "
        "password varchar, "
        "number varchar, "
        "image varchar "
        ")");

    List<Map> list = await getDataList(user.email);
    if(list.isEmpty)
    {
      db.insertDataInDB("user_master", user.toJson());
      return 1;
    }
    else
      return 0;

  }

  Future<List<Map>> getDataList(String value) async {
    DB db = DB();
    List<Map> list = await db.getRecordsFromDB("SELECT * FROM user_master WHERE user = '$value'");
    return list==null? []: list;
  }

  Future<List<Map>> checkLogin(String email, String password) async {
    DB db = DB();
    List<Map> list = await db
        .getRecordsFromDB("SELECT * FROM user_master WHERE email='$email' AND password='$password'");
    return list==null? []: list;
  }
}