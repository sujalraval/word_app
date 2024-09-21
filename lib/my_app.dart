import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'theme.dart';
import 'pages/home_page.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(_isDarkMode),
      child: Consumer<MyAppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'Namer App',
            theme: appState.themeData,
            home: MyHomePage(
              onThemeChanged: (bool isDarkMode) {
                setState(() {
                  _isDarkMode = isDarkMode;
                });
                appState.updateTheme(isDarkMode);
              },
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  bool isDarkMode;
  late ThemeData themeData;
  var current = WordPair.random();
  String? currentMeaning;
  var favorites = <WordPair>[];
  var favoriteMeanings = <String?>[];

  MyAppState(this.isDarkMode) {
    themeData = isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    _loadFavorites();
    fetchMeaning(current.first);
  }

  void updateTheme(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    themeData = isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    notifyListeners();
  }

  void getNext() {
    current = WordPair.random();
    fetchMeaning(current.first);
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      int index = favorites.indexOf(current);
      favorites.removeAt(index);
      favoriteMeanings.removeAt(index);
    } else {
      favorites.add(current);
      favoriteMeanings.add(currentMeaning);
    }
    saveFavorites();
    notifyListeners();
  }

  Future<void> fetchMeaning(String word) async {
    final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data.isNotEmpty && data[0]['meanings'] != null) {
          currentMeaning = data[0]['meanings'][0]['definitions'][0]['definition'];
        } else {
          currentMeaning = "No definition found.";
        }
      } else {
        currentMeaning = "Error fetching definition.";
      }
    } catch (e) {
      currentMeaning = "Error fetching definition.";
    }
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favorites');
    List<String>? savedMeanings = prefs.getStringList('favoriteMeanings');

    if (savedFavorites != null && savedMeanings != null) {
      favorites = savedFavorites.map((word) {
        final parts = word.split(' ');
        return WordPair(parts[0], parts[1]);
      }).toList();
      favoriteMeanings = savedMeanings;
    }

    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteWords = favorites.map((pair) => "${pair.first} ${pair.second}").toList();
    List<String> nonNullFavoriteMeanings = favoriteMeanings.whereType<String>().toList();
    await prefs.setStringList('favorites', favoriteWords);
    await prefs.setStringList('favoriteMeanings', nonNullFavoriteMeanings);
  }
}
