import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador de nomes aleatórios',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          foregroundColor: Color.fromARGB(255, 183, 27, 84),
        ),
      ),
      home: const RandomWords(),
    );
  }
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  bool grid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerador Nomes Aleatórios"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: "Nomes Salvos",
          )
        ],
        leading: grid
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    grid = false;
                  });
                },
              )
            : const SizedBox(),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(2, 15, 2, 10),
            child: Column(
              children: [
                const Text(
                  'Visualização em Cards',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Switch(
                  activeTrackColor: const Color.fromARGB(255, 183, 27, 84),
                  value: grid,
                  onChanged: (value) {
                    setState(() {
                      grid = value;
                    });
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, int i) {
                if (i >= _suggestions.length) {
                  _suggestions.addAll(generateWordPairs().take(10));
                }

                return _buildRow(_suggestions[i]);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: grid ? 2 : 1,
                mainAxisExtent: 65,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return Card(
      color: const Color.fromARGB(255, 143, 120, 120),
      surfaceTintColor: Colors.black,
      child: ListTile(
        iconColor: const Color.fromARGB(255, 183, 27, 84),
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
          semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Nomes Salvos'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() {
    return _RandomWordsState();
  }
}
