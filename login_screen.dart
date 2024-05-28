import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_up_screen.dart';
import 'HomePage.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "MindfulMotion",
            style: GoogleFonts.fraunces(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: emailController,
            decoration: InputDecoration(
                labelText: "Email",
                labelStyle: GoogleFonts.cormorant(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: Colors.blue,
                    width: 2.0,
                  )
                ),
            ),
          ),
          SizedBox(height: 30),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: GoogleFonts.cormorant(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  )
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
              width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  Navigator.of(context).pushReplacement( // Use pushReplacement to prevent going back to the login screen
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to log in: ${e.message}")),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                overlayColor: MaterialStateProperty.all<Color>(Colors.black12),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Button border radius
                    side: BorderSide.none, // No border
                  ),
                ),// Button padding
              ),
              child: Text("Login"),
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
            child: Text("Don't have an account? Sign up"),
          ),
        ],
      ),
    );
  }
}
