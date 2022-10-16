import 'package:barcode_scanner/MainPage.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/images/qr_code.png')),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Username', hintText: 'Enter your username'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Password', hintText: 'Enter your password'),
              ),
            ),
            // FlatButton(
            //   onPressed: () {
            //     //TODO FORGOT PASSWORD SCREEN GOES HERE
            //   },
            //   child: Text(
            //     'Forgot Password',
            //     style: TextStyle(color: Colors.blue, fontSize: 15),
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 50,
              width: 250,
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyHomePage(title: 'Flutter Barcode Demo'),
                      ));
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            // SizedBox(
            //   height: 130,
            // ),
            // Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}
