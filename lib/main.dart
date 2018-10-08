import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget widget = MaterialApp(
      title: "App Title",
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );

    return widget;
  }
}


//State Class which extends Statefull widget RandomWords
//The Logic resides here
class RandomWordState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved =
      new Set<WordPair>(); //List that does not allow duplate entries
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final ex = List<Models>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Startup Name Generator"),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
          new IconButton(
              icon: const Icon(Icons.remove_red_eye), onPressed: _showDetail),
          new IconButton(
              icon: const Icon(Icons.featured_play_list),
              onPressed:(){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GetJson()));
             }
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  //Intent //Pahami ini
  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
            return new ListTile(
              title: new Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          });

          final List<Widget> divided =
              ListTile.divideTiles(context: context, tiles: tiles).toList();

          return new Scaffold(
              appBar: new AppBar(
                title: const Text("Saved Suggestions"),
              ),
              body: Container(
                color: Colors.white,
                child: ListView(children: divided),
              ));
        },
      ),
    );
  }

  //Generate datas for listview
  Widget _buildSuggestions() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return Divider();

            final index = i ~/ 2;

            if (index >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(10));
            }

            return _buildRow(_suggestions[index]);
          }),
    );
  }

  //List Item dan adapter
  Widget _buildRow(WordPair wordpair) {
    final bool isAlreadySaved = _saved.contains(wordpair);

    return ListTile(
      title: Text(
        wordpair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        isAlreadySaved ? Icons.favorite : Icons.favorite_border,
        color: isAlreadySaved ? Colors.red : null,
      ),
      subtitle: new Text(
        'Subtitle',
        style: TextStyle(color: Colors.grey[500], fontSize: 12.0),
      ),
      onTap: () {
        setState(() {
          if (isAlreadySaved) {
            _saved.remove(wordpair);
          } else {
            _saved.add(wordpair);
          }
        });
      },
    );
  }

  //Show Detail Page
  void _showDetail() {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
          appBar: new AppBar(
            title: const Text("Detail Page"),
          ),
          body: Container(
            color: Colors.white,
            child: ListView(
              children: [
                new Image(
                  image: new AssetImage('assets/images/lake.jpg'),
                  width: 600.0,
                  height: 240.0,
                  fit: BoxFit.cover,
                ),
                _buildTitleSection(),
                _buildButtonSection(),
                _buildTextSection()
              ],
            ),
          ));
    }));
  }

  void _showListFeature() {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("List Peserta Flutter"),
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: ex.length,
          itemBuilder: (context, i) {
            final baru = ex[i];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Image.network(
                      baru.url,
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      baru.title,
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }));
  }

  Widget _buildTitleSection() {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Danau Simalakama Sirih',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "Banten, Indonesia",
                style: TextStyle(color: Colors.grey[500]),
              )
            ],
          )),
          FavouriteWidget()
        ],
      ),
    );

    return titleSection;
  }

  Widget _buildButtonSection() {

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(children: <Widget>[
            Icon(Icons.call),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Call"),
            )
          ],),
          Column(children: <Widget>[
            Icon(Icons.near_me),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Location"),
            )
          ],),
          Column(children: <Widget>[
            Icon(Icons.share),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Share"),
            )
          ],),
        ],
      )
    );

    return buttonSection;
  }

  Widget _buildTextSection() {
    Widget textSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Text(
        "Danau Toba adalah danau alami besar di Indonesia yang berada di kaldera gunung berapi super. Danau ini memiliki panjang 100 kilometer, lebar 30 kilometer, dan kedalaman 505 meter. Danau ini terletak di tengah pulau Sumatera bagian utara dengan ketinggian permukaan sekitar 900 meter.",
        softWrap: true,
      ),
    );

    return textSection;
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordState createState() => new RandomWordState();
}

class FavouriteWidget extends StatefulWidget {
  @override
  _FavouriteWidgetState createState() => _FavouriteWidgetState();
}

//Favourite Widget State
//Store mutable information
class _FavouriteWidgetState extends State<FavouriteWidget> {
  bool _isFavourite = true;
  int _favouriteCount = 41;

  void _toggleFavourite() {
    setState(() {
      if (_isFavourite) {
        _isFavourite = false;
        _favouriteCount -= 1;
      } else {
        _isFavourite = true;
        _favouriteCount += 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: IconButton(
              icon: (_isFavourite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border)),
              color: _isFavourite ? Colors.red : null,
              onPressed: _toggleFavourite),
        ),
        SizedBox(
          width: 18.0,
          child: Container(child: Text('$_favouriteCount')),
        ),
      ],
    );

    return widget;
  }
}


class GetJson extends StatefulWidget {
  @override
  _GetJsonState createState() => _GetJsonState();
}

class _GetJsonState extends State<GetJson> {

  bool isLoading = true;
  final ex = List<Models>();

  _getJson() async {
    ex.clear();
    final response = await http.get("https://jsonplaceholder.typicode.com/photos");
    final data = jsonDecode(response.body);
    data.forEach((e){
      final ep = new Models(e['albumId'], e['id'], e['title'], e['url'], e['thumbnailUrl']);
      ex.add(ep);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Peserta Flutter"),
        backgroundColor: Colors.white,
      ),
      body: isLoading ?  Center(
        child: CircularProgressIndicator(),
      ) : ListView.builder(
        shrinkWrap: true,
        itemCount: ex.length,
        itemBuilder: (context, i) {
          final baru = ex[i];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Image.network(
                    baru.url,
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    baru.title,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class Models {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Models(this.albumId, this.id, this.title, this.url, this.thumbnailUrl);
}
