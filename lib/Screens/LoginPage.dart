import 'package:chatx/Routes/Routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Pavan'),
          const SizedBox(
            height: 50,
          ),
          Container(
              width: 300,
              child: TextField(
                controller: _email,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )),
          const SizedBox(
            height: 30,
          ),
          Container(
              width: 300,
              child: TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () async {
              UserCredential userCredential =
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _email.text,
                password: _password.text,
              );

              User? user = userCredential.user;

              if (user != null) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .set({
                  'uid': user.uid,
                  'email': _email.text,
                }, SetOptions(merge: true));

                Navigator.pushReplacementNamed(context, Routes.homePage);
                _email.clear();
                _password.clear();
              }
            },
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              width: 100,
              child: Text(
                'LogIn',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Don't hava account ?"),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.signIn);
                },
                child: const Text(
                  ' Sign In',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 1,
                width: 100,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              const SizedBox(width: 10),
              const Text(
                'OR',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 10),
              Container(
                height: 1,
                width: 100,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}
