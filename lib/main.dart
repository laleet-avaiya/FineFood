import 'dart:collection';

import 'package:finefood/screen/payment/PaymentScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'models/Order.dart';
import 'models/User.dart';
import 'models/FoodProduct.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fine Food',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Fine Food'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _total = 0;
  int user_id = 1;

  final myController = TextEditingController();
  final name = "Name";
  var retrievedName;

  final fb = FirebaseDatabase.instance;
  final List<Order> items = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
      _total = _total + 10;
    });
  }

  void _placeOrder() {
    final ref = fb.reference();

    var user = new User(
        "laleet",
        "B-203, Tapi Avenue, Near Causway, Katargam, Surat-395004.",
        "+917359324923");
    var foodProduct = new FoodProduct("Veg Puff", "Crpsy", "Rs.10");
    var order = new Order(user, foodProduct, _counter, _total, true);
    var rng = new Random();
    ref
        .child("orders")
        .child(("user_" + user_id.toString()))
        .push()
        .set(order.toJson());

    Fluttertoast.showToast(
        msg: "Order Placed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
    _clearCart();

    getOrderData(ref);
  }

  void getOrderData(ref) async {
    var user = new User(
        "laleet",
        "B-203, Tapi Avenue, Near Causway, Katargam, Surat-395004.",
        "+917359324923");
    var foodProduct = new FoodProduct("Veg Puff", "Crpsy", "Rs.10");
    ref
        .child("orders")
        .child(("user_" + user_id.toString()))
        .once()
        .then((DataSnapshot data) {
      Map<dynamic, dynamic> fridgesDs = data.value;

      fridgesDs.forEach((key, value) {
        print(value["totalAmount"]);
        print(value["ordered_on"]);
        print(value["payment"]);
        print(value["quntity"]);
        print("");
        items.add(new Order(user, foodProduct, value["quntity"],
            value["totalAmount"], value["payment"]));
        _clearCart();
      });
    });
  }

  void _clearCart() {
    setState(() {
      _counter = 0;
      _total = 0;
    });
  }

  void _removeItem() {
    setState(() {
      _counter--;
      _total = _total - 10;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("\n"),
                  Card(
                    margin: EdgeInsets.all(5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.network(
                                'https://www.litehousefoods.com/sites/default/files/styles/recipe_image/public/fetacheesepuff_176389079-min.jpg?itok=fUPssQoW',
                                fit: BoxFit.fitWidth,
                                width: 80.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              margin: EdgeInsets.all(25),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Veg Puff',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    )),
                                Text(
                                  " Rs. 10",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                            Text("    "),
                            new OutlineButton(
                                child: new Text("ADD"),
                                onPressed: _incrementCounter,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0))),
                          ],
                        )
                      ],
                    ),
                  ),
                  Text("\n"),
                  (_counter > 0)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(""),
                                Text(
                                  "\nOrder Details:\n",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),

                                Text(
                                    " Puff \t\t\t\t\t\t\t\t\t $_counter \t\t\t\t\t\t\t\t\t\t Rs. 10 * $_counter = $_total \n"),
                                Text("\n"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new OutlineButton(
                                        child: new Text("Clear Cart"),
                                        onPressed: _clearCart,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    10.0))),
                                    Text("  "),
                                    new OutlineButton(
                                        child: new Text("Remove Item"),
                                        onPressed: _removeItem,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    10.0))),
                                    Text("  "),
                                    new OutlineButton(
                                        child: new Text("Place Order"),
                                        onPressed: () {
//                                          _placeOrder(ref);
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentScreen(amount: _total.toString(),callback:_placeOrder)));
                                        },
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    10.0))),
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      : Text(""),
                  (items.length > 1)
                      ? Text(items[0].foodProduct.name.toString())
                      : Text("A"),
                  (items.length > 1)
                      ? Text(items[0].quntity.toString())
                      : Text("A"),
                  (items.length > 1)
                      ? Text(items[0].totalAmount.toString())
                      : Text("A")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



