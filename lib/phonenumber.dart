import 'package:flutter/material.dart';

class PhoneNumber extends StatefulWidget {
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: MediaQuery.of(context).size.height*0.09,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Text('By continuing you may receive an SMS for'),
              ),
              Text('verification. Message and data rates may'),
              Text('apply.')
            ],
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 20, left: 8),
              child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black,),
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  }
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, top: 12),
              child: Text('Please enter your mobile number',
                style: TextStyle(
                fontSize: 18,
              ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 30, left: 20),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.065,
                      height: MediaQuery.of(context).size.width*0.065,
                      child: Image.asset("images/nigeria.png"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
                    child: Text(
                      "+234",
                      style:
                      TextStyle(fontSize: MediaQuery.of(context).size.width*0.046, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.025),
                    child: GestureDetector(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneNumber()));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.6,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: MediaQuery.of(context).size.width*0.046
                            ),
                            hintText: '09012345678'
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
