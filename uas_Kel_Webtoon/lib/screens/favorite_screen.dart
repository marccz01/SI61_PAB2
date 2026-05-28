import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_daftar_webtoon/models/webtoon.dart';
import 'package:flutter_daftar_webtoon/screens/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritScreen extends StatefulWidget {
  const FavoritScreen({super.key});

  @override
  State<FavoritScreen> createState() => _FavoritScreenState();
}

class _FavoritScreenState extends State<FavoritScreen> {
  List<Webtoon> _favoriteWebtoons = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteWebtoons();
  }


  Future<void> _loadFavoriteWebtoons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //final List<String> favoriteWebtoonIds = prefs.getKeys().where((key) => key.startsWith('webtoon_')).toList();
    final List<String> favoriteWebtoonIds =
        prefs.getStringList('favoriteWebtoons') ?? [];


    //print('favoriteWebtoonIds: $favoriteWebtoonIds');
    setState(() {
      _favoriteWebtoons = favoriteWebtoonIds
          .map((id) {
            //final String? webtoonJson = prefs.getString(id);
            final String? webtoonJson = prefs.getString('webtoon_$id');
            if (webtoonJson != null && webtoonJson.isNotEmpty) {
              final Map<String, dynamic> webtoonData = jsonDecode(webtoonJson);
              return Webtoon.fromJson(webtoonData);
            }
            return null;
          })
          .where((webtoon) => webtoon != null)
          .cast<Webtoon>()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Webtoons'),
      ),
      body: ListView.builder(
        itemCount: _favoriteWebtoons.length,
        itemBuilder: (context, index) {
          final webtoon = _favoriteWebtoons[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(
                'https://image.tmdb.org/t/p/w500${webtoon.posterPath}',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Text(webtoon.title),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(webtoon: webtoon),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}