import 'package:firebase_auth/firebase_auth.dart';
import 'HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  static FirebaseUser user;
  String _code;
  String signature;





  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          print(phone);
          AuthResult result = await _auth.signInWithCredential(credential);

          user = result.user;
          print(user.toString());
          if (user != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(user: user)));
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          print(exception.message);
          print(phone);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Enter Verification code."),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
//                      PinFieldAutoFill(
//                        decoration: UnderlineDecoration(
//                            textStyle: TextStyle(fontSize: 20, color: Colors.black)),
//                        currentCode: _code,
//                      ),
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);

                        AuthResult result =
                            await _auth.signInWithCredential(credential);

                        FirebaseUser user = result.user;

                        if (user != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen(user: user)));
                        } else {
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Fine Food",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 36,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[200])),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[300])),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: "Mobile Number",
                        ),
                        keyboardType: TextInputType.number,
                        controller: _phoneController,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        child: FlatButton(
                          child: Text("LOGIN"),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(16),
                          onPressed: () async {
                            final phone = _phoneController.text.trim();
//                            signature = await SmsAutoFill().getAppSignature;
                            loginUser(phone, context);
                          },
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}
