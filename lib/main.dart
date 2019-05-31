import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';//引用第三方package

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final wordPair = new WordPair.random();
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new RandomWords(),
      theme: new ThemeData(primaryColor: Colors.green),//设置主题颜色
    );
  }
}

//定义一个有状态的部件RandomWords
class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}


class RandomWordsState extends State<RandomWords> {
  final _suggests = <WordPair>[];//定义不可变的list对象
  final _biggerFont = const TextStyle(fontSize: 18.0);//定义不可变的文字字体对象
  final _saved = new Set<WordPair>();//定义不可变的set集合，不可重复

  //构建页面结构
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('首页'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();//奇数则加分割线,isEven表示偶数
          final index = (i / 2).floor();//相信取整，等价于i~ / 2
          if (index >= _suggests.length) {
            _suggests.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggests[index]);
        },
        padding: const EdgeInsets.all(16.0));
  }

  //构建列表一行数据布局
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);//判断是否收藏过
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      leading: new Icon(Icons.list),//行前图标
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),//行后图标
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },//点击事件
    );
  }

  //增加页面路由入栈
  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) =>new SuggestPage(suggests:_saved)));
  }
}

//定义收藏页面
class SuggestPage extends StatelessWidget{
  final  Set<WordPair> suggests;
  final _biggerFont = const TextStyle(fontSize: 18.0);//定义不可变的文字字体对象
  const SuggestPage({Key key,this.suggests}):super(key:key);
    @override
  Widget build(BuildContext context) {
    // TODO: implement build
      final tiles = suggests.map((pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final divided = ListTile.divideTiles(
        tiles: tiles,
        context: context,
      ).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('收藏列表'),
        ),
        body: new ListView(children: divided),
      );
  }
  }
