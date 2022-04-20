import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property_valuation/blocks/application_block.dart';
import 'package:property_valuation/ui/dashboard.dart';
import 'package:property_valuation/ui/forgot_pass.dart';
import 'package:provider/provider.dart';

import 'firebase/flutter-fire.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Property Evaluation'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  var title;

  MyHomePage({Key? key, required this.title}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    var page;
    setState(() {
      if (FirebaseAuth.instance.currentUser != null) {
        Timer(
          const Duration(seconds: 0),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
          ),
        );
      }
    });
  }

  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Property Evaluation'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 20),
                child: SizedBox(
                  width: 470,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      hintText: 'Enter your email',
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 20),
                child: SizedBox(
                  width: 470,
                  child: TextField(
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 18.0),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassword()));
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 15.0, color: Colors.blue),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    // final snackBar = SnackBar(content: Text('Bitchass Bullshit'));
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    //if valid email
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email);
                    if (email.isEmpty) {
                      final snackBar = const SnackBar(
                          content: const Text('Please enter a valid email ID'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                    if (!emailValid) {
                      final snackBar = const SnackBar(
                          content: Text('Please enter a valid email ID'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                    if (password.isEmpty) {
                      final snackBar = const SnackBar(
                          content: const Text('Please enter a valid password'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                    //if password length less than 6
                    if (password.length < 6) {
                      final snackBar = const SnackBar(
                          content:
                              Text('Length of password must be minimum 6'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                    //teach me how to remove that
                    showLoaderDialog(context);
                    print(email + password);
                    bool shouldNavigate = await signIn(email, password);
                    if (shouldNavigate) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Dashboard(),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                      return showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Wrong username or password"),
                          actions: <Widget>[
                            // ignore: deprecated_member_use
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text("Ok"))
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 20, fontFamily: "BonaNova"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
        Container(
          margin: const EdgeInsets.only(left: 7),
          child: const Text("   Please wait..."),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
