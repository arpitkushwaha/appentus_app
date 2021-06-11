import 'package:appentus_app/logic/services/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appentus_app/logic/models/apidata.dart';

class SecondView extends StatefulWidget {
  const SecondView({Key key}) : super(key: key);

  @override
  _SecondViewState createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView> {
  Controller controller = Controller();
  Future<List<ApiData>> list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = controller.getDataFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: FutureBuilder<List<ApiData>>(
        future: list,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return Text("${snapshot.data[index].author}");
                });
          } else if (snapshot.hasError) {
            return Text("Error");
          }
          return Text("Loading...");
        },
      ),
    );
  }
}
