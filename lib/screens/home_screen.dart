import 'package:flutter/material.dart';
import 'package:news_app/consts.dart';
import 'package:news_app/services/api_service.dart'; // ApiService 불러오기
import 'package:url_launcher/url_launcher.dart';
import '../models/news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService(); // ApiService 인스턴스 생성
  List<NewsModel> articles = [];

  @override
  void initState() {
    super.initState();
    _getNews(); // 뉴스 데이터를 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Business News",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.white.withOpacity(0.95),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    // 뉴스 데이터를 가져오는 동안 로딩 인디케이터 표시
    if (articles.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Card(
          color: Colors.white.withOpacity(0.95),
          elevation: 4.0, // 음영 추가
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            onTap: () {
              _launchUrl(
                Uri.parse(article.url ?? ""),
              );
            },
            leading: Image.network(
              article.urlToImage ?? PLACEHOLDER_IMAGE_LINK,
              height: 250,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(PLACEHOLDER_IMAGE_LINK, fit: BoxFit.cover);
              },
            ),
            title: Text(
              article.title ?? "",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              article.publishedAt != null
                  ? DateTime.parse(article.publishedAt!)
                      .toLocal()
                      .toString()
                      .substring(0, 16)
                  : "",
            ),
          ),
        );
      },
    );
  }

  Future<void> _getNews() async {
    // ApiService를 사용하여 뉴스 데이터를 가져옴
    List<NewsModel> fetchedArticles = await apiService.fetchNews();
    setState(() {
      articles = fetchedArticles; // 상태 업데이트
    });
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
