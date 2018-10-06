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
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
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

}

class RandomWords extends StatefulWidget{

  @override
  RandomWordState createState() => new RandomWordState();

}