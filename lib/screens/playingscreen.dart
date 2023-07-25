import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:groovify/jiosaavn.dart';
import 'package:groovify/screens/demandscreen.dart';
import 'package:just_audio/just_audio.dart';
import './widgets/playlistwidget.dart';

class PlayingScreen extends StatefulWidget {
  static const String id = "playingscreen";

  Duration songlength;
  AudioPlayer audioPlayer;
  String name;

  PlayingScreen({
    required this.songlength,
    required this.audioPlayer,
    required this.name,
  }) {
    songlength = songlength;
    audioPlayer = audioPlayer;
  }

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  bool isPlaying = false;
  double _sliderValue = 0.0;

  @override
  void initState() {
    widget.audioPlayer.play();
    print(widget.songlength);
    setState(() {
      isPlaying = widget.audioPlayer.playing;
    });
    widget.audioPlayer.positionStream.listen((position) {
      setState(() {
        _sliderValue = position.inMilliseconds.toDouble();
      });
    });
  }

  @override
  void dispose() {
    widget.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      Image.asset(
        'images/bgimage.jpg',
        fit: BoxFit.cover,
      ),
      ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.0),
              ],
              stops: const [
                0.0,
                0.4,
                0.6
              ]).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.deepPurple.shade200.withOpacity(0.8),
                Colors.deepPurple.shade800.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child:Text(widget.name,style: TextStyle(color: Colors.white,fontSize: 17),),
            ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.white,
              ),
              child: Slider(
                  min: 0.0,
                  max: widget.songlength.inMilliseconds.toDouble() + 1.0,
                  value: _sliderValue,
                  onChanged: (val) {
                    setState(() {
                      widget.audioPlayer
                          .seek(Duration(milliseconds: val.toInt()));
                    });
                  }),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: InkWell(
                      onTap: () {
                        if(_sliderValue>=10000)
                        {
                          print(_sliderValue);
                        widget.audioPlayer.seek(Duration(
                            seconds:
                                widget.audioPlayer.position.inSeconds - 10));
                        }
                      },
                      child: Icon(
                        Icons.replay_10_outlined,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: InkWell(
                      onTap: () {
                        if (widget.audioPlayer.playing) {
                          widget.audioPlayer.pause();
                        } else {
                          widget.audioPlayer.play();
                        }
                        setState(() {
                          isPlaying =
                              !isPlaying; // Update the play/pause button state.
                        });
                      },
                      child: Icon(
                        widget.audioPlayer.playing
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: InkWell(
                      onTap: () {
                        if(_sliderValue<=widget.songlength.inMilliseconds.toDouble()-10000)
                      {
                        widget.audioPlayer.seek(Duration(
                            seconds:
                                widget.audioPlayer.position.inSeconds + 10));
                      }
                      },
                      child: Icon(
                        Icons.forward_10_outlined,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ]);
  }
}

class blankwidget extends StatefulWidget {
  const blankwidget({super.key});

  @override
  State<blankwidget> createState() => _blankwidgetState();
}

class _blankwidgetState extends State<blankwidget> {
  
  Widget textful = Text(
    'No Song is loaded!!!',
    style: TextStyle(color: Colors.white),
  );

  Widget circularful = CircularProgressIndicator(color: Colors.amber,);

  @override
  Widget build(BuildContext context) {
    if(!jiosaavn.global)
    return Container(
      color: Color.fromRGBO(128, 128, 128, 1),
      child: Center(child: textful),
    );
    else
    return Container(
      color: Color.fromRGBO(128, 128, 128, 1),
      child: Center(child: circularful),
    );
  }
}
