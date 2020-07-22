import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/api/search_api.dart';
import 'package:uber_clone/global/screen_size.dart';
import 'package:uber_clone/models/auth_model.dart';

class SearchDestination extends StatefulWidget {
  @override
  _SearchDestinationState createState() => _SearchDestinationState();
}

class _SearchDestinationState extends State<SearchDestination> {

  bool doneButton = false;
  List<Place> searchResult = new List();
  Place finalPlace;
  TextEditingController controller = TextEditingController();

  void getSearchResult(BuildContext context, String searchKey) {
    SearchApi.searchPlace(context, searchKey).then((result) {
      setState(() {
        searchResult = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: height(context),
          width: width(context),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Container(
              padding: EdgeInsets.only(
                bottom: 3
              ),
              width: width(context) * 0.8,
                height: 40,
                child: TextField(
                  controller: controller,
                  onTap: () {
                    setState(() {
                      doneButton = false;
                    });
                  },
                  onChanged: (val) {
                    getSearchResult(context, val);
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey[100])),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey[100])),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey[100]))
                  ),
                )
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: ListView(
            children: <Widget>[

              searchResult == null ?
                  Container() :
                  searchResult.length > 0
              ? Container(
                    height: height(context) * 0.4,
                    width: width(context),
                    child: ListView.builder(
                      itemCount: searchResult.length,
                      itemBuilder: (context, count) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              finalPlace = searchResult[0];
                              doneButton = true;
                            });
                            controller.clear();
                            controller.text = finalPlace.name;
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  searchResult[count].formattedAddress
                                ),
                                subtitle: Text(
                                  searchResult[count].name
                                ),
                                leading: Icon(
                                  Icons.add_location
                                ),
                              ),
                              Divider()
                            ],
                          ),
                        );
                      },
                    ),
                  ) : Container(),

              ListTile(
                leading: Icon(
                  Icons.gps_fixed,
                  size: 30,
                ),
                title: Text(
                  'Set location on map'
                ),
                onTap: () {
                  Navigator.of(context).pushNamed("search_screen");
                },
              ),
              Divider()
            ],
          ),
        ),
        doneButton ? Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Container(
              width: width(context) * 0.8,
              child: FlatButton(
                child: Text(
                  'DONE',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
                color: Colors.black,
                onPressed: () async {
                  try {
                    await Provider.of<AuthModel>(context, listen: false)
                        .saveAddress(finalPlace);
                    Navigator.of(context).popUntil(
                      ModalRoute.withName("choose_saved")
                    );
                  }catch(e) {
                    print(e);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Unable to save!"))
                    );
                  }
                },
              ),
            ),
          ),
        ) : Container()
      ],
    );
  }
}
