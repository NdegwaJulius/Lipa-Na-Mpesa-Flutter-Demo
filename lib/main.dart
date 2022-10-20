import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart'; //Import the plugin

//import './global_keys.dart';

void main() {
  /*Set Consumer credentials before initializing the payment.
    You can get  them from https://developer.safaricom.co.ke/ by creating
    an account and an app.
     */
  MpesaFlutterPlugin.setConsumerKey('Fm2v0oUyaka8xx5g4346Hmh2b6tWCHcu');
  MpesaFlutterPlugin.setConsumerSecret('vVbvxAzuvMULEiTC');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> startCheckout(
      {required String userPhone, required double amount}) async {
    //Preferably expect 'dynamic', response type varies a lot!
    dynamic transactionInitialisation;
    //Better wrap in a try-catch for lots of reasons.
    try {
      //Run it
      transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: amount,
          partyA: userPhone,
          partyB: "174379",
          callBackURL:
              Uri(scheme: "https", host: "1234.1234.co.ke", path: "/1234.php"),
          accountReference: "shoe",
          phoneNumber: userPhone,
          baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
          transactionDesc: "purchase",
          passKey:
              'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919');

      print("TRANSACTION RESULT: " + transactionInitialisation.toString());

      //You can check sample parsing here -> https://github.com/keronei/Mobile-Demos/blob/mpesa-flutter-client-app/lib/main.dart

      /*Update your db with the init data received from initialization response,
      * Remaining bit will be sent via callback url*/
      return transactionInitialisation;
    } catch (e) {
      //For now, console might be useful
      print("CAUGHT EXCEPTION: " + e.toString());

      /*
      Other 'throws':
      1. Amount being less than 1.0
      2. Consumer Secret/Key not set
      3. Phone number is less than 9 characters
      4. Phone number not in international format(should start with 254 for KE)
       */
    }
  }

  List<Map<String, dynamic>> itemsOnSale = [
    {
      "image": "image/shoe.jpg",
      "itemName": "Breathable Oxford Casual Shoes",
      "price": 1.0
    }
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orangeAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mpesa Payment plugin'),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.orange,
              elevation: 4.0,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  //color: Colors.blueAccent
                ),
                height: MediaQuery.of(context).size.height * 0.35,
                //color: Colors.brown,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Image.asset(
                        itemsOnSale[index]["image"],
                        fit: BoxFit.cover,
                      ),
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.95,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Text(
                            itemsOnSale[index]["itemName"],
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                          ),
                        ),
                        Text(
                          "Ksh. " + itemsOnSale[index]["price"].toString(),
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              startCheckout(
                                  userPhone: "254725581169",
                                  amount: itemsOnSale[index]["price"]);
                            },
                            child: Text("Checkout"))
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: itemsOnSale.length,
        ),
      ),
    );
  }
}
