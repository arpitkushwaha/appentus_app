import 'package:appentus_app/logic/services/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appentus_app/logic/models/apidata.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../logic/models/apidata.dart';

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

      // future builder and grid view to display the data fetching from api.
      body: FutureBuilder<List<ApiData>>(
        future: list,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StaggeredGridView.countBuilder(
              itemCount: snapshot.data.length,
              crossAxisCount: 3,
              itemBuilder: (context, index) {
                return Card(
                    child: Column(
                      children: [
                        Text(
                          snapshot.data[index].author,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          // child: Image.network('${snapshot.data[index].downloadUrl}')
                          child: CachedNetworkImage(
                            imageUrl: '${snapshot.data[index].downloadUrl}',
                          ),
                        ),
                      ],
                    ),
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ));
              },
              staggeredTileBuilder: (index) =>StaggeredTile.fit(1),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error"));
          }
          return Center(child:CircularProgressIndicator());
        },
      ),
    );
  }
}