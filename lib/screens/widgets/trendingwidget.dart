import 'package:flutter/material.dart';
import 'package:groovify/jiosaavn.dart';
import 'package:groovify/screens/demandscreen.dart';

class trendingwidget extends StatefulWidget {
  const trendingwidget({super.key});
  @override
  State<trendingwidget> createState() => _trendingwidgetState();
}

class _trendingwidgetState extends State<trendingwidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                children: [
                  GenreWidget(
                    paint: Colors.red,
                    genre: 'Romantic',
                    thumbnail: Image.asset(
                      'images/romance.png',
                      height: 50,
                    ),
                  ),
                  GenreWidget(
                    paint: Colors.blue,
                    genre: 'Heavy-Metal',
                    thumbnail: Image.asset(
                      'images/guitar.png',
                      height: 50,
                    ),
                  ),
                  GenreWidget(
                    paint: Colors.brown,
                    genre: 'Indian',
                    thumbnail: Image.asset(
                      'images/hindi.png',
                      height: 50,
                    ),
                  ),
                  GenreWidget(
                    paint: Colors.green,
                    genre: 'Folk',
                    thumbnail: Image.asset(
                      'images/evergreen.png',
                      height: 50,
                    ),
                  ),
                  GenreWidget(
                    paint: Colors.pink,
                    genre: 'Devotional',
                    thumbnail: Image.asset(
                      'images/praying.png',
                      height: 50,
                    ),
                  ),
                  GenreWidget(
                    paint: Colors.purple,
                    genre: 'Classical',
                    thumbnail: Image.asset(
                      'images/classical.png',
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenreWidget extends StatelessWidget {
  Color paint;
  String genre;
  Image thumbnail;

  GenreWidget(
      {required this.paint, required this.genre, required this.thumbnail}) {
    paint = paint;
    genre = genre;
    thumbnail = thumbnail;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => demandscreen(
                  genre: genre,
                ),
              ));
        },
        child: Container(
          height: 70.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: paint,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                child: Container(
                  child: Text(
                    genre.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(70, 30, 0, 0),
                child: thumbnail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
