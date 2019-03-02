/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';

import 'src/strings.dart' show Strings;

////////////////////////////////////////////////////////////////////////////////

class LoginScreen extends StatelessWidget {
  final String gameURL;

  LoginScreen({Key key, this.gameURL}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24, right: 24),
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: CircleAvatar(
                child: Image.asset("assets/icon.png"),
                radius: 48,
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(height: 48),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Your email",
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
              ),
              //initialValue: "", // TODO
              autofocus: false,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Your password",
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
              ),
              initialValue: "", // always empty
              autofocus: false,
              obscureText: true,
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: RaisedButton(
                child: Text("Log in", style: TextStyle(color: Colors.white)),
                onPressed: () {}, // TODO
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.all(12),
                color: Colors.redAccent,
              ),
            ),
            FlatButton(
              child: Text(
                "Forgot your password?",
                style: TextStyle(color: Colors.white54),
              ),
              onPressed: () {}, // TODO
            ),
          ],
        ),
      ),
    );
  }
}
