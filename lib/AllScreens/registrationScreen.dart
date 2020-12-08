import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/AllScreens/LoginScreen.dart';
import 'package:flutter_myapp/AllScreens/mainscreen.dart';
import 'package:flutter_myapp/AllWidget/progressDialog.dart';
import 'package:flutter_myapp/main.dart';
import 'package:fluttertoast/fluttertoast.dart';


class RegistrationScreen extends StatelessWidget
{
  static const String IdScreen = "Register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 25.0,),
          Image(
            image: AssetImage("images/logo.png"),
            width: 390.0,
            height: 250.0,
            alignment: Alignment.center,
          ),

          SizedBox(height: 1.0,),
          Text(
            "Register as a Rider",
            style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
            textAlign: TextAlign.center,
          ),

          Padding(
            padding:EdgeInsets.all(20.0),
            child: Column(
              children: [

                SizedBox(height: 1.0,),
                TextField(
                  controller: nameTextEditingController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),

                SizedBox(height: 1.0,),
                TextField(
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),

                SizedBox(height: 1.0,),
                TextField(
                  controller: phoneTextEditingController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Mobile NO:",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),

                SizedBox(height: 1.0,),
                TextField(
                  controller: passwordTextEditingController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.0),
                ),

                SizedBox(height: 1.0,),
                RaisedButton(
                  color: Colors.yellow,
                  textColor: Colors.white,
                  onPressed: () {  },
                  child: Container(
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Create Account",
                        style: TextStyle(fontSize: 10.0, fontFamily: "Brand Bold"),
                      ),
                    ),
                  ),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(24.0),
                  ),
                  onLongPress: ()
                  {
                    if(nameTextEditingController.text.length < 3)
                      {
                        displayToastMessage("Name must be atlaest three characters", context);
                      }
                    else if(!emailTextEditingController.text.contains("@"))
                      {
                        displayToastMessage("Email not valid", context);
                      }
                    else if(phoneTextEditingController.text.isEmpty)
                      {
                      displayToastMessage("Phone Number is mandatory", context);
                      }
                    else if(passwordTextEditingController.text.length < 6)
                      {
                      displayToastMessage("Password must be at least 6 characters", context);
                      }
                    else
                      {
                      registerNewUser(context);
                      }
                  },
                ),

              ],
            ),
          ),

          FlatButton(
            onPressed: ()
            {
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.IdScreen, (route) => false);
            },
            child: Text(" Already have an Account? Login here. "),
          ),

        ],
      ),

    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Registerin...., Please wait..",);
        }
    );
    // ignore: deprecated_member_use
    final User firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(email: emailTextEditingController.text, password: passwordTextEditingController.text).catchError((errMsg){
      Navigator.pop(context);
          displayToastMessage("Error: "+ errMsg.toString(), context);
    })).user;

    if (firebaseUser != null)
      {


        Map userDataMap = {
          "name": nameTextEditingController.text.trim(),
          "email": emailTextEditingController.text.trim(),
          "phone": phoneTextEditingController.text.trim(),

        };

        usersRef.child(firebaseUser.uid).set(userDataMap);
        displayToastMessage("Your account has been created", context);

        Navigator.pushNamedAndRemoveUntil(context, MainScreen.IdScreen, (route) => false);

      }
    else
      {
        Navigator.pop(context);
        displayToastMessage("New user account has not been created", context);
      }
  }
  displayToastMessage(String message, BuildContext context)
  {
    Fluttertoast.showToast(msg: message);
  }
}
