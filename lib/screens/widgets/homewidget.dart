import 'package:flutter/material.dart';
import 'package:groovify/screens/loginscreen.dart';
import '../../jiosaavn.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import './help_widget.dart';

class homewidget extends StatefulWidget {
  const homewidget({super.key});

  @override
  State<homewidget> createState() => _homewidgetState();
}

class _homewidgetState extends State<homewidget> {
  Future<Map<String, String>>? songs;
  Future<Map<String, String>>? artists;
  String? selectedValue;
  bool _showcontainer = false;
  String? queryterm;

  void initState() {
    songs = jiosaavn.fetchtop();
    artists = jiosaavn.fetchtopartist();
    selectedValue = 'Albums';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(50, 90, 0, 0),
              width: double.infinity,
              height: 150,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Hi There,',
                            style: TextStyle(color: Colors.white, fontSize: 28),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            jiosaavn.profileName,
                            style: TextStyle(color: Colors.amber, fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          
                          Expanded(
                              child: InkWell(
                                  onTap: () async {
                                    await jiosaavn
                                        .emailpasswordsignout(context);
                                  },
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        decoration: TextDecoration.underline),
                                  )))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromRGBO(80, 77, 72, 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            items: ['Albums', 'Tracks', 'Artists']
                                .map((String item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            value: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: 160,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                                color: Colors.redAccent,
                              ),
                              elevation: 2,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromRGBO(80, 77, 72, 1),
                        ),
                        child: TextField(
                          style: TextStyle(color: Colors.green),
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            labelText: 'Songs,albums or artists',
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.green,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _showcontainer = true;
                                queryterm = value;
                              });
                            } else {
                              setState(() {
                                _showcontainer = false;
                                queryterm = value;
                              });
                            }
                          },
                      ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                        'Top Songs Now',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      FutureView(
                        fun: songs,
                        format: 'track',
                      ),
                      Text(
                        'Top Artists Now',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      FutureView(
                        fun: artists,
                        format: 'artist',
                      ),
                    ]),
                  ),
                  if (_showcontainer) ...[
                    if (selectedValue == 'Albums') ...[
                      Searchiton(
                        selectedvalue: selectedValue,
                        fut: jiosaavn.getresultonAlbums(queryterm!),
                      ),
                    ],
                    if (selectedValue == 'Artists') ...[
                      Searchiton(
                        selectedvalue: selectedValue,
                        fut: jiosaavn.getresultonArtist(queryterm!),
                      ),
                    ],
                    if (selectedValue == 'Tracks') ...[
                      Searchiton(
                        selectedvalue: selectedValue,
                        fut: jiosaavn.getresultonTracks(queryterm!),
                      ),
                    ]
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
