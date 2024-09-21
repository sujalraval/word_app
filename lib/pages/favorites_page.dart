import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_app.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ${appState.favorites.length} favorites:'),
        ),
        for (int i = 0; i < appState.favorites.length; i++)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(appState.favorites[i].asLowerCase),
            subtitle:
                Text(appState.favoriteMeanings[i] ?? 'Meaning not available'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                appState.favorites.removeAt(i);
                appState.favoriteMeanings.removeAt(i);
                appState.saveFavorites(); // Save updated favorites
                appState.notifyListeners(); // Notify listeners
              },
            ),
          ),
      ],
    );
  }
}
