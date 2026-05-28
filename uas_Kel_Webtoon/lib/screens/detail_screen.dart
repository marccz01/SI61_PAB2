import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_daftar_webtoon/models/webtoon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Webtoon webtoon;

  const DetailScreen({super.key, required this.webtoon});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIsFavorite();
  }

  Future<void> _checkIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = prefs.containsKey('webtoon_${widget.webtoon.id}');
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (_isFavorite) {
      final String webtoonJson = jsonEncode(widget.webtoon.toJson());
      prefs.setString('webtoon_${widget.webtoon.id}', webtoonJson);

      List<String> favoriteWebtoonIds =
          prefs.getStringList('favoriteWebtoons') ?? [];

      favoriteWebtoonIds.add(widget.webtoon.id.toString());
      prefs.setStringList('favoriteWebtoons', favoriteWebtoonIds);
    } else {
      prefs.remove('webtoon_${widget.webtoon.id}');

      List<String> favoriteWebtoonIds =
          prefs.getStringList('favoriteWebtoons') ?? [];
      favoriteWebtoonIds.remove(widget.webtoon.id.toString());
      prefs.setStringList('favoriteWebtoons', favoriteWebtoonIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.webtoon.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                widget.webtoon.backdropPath != ''
                    ? 'https://image.tmdb.org/t/p/w500${widget.webtoon.backdropPath}'
                    : 'https://via.placeholder.com/500?text=No+Image',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: _toggleFavorite,
                  // onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Overview:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(widget.webtoon.overview),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.calendar_month, color: Colors.blue),
              const SizedBox(width: 10),
              const Text(
                'Release Date:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Text(widget.webtoon.releaseDate),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 10),
              const Text(
                'Rating:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Text(widget.webtoon.voteAverage.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
