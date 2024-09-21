import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';
  String _searchResult = 'Search for a word';
  bool _isLoading = false;

  Future<void> _searchWord() async {
    if (_searchQuery.isEmpty) {
      setState(() {
        _searchResult = "Please enter a word to search.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _searchResult = 'Searching...';
    });

    final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$_searchQuery');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data.isNotEmpty && data[0]['meanings'] != null) {
          setState(() {
            _searchResult = data[0]['meanings'][0]['definitions'][0]['definition'];
          });
        } else {
          setState(() {
            _searchResult = "No definition found.";
          });
        }
      } else {
        setState(() {
          _searchResult = "Error fetching definition.";
        });
      }
    } catch (e) {
      setState(() {
        _searchResult = "Error fetching definition.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter a word',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim(); // Trim whitespace
                  });
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _searchWord,
                child: Text('Search'),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Text(_searchResult),
            ],
          ),
        ),
      ),
    );
  }
}
