import 'package:flutter/material.dart';
import 'package:uber_clone/global/screen_size.dart';

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            expandedHeight: 100.0,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 20,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              title: Text(
                  'Edit Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: height(context) * 0.1,
                  width: height(context) * 0.1,
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: Image.asset("images/index.png"),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          height: 30, width: 30,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(24)
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(
                  left: 12, top: 18, bottom: 8
                ),
                child: Text(
                  'First Name',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 12, bottom: 12
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: 'Emmanuel',
                    hintStyle: TextStyle(
                      fontSize: 18
                    )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 12, top: 18, bottom: 8
                ),
                child: Text(
                  ' Surname',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 12, bottom: 12
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: 'Tuksa',
                      hintStyle: TextStyle(
                          fontSize: 18
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 12, top: 18, bottom: 8
                ),
                child: Text(
                  'Phone Number',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 12, bottom: 12, right: 12
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: width(context) * 0.6,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 25, width: 25,
                            child: Image.asset(
                              'images/nigeria.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            width: width(context) * 0.5,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  hintText: '09026794379',
                                  hintStyle: TextStyle(
                                      fontSize: 18
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      'Verified',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 12, bottom: 12, right: 12
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: width(context) * 0.6,
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                fontSize: 18
                            )
                        ),
                      ),
                    ),

                    Text(
                      'Unverified',
                      style: TextStyle(
                          color: Colors.red.shade800,
                          fontSize: 18
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 12, top: 18, bottom: 8
                ),
                child: Text(
                  'Password',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 12
                ),
                child: TextFormField(
                  initialValue: 'Emmanuel',
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: '',
                      hintStyle: TextStyle(
                          fontSize: 18
                      )
                  ),
                  obscureText: true,
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
