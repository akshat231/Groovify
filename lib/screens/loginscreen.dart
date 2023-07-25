import 'package:flutter/material.dart';
import 'package:groovify/jiosaavn.dart';
import './registerscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class loginScreen extends StatefulWidget {
  static const String id = "loginscreen";

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  String uname = '';
  String pword = '';
  bool show = true;
  bool is_loading = false;
  Color Userlabel = Colors.white60;
  Color Passlabel = Colors.white60;
  Color changecoloruser() {
    Userlabel = Colors.white60;
    return Userlabel;
  }

  Color changecolorpass() {
    Passlabel = Colors.white60;
    return Passlabel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/bgimage.jpg"),
              fit: BoxFit.cover,
              opacity: 0.7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Sign-In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: null,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onChanged: (value) {
                          uname = value;
                        },
                        onTap: () {
                          setState(() {
                            Userlabel = Colors.white60;
                          });
                        },
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          constraints: BoxConstraints(maxWidth: 220),
                          labelText: 'Username/Email',
                          labelStyle: TextStyle(color: Userlabel),
                          icon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        initialValue: null,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onTap: () {
                          setState(() {
                            Passlabel = Colors.white60;
                          });
                        },
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          constraints: BoxConstraints(maxWidth: 220),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Passlabel),
                          icon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(show
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  show = !show;
                                });
                              }),
                        ),
                        obscureText: show,
                        onChanged: (value) {
                          pword = value;
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Card(
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (uname.length > 6 && pword.length >= 6) {
                            } else {
                              setState(() {
                                Userlabel = Colors.red;
                                Passlabel = Colors.red;
                              });
                            }
                          },
                          splashColor: Colors.blue.withAlpha(60),
                          child: Container(
                            width: 250,
                            height: 70,
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  is_loading=true;
                                });
                                await jiosaavn.emailpasswordsignin(
                                    uname, pword, context);
                                    setState(() {
                                      is_loading=false;
                                    });
                              },
                              child: Center(
                                child: Text('Login'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t\ have an account?',
                            style: TextStyle(color: Colors.white),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, registerScreen.id);
                            },
                            child: Text(
                              ' Register',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if(is_loading)
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
