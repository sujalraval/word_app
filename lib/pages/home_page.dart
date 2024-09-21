import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'generator_page.dart';
import 'favorites_page.dart';
import 'search_page.dart';
import '../my_app.dart'; // Import your app state file

class MyHomePage extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;

  MyHomePage({Key? key, required this.onThemeChanged}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs: Home, Favorites, Search
      child: Scaffold(
        appBar: AppBar(
          title: Text('Namer App'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
              Tab(icon: Icon(Icons.search), text: 'Search'),
            ],
          ),
          actions: [
            Switch(
              value: Provider.of<MyAppState>(context).isDarkMode,
              onChanged: (value) {
                widget.onThemeChanged(value);
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            GeneratorPage(),
            FavoritesPage(),
            SearchPage(),
          ],
        ),
      ),
    );
  }
}
