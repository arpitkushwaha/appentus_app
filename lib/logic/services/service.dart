import 'dart:convert';
import 'package:appentus_app/logic/models/apidata.dart';
import 'package:http/http.dart' as http;

class Service{

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










}