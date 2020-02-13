import 'package:epossa_app/animations/fade_animation.dart';
import 'package:epossa_app/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'navigation_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(102, 0, 204, 50),
      //backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          padding: EdgeInsets.all(30),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildFormTitle(),
                  SizedBox(
                    height: 30,
                  ),
                  _buildLoginInput(),
                  SizedBox(
                    height: 40,
                  ),
                  _buildLogin(context),
                  _buildSignIn(context),
                  SizedBox(
                    height: 10,
                  ),
                  _buildPasswordForgotten(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormTitle() {
    return FadeAnimation(
      1.2,
      Text(
        "Login",
        style: TextStyle(
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLoginInput() {
    return FadeAnimation(
      1.5,
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]))),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                    hintText: "Phone number"),
              ),
            ),
            Container(
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
                    hintText: "Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogin(BuildContext context) {
    return FadeAnimation(
      1.8,
      Container(
        //width: 120,
        //height: 50,
        padding: EdgeInsets.symmetric(vertical: 25),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () => _login(context),
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Text(
            "LOGIN",
            style: TextStyle(
                color: Color(0xFF527DAA),
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans'),
          ),
        ),
      ),
    );
  }


  Widget _buildSignIn(BuildContext context) {
    return FadeAnimation(
      2.1,
      GestureDetector(
        onTap: () => _signIn(context),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'Pas encore de compte? ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400),
            ),
            TextSpan(
              text: 'Créez un compte',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildPasswordForgotten(BuildContext context) {
    return FadeAnimation(
      2.4,
      GestureDetector(
        onTap: () => print("Password forgotten..."),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'Mot de passe oublié? ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400),
            )
          ]),
        ),
      ),
    );
  }

  _login(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NavigationPage()),
    );
  }

  _signIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }
}
