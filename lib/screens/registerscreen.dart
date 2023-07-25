import 'package:flutter/material.dart';
import '../screens/demandscreen.dart';
import '../screens/homescreen.dart';
import './loginscreen.dart';
import '../jiosaavn.dart';

class registerScreen extends StatefulWidget {
  static const String id = "registerscreen";

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  String uname = '';
  String pword = '';
  String ename = '';
  bool show=true;
  bool is_loading=false;
  Color Userlabel = Colors.white60;
  Color Passlabel = Colors.white60;
  Color Emaillabel = Colors.white60;
  Color changecoloruser() {
    Userlabel = Colors.white60;
    return Userlabel;
  }

  Color changecolorpass() {
    Passlabel = Colors.white60;
    return Passlabel;
  }

  Color changecolorEmail() {
    Emaillabel = Colors.white60;
    return Emaillabel;
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
              height: 420,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Sign-Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: null,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (value) {
                        ename = value;
                      },
                      onTap: () {
                        setState(() {
                          Emaillabel = Colors.white60;
                        });
                      },
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        constraints: BoxConstraints(maxWidth: 220),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Emaillabel),
                        icon: Icon(
                          Icons.email,
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
                      height: 10,
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
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        constraints: BoxConstraints(maxWidth: 220),
                        labelText: 'UserName',
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
                      height: 10,
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
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
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
                                    }
                      ),
                      ),
                      obscureText: show,
                      onChanged: (value) {
                        pword = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Container(
                        width: 250,
                        height: 70,
                        child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                is_loading=true;
                              });
                              if (uname.length > 6 && pword.length >= 6) {
                                await jiosaavn.emailpasswordcreate(
                                    ename, pword, context, uname);
                              
              
                              } else {
                                setState(() {
                                  Userlabel = Colors.red;
                                  Passlabel = Colors.red;
                                  Emaillabel = Colors.red;
                                });
                              }
                              setState(() {
                                is_loading=false;
                              });
                            },
                            child: Center(child: Text('Register'))),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already a User?',
                          style: TextStyle(color: Colors.white),
                        ),
                        InkWell(
                          onTap: () {
                            
                            Navigator.popUntil(
                                context, ModalRoute.withName(loginScreen.id));
                          },
                          child: Text(
                            ' Login',
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
