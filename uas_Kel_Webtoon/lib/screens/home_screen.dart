import 'package:flutter/material.dart';
import 'package:flutter_daftar_webtoon/models/webtoon.dart';
import 'package:flutter_daftar_webtoon/screens/detail_screen.dart';
import 'package:flutter_daftar_webtoon/services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<Webtoon> _allWebtoon = [];
  List<Webtoon> _trendingWebtoons = [];
  List<Webtoon> _popularWebtoons = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadWebtoons();
  }

  Future<void> _loadWebtoons() async {
    final List<Map<String, dynamic>> allWebtoonsData = await _apiService
        .getAllWebtoons();
    final List<Map<String, dynamic>> trendingWebtoonsData = await _apiService
        .getTrendingWebtoons();
    final List<Map<String, dynamic>> popularWebtoonsData = await _apiService
        .getPopularWebtoons();

    setState(() {
      _allWebtoons = allWebtoonsData.map((e) => Webtoon.fromJson(e)).toList();
      _trendingWebtoons = trendingWebtoonsData
          .map((e) => Webtoon.fromJson(e))
          .toList();
      _popularWebtoons = popularvsData.map((e) => Webtoon.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Film')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWebtoonsList('All Webtoons', _allWebtoons),
            _buildWebtoonsList('Trending Webtoons', _trendingWebtoons),
            _buildWebtoonsList('Popular Webtoons', _popularWebtoons),
          ],
        ),
      ),
    );
  }

  Widget _buildWebtoonsList(String title, List<Webtoon> Webtoons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: Webtoons.length,
            itemBuilder: (BuildContext context, int index) {
              final Webtoon webtoon = webtoons[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    // Handle webtoontap, e.g., navigate to details page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(webtoon : webtoon),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.network(
                        'https://image.tmdb.org/t/p/w500${webtoon.posterPath}',
                        height: 150,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        webtoon.title.length > 14
                            ? '${webtoon.title.substring(0, 10)}...'
                            : webtoon.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
