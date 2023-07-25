import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:groovify/jiosaavn.dart';
import './widgets/help_widget.dart';
import './widgets/trendingwidget.dart';
import 'package:url_launcher/url_launcher.dart';

class demandscreen extends StatefulWidget {
  static const String id = "demandscreen";
  String genre;
  demandscreen({required this.genre}) {
    genre = genre;
  }

  @override
  State<demandscreen> createState() => _demandscreenState();
}

class _demandscreenState extends State<demandscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Text(
                    'A',
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: FutureBuilder(
                    future: jiosaavn.getsongsongenre(widget.genre),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            child: SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        );
                      }
                      if (snapshot.isNull) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            color: Color.fromRGBO(128, 128, 128, 1),
                            child: Center(
                                child: Text(
                              'No Data Found',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            color: Color.fromRGBO(128, 128, 128, 1),
                            child: Center(
                                child: Text(
                              'Error Occured!!! Go Back and try and again',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )),
                          ),
                        );
                      } else {
                        return GridView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return songwidget(
                                link: snapshot.data![index]['album']['images']
                                    [0]['url'],
                                name: snapshot.data![index]['name'],
                                uniform: snapshot.data![index]['uri'],
                              );
                            });
                      }
                    },
                  )),
            ],
          ),
        ));
  }
}

class songwidget extends StatelessWidget {
  String link;
  String name;
  String uniform;

  songwidget({required this.link, required this.name, required this.uniform}) {
    link = link;
    name = name;
    uniform = uniform;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: InkWell(
              onTap: () async {
                final splitted = uniform.split(':');
                String form = splitted[1];
                String code = splitted[2];
                final Uri redirecturl =
                    Uri.parse('http://open.spotify.com/$form/$code');
                if (!await launchUrl(redirecturl)) {
                  throw Exception('Could not launch $redirecturl');
                }
                ;
              },
              child: Image.network(link,
                  fit: BoxFit.fitWidth, width: double.infinity)),
        ),
      ],
    );
  }
}
