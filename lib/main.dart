import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'StartUpNameGenerator',            
        home: RandomWords(),
        theme: ThemeData(
          accentColor: Colors.yellow,
          primaryColor: Colors.red,
        )
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords>{
  //final _suggestions = <WordPair>[];
  //final _biggerFont = TextStyle(fontSize: 18.0);
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _favoriteSet = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  Widget build(BuildContext context)
  {    
    Widget _buildRow(WordPair pair)
    {
      final bool _savedPair = _favoriteSet.contains(pair);
      return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: new Icon(
          _savedPair ? Icons.favorite : Icons.favorite_border,
          color: _savedPair ? Colors.red : null,
        ),
        onTap: () 
        {
          setState(() {
            if (_savedPair) {
              _favoriteSet.remove(pair);
            } else { 
              _favoriteSet.add(pair); 
            } 
          });
        },
      );
    }

    Widget _buildSuggestions()
    {
      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemBuilder: (context, i){
          if(i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length)
          {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
      );
    }
    
    void _pushSaved(){
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context){
            final Iterable<ListTile> tiles = _favoriteSet.map(
              (WordPair pair){
                return ListTile(
                  title: new Text(
                    pair.asPascalCase,
                    style:_biggerFont,
                  )
                );
              }
            );

            final List<Widget> divided = ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList();

            return Scaffold(appBar: AppBar(
                title: Text("Saved Suggestion"),              
              ),
              body: new ListView(children:divided),
            );
          }
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );

    //Text(WordPair.random().asPascalCase);

  }  
}
