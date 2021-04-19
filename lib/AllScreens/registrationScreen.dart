import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainScreen.dart';
import 'package:rider_app/Allwidgets/progressDialog.dart';
import 'package:rider_app/main.dart';


class RegistrationScreen extends StatelessWidget {
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),

              SizedBox(height: 15.0,),
              Text(
                "Sign Up as Rider",
                style: TextStyle(fontSize: 24.0,fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    TextField(
                      controller: emailTextEditController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    TextField(
                      controller: phoneTextEditController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 10.0,),
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: (){
                        if(nameTextEditController.text.length < 3){
                          displayToastMessage("Name must be at least 3 characters", context);
                        }else if(!emailTextEditController.text.contains("@")){
                          displayToastMessage("Email address is not valid", context);
                        }else if(phoneTextEditController.text.isEmpty){
                          displayToastMessage("Phone Number is mandatory", context);
                        }else if(passwordTextEditController.text.length < 6){
                          displayToastMessage("password must be 6 characters", context);
                        }else{
                          registerNewUser(context);
                        }
                      },
                    ),

                  ],
                ),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Already Have Account? Login Here",

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async
  {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Registration, Please wait",);
        }
    );
    final User firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditController.text,
        password: passwordTextEditController.text)
        .catchError((errorMsg){
      Navigator.pop(context);
      displayToastMessage("Error: " +errorMsg.toString(), context);
    })).user;

    if(firebaseUser != null){
      // save user info to database
      usersRef.child(firebaseUser.uid);

      Map usersDataMap = {
        "name":nameTextEditController.text.trim(),
        "email": emailTextEditController.text.trim(),
        "phone": phoneTextEditController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(usersDataMap);
      displayToastMessage("Congratulations, your account has been created", context);
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

    }else{
      Navigator.pop(context);
      displayToastMessage("User Account not created", context);

    }
  }
}
displayToastMessage(String message, BuildContext context)
{
  Fluttertoast.showToast(msg: message);
}