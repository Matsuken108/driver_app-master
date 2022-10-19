import 'package:drivers_app/AllScreens/carInfoScreen.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:drivers_app/AllScreens/mainscreen.dart';
import 'package:drivers_app/AllWidgets/progressDialog.dart';
import 'package:drivers_app/main.dart';
import 'package:drivers_app/AllScreens/loginScreen.dart';

class RegisterationScreen extends StatelessWidget {
  static const String idScreen = "register";

  TextEditingController nameTextEditController = TextEditingController();
  TextEditingController emailTextEditController = TextEditingController();
  TextEditingController phoneTextEditController = TextEditingController();
  TextEditingController passwordTextEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 65.0,
              ),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 1.0,
              ),
              Text(
                "Register as a Driver",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: nameTextEditController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle:
                            TextStyle(fontSize: 10.0, fontFamily: "Brand Bold"),
                      ),
                      style: TextStyle(fontSize: 14.0, fontFamily: "Brand Bold"),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTextEditController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle:
                            TextStyle(fontSize: 10.0, fontFamily: "Brand Bold"),
                      ),
                      style: TextStyle(fontSize: 14.0,fontFamily: "Brand Bold"),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: phoneTextEditController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle:
                            TextStyle(fontSize: 10.0, fontFamily: "Brand Bold"),
                      ),
                      style: TextStyle(fontSize: 14.0, fontFamily: "Brand Bold"),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTextEditController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle:
                            TextStyle(fontSize: 10.0, fontFamily: "Brand Bold"),
                      ),
                      style: TextStyle(fontSize: 14.0,fontFamily: "Brand Bold"),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: () {
                        if (nameTextEditController.text.length < 4) {
                          displayToastMessage(
                              "Name must be at least 3 characters", context);
                        } else if (!emailTextEditController.text
                            .contains("@")) {
                          displayToastMessage(
                              "Email address is not Valid", context);
                        } else if (phoneTextEditController.text.isEmpty) {
                          displayToastMessage(
                              "Phone Number is mandatory", context);
                        } else if (passwordTextEditController.text.length < 6) {
                          displayToastMessage(
                              "Password must be at least 6 Characters",
                              context);
                        } else {
                          registerNewUser(context);
                        }
                      },
                    ),
                  ],
                ),
              ),

              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Already have an Account? Login Here",
                  style: TextStyle(fontFamily: "Brand Bold"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context){
      return ProgressDialog(message: "Registering, Please wait...",);
    }
    );

    final User firebaseUser =
        (await _firebaseAuth.createUserWithEmailAndPassword(
                email: emailTextEditController.text,
                password: passwordTextEditController.text).catchError((errMsg){
          Navigator.pop(context);
                  displayToastMessage("Error: " + errMsg.toString(), context);
        })).user;

    if (firebaseUser != null) {
      Map userDataMap = {
        "name": nameTextEditController.text.trim(),
        "email": emailTextEditController.text.trim(),
        "phone": phoneTextEditController.text.trim(),
      };
      
      driversRef.child(firebaseUser.uid).set(userDataMap);
      currentfirebaseUser = firebaseUser;
      displayToastMessage("Congratulations.your account has been created.", context);

      Navigator.pushNamed(context, CarInfoScreen.idScreen);

    } else {
      Navigator.pop(context);
      displayToastMessage("user has not been Created.", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
