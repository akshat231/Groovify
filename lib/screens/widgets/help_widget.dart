import 'package:flutter/material.dart';
import 'package:groovify/jiosaavn.dart';
import 'package:url_launcher/url_launcher.dart';

class FutureView extends StatefulWidget {
  FutureView({
    super.key,
    required this.fun,
    required this.format,
  });

  Future<Map<String, String>>? fun;
  String format;

  bool track = true;

  void urlopener(String name) async {
    if (track == true) {
      List<Map<String, dynamic>> tracklist =
          await jiosaavn.getresultonTracks(name);
      String s = tracklist[0]['uri'];
      final splitted = s.split(':');
      String form = splitted[1];
      String code = splitted[2];
      final Uri redirecturl = Uri.parse('http://open.spotify.com/$form/$code');
      if (!await launchUrl(redirecturl)) {
        throw Exception('Could not launch $redirecturl');
      }
    } else {
      List<Map<String, dynamic>> tracklist =
          await jiosaavn.getresultonArtist(name);
      String s = tracklist[0]['uri'];
      final splitted = s.split(':');
      String form = splitted[1];
      String code = splitted[2];
      final Uri redirecturl = Uri.parse('http://open.spotify.com/$form/$code');
      if (!await launchUrl(redirecturl)) {
        throw Exception('Could not launch $redirecturl');
      }
    }
  }

  @override
  State<FutureView> createState() => _FutureViewState();
}

class _FutureViewState extends State<FutureView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: widget.fun,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text(
              'wait',
              style: TextStyle(color: Colors.white, fontSize: 50),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error has occured, Please Login Again',
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          );
        } else {
          final titles = snapshot.data!.keys.toList();
          final images = snapshot.data!.values.toList();
          return Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 200,
                  width: 200,
                  margin: EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      if (widget.format == 'track') {
                        setState(() {
                          widget.track = true;
                          widget.urlopener(titles[index]);
                        });
                      } else {
                        setState(() {
                          widget.track = false;
                          widget.urlopener(titles[index]);
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Image.network(
                            images[index],
                            fit: BoxFit.fitWidth,
                            width: double.infinity,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            titles[index],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

class Searchiton extends StatefulWidget {
  String? selectedvalue;
  Future<List<Map<String, dynamic>>> fut;

  Searchiton({required this.fut, required this.selectedvalue}) {
    fut = fut;
    selectedvalue = selectedvalue;
  }

  @override
  State<Searchiton> createState() => _SearchitonState();
}

class _SearchitonState extends State<Searchiton> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.fut,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              width: double.infinity,
              height: 50,
              color: Color.fromRGBO(128, 128, 128, 1),
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
        if (snapshot.data!.length == 0) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              width: double.infinity,
              height: 50,
              color: Color.fromRGBO(128, 128, 128, 1),
              child: Center(
                  child: Text(
                'No Data Found',
                style: TextStyle(color: Colors.white, fontSize: 14),
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
                'Error happened',
                style: TextStyle(color: Colors.white, fontSize: 14),
              )),
            ),
          );
        } else {
          if (widget.selectedvalue == 'Albums' ||
              widget.selectedvalue == 'Artists')
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                color: Color.fromRGBO(128, 128, 128, 1),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              String s = snapshot.data![index]['uri'];
                              final splitted = s.split(':');
                              String form = splitted[1];
                              String code = splitted[2];
                              final Uri redirecturl = Uri.parse(
                                  'http://open.spotify.com/$form/$code');
                              if (!await launchUrl(redirecturl)) {
                                throw Exception(
                                    'Could not launch $redirecturl');
                              }
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: 50,
                                    child: Image(
                                        image: NetworkImage(snapshot
                                            .data![index]['images'][0]['url']
                                            .toString())),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Center(
                                    child: Text(
                                      snapshot.data![index]['name'].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            height: 3,
                            indent: 20,
                            endIndent: 40,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          else
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                color: Color.fromRGBO(128, 128, 128, 1),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              String s = snapshot.data![index]['uri'];
                              final splitted = s.split(':');
                              String form = splitted[1];
                              String code = splitted[2];
                              final Uri redirecturl = Uri.parse(
                                  'http://open.spotify.com/$form/$code');
                              if (!await launchUrl(redirecturl)) {
                                throw Exception(
                                    'Could not launch $redirecturl');
                              }
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: 50,
                                    child: Image(
                                        image: NetworkImage(snapshot
                                            .data![index]['album']['images'][0]
                                                ['url']
                                            .toString())),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Center(
                                    child: Text(
                                      snapshot.data![index]['name'].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            height: 3,
                            indent: 20,
                            endIndent: 40,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
        }
      },
    );
  }
}
