import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/AllScreens/mainscreen.dart';
import 'package:flutter_myapp/AllScreens/registrationScreen.dart';
import 'package:flutter_myapp/AllWidget/progressDialog.dart';
import 'package:flutter_myapp/main.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginScreen extends StatelessWidget
{
  static const String IdScreen = "Login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 35.0,),
          Image(
            image: AssetImage("images/logo.png"),
            width: 390.0,
            height: 250.0,
            alignment: Alignment.center,
          ),
          
          SizedBox(height: 1.0,),
          Text(
            "Login",
          style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
          textAlign: TextAlign.center,
          ),
          
          Padding(
            padding:EdgeInsets.all(20.0),
            child: Column(
              children: [
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
                        "Login",
                        style: TextStyle(fontSize: 10.0, fontFamily: "Brand Bold"),
                      ),
                    ),
                  ),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(24.0),
                  ),
                  onLongPress: ()
                  {
                    if(!emailTextEditingController.text.contains("@"))
                    {
                      displayToastMessage("Email not valid", context);
                    }
                    else if(passwordTextEditingController.text.isEmpty)
                    {
                      displayToastMessage("Password is mandatory", context);
                    }
                    else
                      {
                        loginAndAuthenticateUser(context);
                      }



                  },
                ),
                
              ],
            ),
          ),
          
          FlatButton(
            onPressed: ()
            {
              Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.IdScreen, (route) => false);
            }, 
            child: Text(" Don't have an Account? Register here. "),
          )
          
        ],
      ),
      
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)
        {
          return ProgressDialog(message: "Authenticating, Please wait..",);
        }
    );



    final User firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text)
        .catchError((errMsg){
          Navigator.pop(context);
      displayToastMessage("Error: "+ errMsg.toString(), context);
    })).user;
    if (firebaseUser != null)
    {

      usersRef.child(firebaseUser.uid).once().then( (DataSnapshot snap){
        if(snap.value !=null)
          {
            Navigator.pushNamedAndRemoveUntil(context, MainScreen.IdScreen, (route) => false);
            displayToastMessage("Your are logged in", context);
          }
        else
          {
            Navigator.pop(context);
            _firebaseAuth.signOut();
            displayToastMessage("No record exists", context);
          }
      });




    }
    else
    {
      Navigator.pop(context);
      displayToastMessage("Error occured", context);
    }
  }

   displayToastMessage(String message, BuildContext context)
   {
     Fluttertoast.showToast(msg: message);
   }
}
