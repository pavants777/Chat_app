import 'package:chatx/Routes/Routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _userName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Container(
              width: 300,
              child: TextField(
                controller: _userName,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  prefixIcon: Icon(Icons.person),
                  hintText: 'UserName',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 300,
              child: TextField(
                controller: _email,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 300,
              child: TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.vpn_key),
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: _email.text,
                    password: _password.text,
                  );

                  User? user = userCredential.user;

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .set({
                    'uid': user.uid,
                    'email': _email.text,
                    'userName': _userName.text,
                  });

                  Navigator.pushReplacementNamed(context, Routes.homePage);
                  _email.clear();
                  _password.clear();
                } catch (error) {
                  String errorMessage = error.toString();
                  print("Error during sign-up: $errorMessage");
                  // Handle the error (e.g., display an error message)
                }
              },
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                width: 100,
                child: Text(
                  'SignUp',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Already have an Account ?"),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    ' Log In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 1,
                  width: 100,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                SizedBox(width: 10),
                Text(
                  'OR',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                Container(
                  height: 1,
                  width: 100,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
