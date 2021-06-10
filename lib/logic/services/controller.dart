import 'dart:convert';

import 'package:appentus_app/logic/models/apidata.dart';
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

  }
}