import 'package:flutter/material.dart';
import 'home.dart';

class Discount extends StatefulWidget {
  @override
  _DiscountState createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height*0.175,
                  width: MediaQuery.of(context).size.height*0.175,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(60.0)),
                      child: Image.asset("images/newsletter.png"),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.1,
                  left: MediaQuery.of(context).size.height*0.015
              ),
              child: Text(
                "Receive our discounts and news",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height*0.026,
                    color: Colors.black
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.03,
                left: MediaQuery.of(context).size.width*0.03,
                right: MediaQuery.of(context).size.width*0.05,
              ),
              child: Text(
                'We would like to share special offers, recommendations and product updates. TO opt out of promotional messages, '
                + 'you can click the link below or manage your privacy settings in the app at any time.',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.height*0.02
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.03,
                  left: MediaQuery.of(context).size.width*0.03
              ),
              child: GestureDetector(
                child: Text(
                  'Unsubscribe',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontSize: MediaQuery.of(context).size.height*0.021
                  ),
                ),
              ),
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
        },
      ),
    );
  }
}
