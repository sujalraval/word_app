import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_app.dart';

void main() {
  runApp(MyApp());
}
























// import 'dart:convert';
// import 'package:english_words/english_words.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool _isDarkMode = false;

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(_isDarkMode),
//       child: Consumer<MyAppState>(
//         builder: (context, appState, child) {
//           return MaterialApp(
//             title: 'Namer App',
//             theme: appState.themeData,
//             home: MyHomePage(
//               onThemeChanged: (bool isDarkMode) {
//                 setState(() {
//                   _isDarkMode = isDarkMode;
//                 });
//                 appState.updateTheme(isDarkMode);
//               },
//             ),
//             debugShowCheckedModeBanner: false,
//           );
//         },
//       ),
//     );
//   }
// }

// class MyAppState extends ChangeNotifier {
//   bool isDarkMode;
//   late ThemeData themeData;
//   var current = WordPair.random();
//   String? currentMeaning;
//   var favorites = <WordPair>[];
//   var favoriteMeanings = <String?>[];

//   MyAppState(this.isDarkMode) {
//     themeData = isDarkMode ? _darkTheme : _lightTheme;
//     _loadFavorites(); // Load favorites when the app starts
//     fetchMeaning(current.first);
//   }

//   void updateTheme(bool isDarkMode) {
//     this.isDarkMode = isDarkMode;
//     themeData = isDarkMode ? _darkTheme : _lightTheme;
//     notifyListeners();
//   }

//   void getNext() {
//     current = WordPair.random();
//     fetchMeaning(current.first);
//     notifyListeners();
//   }

//   void toggleFavorite() {
//     if (favorites.contains(current)) {
//       int index = favorites.indexOf(current);
//       favorites.removeAt(index);
//       favoriteMeanings.removeAt(index);
//     } else {
//       favorites.add(current);
//       favoriteMeanings.add(currentMeaning);
//     }
//     _saveFavorites(); // Save favorites when toggled
//     notifyListeners();
//   }

//   Future<void> fetchMeaning(String word) async {
//     final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data.isNotEmpty && data[0]['meanings'] != null) {
//           currentMeaning = data[0]['meanings'][0]['definitions'][0]['definition'];
//         } else {
//           currentMeaning = "No definition found.";
//         }
//       } else {
//         currentMeaning = "Error fetching definition.";
//       }
//     } catch (e) {
//       currentMeaning = "Error fetching definition.";
//     }
//     notifyListeners();
//   }

//   Future<void> _loadFavorites() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? savedFavorites = prefs.getStringList('favorites');
//     List<String>? savedMeanings = prefs.getStringList('favoriteMeanings');

//     if (savedFavorites != null && savedMeanings != null) {
//       favorites = savedFavorites.map((word) {
//         final parts = word.split(' ');
//         return WordPair(parts[0], parts[1]);
//       }).toList();
//       favoriteMeanings = savedMeanings;
//     }

//     notifyListeners();
//   }

//   Future<void> _saveFavorites() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> favoriteWords = favorites.map((pair) => "${pair.first} ${pair.second}").toList();
//     List<String> nonNullFavoriteMeanings = favoriteMeanings.whereType<String>().toList();
//     await prefs.setStringList('favorites', favoriteWords);
//     await prefs.setStringList('favoriteMeanings', nonNullFavoriteMeanings);
//   }

//   ThemeData get _lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//     );
//   }

//   ThemeData get _darkTheme {
//     return ThemeData(
//       brightness: Brightness.dark,
//       useMaterial3: true,
//       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange, brightness: Brightness.dark),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   final ValueChanged<bool> onThemeChanged;

//   MyHomePage({Key? key, required this.onThemeChanged}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3, // Three tabs: Generator, Favorites, Search
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Namer App'),
//           bottom: TabBar(
//             tabs: [
//               Tab(icon: Icon(Icons.home), text: 'Home'),
//               Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
//               Tab(icon: Icon(Icons.search), text: 'Search'),
//             ],
//           ),
//           actions: [
//             Switch(
//               value: Provider.of<MyAppState>(context).isDarkMode,
//               onChanged: (value) {
//                 widget.onThemeChanged(value);
//               },
//             ),
//           ],
//         ),
//         body: TabBarView(
//           children: [
//             GeneratorPage(),
//             FavoritesPage(),
//             SearchPage(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GeneratorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;
//     var meaning = appState.currentMeaning ?? 'Loading...';

//     IconData icon;
//     if (appState.favorites.contains(pair)) {
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           BigCard(pair: pair),
//           SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(meaning, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   appState.toggleFavorite();
//                 },
//                 icon: Icon(icon),
//                 label: Text('Like'),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   appState.getNext();
//                 },
//                 child: Text('Next'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BigCard extends StatelessWidget {
//   const BigCard({
//     super.key,
//     required this.pair,
//   });

//   final WordPair pair;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final style = theme.textTheme.displayMedium!.copyWith(
//       color: theme.colorScheme.onPrimary,
//     );
//     return Card(
//       color: theme.colorScheme.primary,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(
//           pair.asLowerCase,
//           style: style,
//           semanticsLabel: "${pair.first} ${pair.second}",
//         ),
//       ),
//     );
//   }
// }

// class FavoritesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();

//     if (appState.favorites.isEmpty) {
//       return Center(
//         child: Text('No favorites yet.'),
//       );
//     }

//     return ListView(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text('You have ${appState.favorites.length} favorites:'),
//         ),
//         for (int i = 0; i < appState.favorites.length; i++)
//           ListTile(
//             leading: Icon(Icons.favorite),
//             title: Text(appState.favorites[i].asLowerCase),
//             subtitle: Text(appState.favoriteMeanings[i] ?? 'Meaning not available'),
//             trailing: IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 appState.favorites.removeAt(i);
//                 appState.favoriteMeanings.removeAt(i);
//                 appState._saveFavorites(); // Save updated favorites
//                 appState.notifyListeners(); // Notify listeners
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }

// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   String _searchQuery = '';
//   String _searchResult = 'Search for a word';
//   bool _isLoading = false;

//   Future<void> _searchWord() async {
//     if (_searchQuery.isEmpty) {
//       setState(() {
//         _searchResult = "Please enter a word to search.";
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _searchResult = 'Searching...'; // Optional: show a searching message
//     });

//     final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$_searchQuery');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data.isNotEmpty && data[0]['meanings'] != null) {
//           setState(() {
//             _searchResult = data[0]['meanings'][0]['definitions'][0]['definition'];
//           });
//         } else {
//           setState(() {
//             _searchResult = "No definition found.";
//           });
//         }
//       } else {
//         setState(() {
//           _searchResult = "Error fetching definition.";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _searchResult = "Error fetching definition.";
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search'),
//       ),
//       resizeToAvoidBottomInset: true, // Ensures the body resizes when the keyboard is shown
//       body: SingleChildScrollView( // Allows the content to scroll
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Enter a word',
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     _searchQuery = value;
//                   });
//                 },
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: _searchWord,
//                 child: Text('Search'),
//               ),
//               SizedBox(height: 20),
//               _isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : Text(_searchResult),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
















