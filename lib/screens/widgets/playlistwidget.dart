import 'dart:io';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:groovify/screens/widgets/help_widget.dart';
import 'package:http/http.dart';
import '../../jiosaavn.dart';
import 'package:file_picker/file_picker.dart';
import '../playingscreen.dart';
import 'package:just_audio/just_audio.dart';

class MyJABytesSource extends StreamAudioSource {
  final Uint8List _buffer;

  MyJABytesSource(this._buffer) : super(tag: 'MyAudioSource');

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    // Returning the stream audio response with the parameters
    return await StreamAudioResponse(
      sourceLength: _buffer.length,
      contentLength: (end ?? _buffer.length) - (start ?? 0),
      offset: start ?? 0,
      stream: Stream.fromIterable([_buffer.sublist(start ?? 0, end)]),
      contentType: 'audio/wav',
    );
  }
}

double? durationofsong;

class playlistwidget extends StatefulWidget {
  const playlistwidget({super.key});

  @override
  State<playlistwidget> createState() => _playlistwidgetState();
}

class _playlistwidgetState extends State<playlistwidget> {
  Duration lengthofsong = Duration(minutes: 2);
  double nowvalue = 100.0;
  Widget initial = blankwidget();
  AudioPlayer audioPlayer = AudioPlayer();

  Future<Duration> fun(bytes, ad) async {
    return await ad.setAudioSource(bytes);
  }
  void initState()
  {
    jiosaavn.global=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Text(
                      jiosaavn.profileName[0],
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: [
                          'wav',
                          'm4a',
                          'mp3',
                          'mp4',
                          'flac',
                          'wma',
                          'aac'
                        ],
                      );
                      if (result != null && result.files.isNotEmpty) {
                        setState(() {
                          jiosaavn.global=true;
                          initial;
                        });
                        Uint8List bytes = result.files[0].bytes!;
                        MyJABytesSource byts = MyJABytesSource(bytes);
                        if (jiosaavn.ap.playing) {
                          jiosaavn.ap.stop();
                          jiosaavn.ap.dispose();
                          jiosaavn.initializeaudio();
                        }
                        setState(() {
                          initial = blankwidget();
                        });
                        AudioPlayer audioPlayer = jiosaavn.ap;
                        print(audioPlayer);
                        Duration length = await fun(byts, audioPlayer);
                        setState(() {
                          initial = PlayingScreen(
                            audioPlayer: audioPlayer,
                            songlength: length,
                            name: result.files.first.name,
                          );
                        });
                      }
                    },
                    child: Icon(
                      Icons.upload,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await jiosaavn.emailpasswordsignout(context);
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: initial,
            ),
          ),
        ],
      ),
    ));
  }
}
