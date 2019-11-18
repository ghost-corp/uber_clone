import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    var row = Row(
                children: <Widget>[
                  
                ],
              );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()
          {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white,),
        ),

        title: Text(
          "Payment"
        ),
        centerTitle: true,
      ),

      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.035,
                left: MediaQuery.of(context).size.height*0.02,
                bottom: MediaQuery.of(context).size.height*0.03
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Payment methods",
                    style: TextStyle(
                      color: Colors.grey
                    )
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height*0.03,
                    ),
                    child: GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.moneyBill,
                            color: Colors.green,
                            size: MediaQuery.of(context).size.height*0.0375,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 26),
                              child: Text(
                                "Cash",
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height*0.025
                                ),
                                ),
                            )
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height*0.04,
                    ),
                    child: Text(
                      "Add payment method",
                       style: TextStyle(
                         color: Colors.indigo
                       ),
                    ),
                  )
                ],
              ),
            ),

            Divider(
              color: Colors.grey,
            ),
            
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.03,
                left: MediaQuery.of(context).size.height*0.02,
                bottom: MediaQuery.of(context).size.height*0.03
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Trip profiles",
                    style: TextStyle(
                      color: Colors.grey
                    )
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height*0.03
                    ),
                    child: GestureDetector(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8
                              ),
                            child: Container(
                              height: MediaQuery.of(context).size.height*0.05,
                              width: MediaQuery.of(context).size.height*0.05,
                              child: Image.asset("images/individual.png")
                              ),
                          ),
                          
                          Padding(
                            padding: EdgeInsets.only(
                              top: 18,
                              left: 16
                              ),
                            child: Text("Personal"),
                          )
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height*0.03
                    ),
                    child: GestureDetector(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8
                              ),
                            child: Container(
                              height: MediaQuery.of(context).size.height*0.05,
                              width: MediaQuery.of(context).size.height*0.05,
                              child: Image.asset("images/briefcase.png")
                              ),
                          ),
                          
                          Padding(
                            padding: EdgeInsets.only(
                              top: 12,
                              left: 16
                              ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Ride for business",
                                  style: TextStyle(color: Colors.indigo)
                                ),
                                Text(
                                  "Enable business travel features",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Divider(
              color: Colors.grey,
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.03,
                left: MediaQuery.of(context).size.height*0.02
              ),
              child: Text(
                "Promotions",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.03,
                left: MediaQuery.of(context).size.height*0.02,
                bottom: MediaQuery.of(context).size.height*0.03
              ),
              child: Text(
                "Add promo code",
                style: TextStyle(color: Colors.indigo)
              ),
            ),

            Divider(
              color: Colors.grey,
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.03,
                left: MediaQuery.of(context).size.height*0.02
              ),
              child: Text(
                "Vouchers",
                style: TextStyle(color: Colors.grey)
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.03,
                left: MediaQuery.of(context).size.height*0.02
              ),
              child: GestureDetector(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.height*0.05,
                      height: MediaQuery.of(context).size.height*0.05,
                      child: Image.asset("images/voucher.png"),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height*0.02
                      ),
                      child: Text("Vouchers"),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}