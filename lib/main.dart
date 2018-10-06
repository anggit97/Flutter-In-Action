import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{

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
class RandomWordState extends State<RandomWords>{

  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>(); //List that does not allow duplate entries
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Startup Name Generator"),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
          new IconButton(icon: const Icon(Icons.remove_red_eye), onPressed: _showDetail)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  //Intent //Pahami ini
  void _pushSaved(){
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
          builder: (BuildContext context){
            final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair){
                  return new ListTile(
                    title: new Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
                }
            );

            final List<Widget> divided = ListTile
            .divideTiles(
                context : context,
                tiles: tiles
            )
            .toList();

            return new Scaffold(
              appBar: new AppBar(
                title: const Text("Saved Suggestions"),
              ),
              body: new ListView(children: divided),
            );
          },
      ),
    );
  }

  //Generate datas for listview
  Widget _buildSuggestions(){
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i){
          if(i.isOdd) return Divider();

          final index = i ~/ 2;

          if(index >= _suggestions.length){
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);

        });
  }

  //List Item dan adapter
  Widget _buildRow(WordPair wordpair){
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
      onTap: (){
        setState(() {
          if(isAlreadySaved){
            _saved.remove(wordpair);
          }else{
            _saved.add(wordpair);
          }
        });
      },
    );
  }

  //Show Detail Page
  void _showDetail(){
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context){
              return Scaffold(
                appBar: new AppBar(
                  title: const Text("Detail Page"),
                ),
                body: Container(
                  color: Colors.white,
                  child: ListView(
                    children: [
                      new Image(image: new AssetImage('assets/images/lake.jpg'), width: 600.0, height: 240.0, fit: BoxFit.cover,),
                      _buildTitleSection(),
                      _buildButtonSection(),
                      _buildTextSection()
                    ],
                  ),
                )
              );
            }
        )
      );
  }

  Widget _buildTitleSection(){
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom : 16.0),
                    child: Text(
                      'Danau Simalakama Sirih',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Text(
                    "Banten, Indonesia",
                    style: TextStyle(
                      color: Colors.grey[500]
                    ),
                  )
                ],
              )
          ),
          Icon(
            Icons.star,
            color : Colors.red[500]
          ),
          Text(
            "41"
          )
        ],
      ),
    );

    return titleSection;
  }

  Widget _buildButtonSection(){
    Column buildButtonColumn(IconData icon, String label) {
      Color color = Theme.of(context).primaryColor;

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.call, 'CALL'),
          buildButtonColumn(Icons.near_me, 'ROUTE'),
          buildButtonColumn(Icons.share, 'SHARE'),
        ],
      ),
    );


    return buttonSection;
  }

  Widget _buildTextSection(){
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

class RandomWords extends StatefulWidget{

  @override
  RandomWordState createState() => new RandomWordState();

}