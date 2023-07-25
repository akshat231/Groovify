import 'package:flutter/material.dart';
import 'package:groovify/screens/homescreen.dart';
import 'package:groovify/screens/widgets/help_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/loginscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';

class jiosaavn {
  static String clientID = 'aa121d6307fe43b3b0598454e4906c6f';
  static String clientSecret = '576a05033e2c49c2bd830ea6f7a501a0';


  static AudioPlayer ap=AudioPlayer();
  static initializeaudio()
  {
    ap=AudioPlayer();
  }

  static String profileName = 'Username';
  static bool global = false;

  static int min(int a, int b) {
    return a > b ? b : a;
  }

  static Future<Map<String, String>> fetchtop() async {
    final url = Uri.parse(
        'http://ws.audioscrobbler.com/2.0/?method=chart.gettoptracks&api_key=9448c12e23e9df6b992e50e668ee6a16&format=json');
    final response = await http.get(
      url,
    );
    Map data = jsonDecode(response.body);

    Map<String, String>? songimage = {};
    for (int i = 0; i < 3; i++) {
      String local1 = data['tracks']['track'][i]['name'];
      String uselocal1 = local1.replaceAll(' ', '+');
      var secondurl = Uri.parse('https://saavn.me/search/all?query=$uselocal1');
      var secondresponse = await http.get(secondurl);
      Map seconddata = json.decode(secondresponse.body);
      String local2 =
          seconddata['data']['topQuery']['results'][0]['image'][2]['link'];

      songimage[local1] = local2;
    }
    return songimage;
  }

  static Future<Map<String, String>> fetchtopartist() async {
    final url = Uri.parse(
        'http://ws.audioscrobbler.com/2.0/?method=chart.gettopartists&api_key=9448c12e23e9df6b992e50e668ee6a16&format=json');
    final response = await http.get(
      url,
    );
    Map data = jsonDecode(response.body);

    Map<String, String>? artistimage = {};
    for (int i = 0; i < 4; i++) {
      String local1 = data['artists']['artist'][i]['name'];
      String uselocal1 = local1.replaceAll(' ', '+');
      var secondurl = Uri.parse('https://saavn.me/search/all?query=$uselocal1');
      var secondresponse = await http.get(secondurl);
      Map seconddata = json.decode(secondresponse.body);
      String local2 =
          seconddata['data']['topQuery']['results'][0]['image'][2]['link'];

      artistimage[local1] = local2;
    }
    return artistimage;
  }

  static Future<String> getaccesstoken() async {
    final String authUrl = 'https://accounts.spotify.com/api/token';
    final String basicAuth =
        base64.encode(utf8.encode('$clientID:$clientSecret'));
    final Map<String, String> headers = {
      'Authorization': 'Basic $basicAuth',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final String body = 'grant_type=client_credentials';

    final http.Response response =
        await http.post(Uri.parse(authUrl), headers: headers, body: body);
    final Map<String, dynamic> responseData =
        jsonDecode(response.body) as Map<String, dynamic>;
    final String accessToken = responseData['access_token'] as String;

    return accessToken;
  }

  static Future<Map<String, dynamic>> getTrackDetails(
      String nameofquery) async {
    String accessToken = await getaccesstoken();
    final String trackUrl = 'https://api.spotify.com/v1/search?$nameofquery';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken'
    };

    final http.Response response =
        await http.get(Uri.parse(trackUrl), headers: headers);
    final Map<String, dynamic> trackData =
        jsonDecode(response.body) as Map<String, dynamic>;

    return trackData;
  }

  static Future<Map<String, dynamic>> getnewRelease() async {
    String accessToken = await getaccesstoken();
    final String trackUrl =
        'https://api.spotify.com/v1/browse/new-releases?country=IN';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken'
    };

    final http.Response response =
        await http.get(Uri.parse(trackUrl), headers: headers);
    final Map<String, dynamic> trackData =
        jsonDecode(response.body) as Map<String, dynamic>;

    return trackData;
  }

  static Future<List<Map<String, dynamic>>> getsongsongenre(
      String genre) async {
    String accessToken = await getaccesstoken();
    final String searchUrl =
        "https://api.spotify.com/v1/search?type=track&q=year:2023%20genre:$genre&limit=10";
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken'
    };
    final http.Response response =
        await http.get(Uri.parse(searchUrl), headers: headers);
    final Map<String, dynamic> trackData =
        jsonDecode(response.body) as Map<String, dynamic>;

    final List<Map<String, dynamic>> topartists =
        (trackData['tracks']['items'] as List<dynamic>)
            .cast<Map<String, dynamic>>();

    return topartists;
  }

  static Future<List<Map<String, dynamic>>> getresultonArtist(
      String query) async {
    String accessToken = await getaccesstoken();

    final String searchUrl =
        "https://api.spotify.com/v1/search?q=$query&type=artist";
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken'
    };
    final http.Response response =
        await http.get(Uri.parse(searchUrl), headers: headers);
    final Map<String, dynamic> trackData =
        jsonDecode(response.body) as Map<String, dynamic>;

    final List<Map<String, dynamic>> topartists =
        (trackData['artists']['items'] as List<dynamic>)
            .cast<Map<String, dynamic>>();

    return topartists;
  }

  static Future<List<Map<String, dynamic>>> getresultonAlbums(
      String query) async {
    String accessToken = await getaccesstoken();

    final String searchUrl =
        "https://api.spotify.com/v1/search?q=$query&type=album";
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken'
    };
    final http.Response response =
        await http.get(Uri.parse(searchUrl), headers: headers);
    final Map<String, dynamic> trackData =
        jsonDecode(response.body) as Map<String, dynamic>;

    final List<Map<String, dynamic>> topalbum =
        (trackData['albums']['items'] as List<dynamic>)
            .cast<Map<String, dynamic>>();

    return topalbum;
  }

  static Future<List<Map<String, dynamic>>> getresultonTracks(
      String query) async {
    String accessToken = await getaccesstoken();

    final String searchUrl =
        "https://api.spotify.com/v1/search?q=$query&type=track";
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken'
    };
    final http.Response response =
        await http.get(Uri.parse(searchUrl), headers: headers);
    final Map<String, dynamic> trackData =
        jsonDecode(response.body) as Map<String, dynamic>;

    final List<Map<String, dynamic>> toptracks =
        (trackData['tracks']['items'] as List<dynamic>)
            .cast<Map<String, dynamic>>();

    return toptracks;
  }

  static Future<void> emailpasswordsignin(
      String Email, String Password, context) async {
    final auth = FirebaseAuth.instance;
    try {
      final result = await auth.signInWithEmailAndPassword(
          email: Email, password: Password);
      if (result.user != null) {
        profileName = await fetchusername(Email);
        Navigator.pushNamed(context, homeScreen.id);
      } else {
        handleError("Problem while signing in", context);
      }
    } on FirebaseAuthException catch (e) {
      handleError(e.toString(), context);
    }
  }

  static Future<String?> handleError(error, context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Alert'),
        content: Text(error.toString()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static Future<void> emailpasswordsignout(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, ModalRoute.withName(loginScreen.id));
  }

  static Future<void> emailpasswordcreate(
      String Email, String Password, context, String uname) async {
    if (await checkemail(Email)) {
      try {
        final auth = FirebaseAuth.instance;
        final result = await auth.createUserWithEmailAndPassword(
            email: Email, password: Password);
        if (result.user != null) {
          addinfo(Email, uname);
          profileName = await fetchusername(Email);
          Navigator.pushNamed(context, homeScreen.id);
        } else {
          handleError("Error", context);
        }
      } catch (e) {
        handleError(e.toString(), context);
      }
    } else {
      handleError('Email Already Exist', context);
    }
  }

  static Future<void> addinfo(String ename, String uname) async {
    final result = FirebaseFirestore.instance;
    final message = <String, String>{
      "Email": ename,
      "Username": uname,
    };
    await result.collection('Music').doc().set(message);
  }

  static Future<String> fetchusername(String ename) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Music')
        .where("Email", isEqualTo: ename)
        .get();
    List<QueryDocumentSnapshot> matchingDocuments = snapshot.docs;
    Map<String, dynamic> data =
        matchingDocuments[0].data() as Map<String, dynamic>;
    String uname = data['Username'];
    return uname;
  }

  static Future<bool> checkemail(String email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Music')
        .where("Email", isEqualTo: email)
        .get();
    if (snapshot.size > 0) {
      return false;
    } else {
      return true;
    }
  }
}
