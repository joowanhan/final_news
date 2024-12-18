import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/news_model.dart';
import '../consts.dart';

class CategoryNewsScreen extends StatefulWidget {
  final String category;
  const CategoryNewsScreen({super.key, required this.category});

  @override
  State<CategoryNewsScreen> createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends State<CategoryNewsScreen> {
  final ApiService _apiService = ApiService();
  List<NewsModel> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategoryNews();
  }

  Future<void> _fetchCategoryNews() async {
    final fetchedArticles =
        await _apiService.fetchNewsByCategory(widget.category);
    setState(() {
      articles = fetchedArticles;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 3,
        shadowColor: Colors.black,
        title: Text(
          widget.category[0].toUpperCase() + widget.category.substring(1),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : articles.isEmpty
              ? const Center(child: Text('No articles found.'))
              : ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Card(
                      shadowColor: Colors.black,
                      color: Colors.white.withOpacity(0.9),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      elevation: 18.0,
                      child: ListTile(
                        onTap: () {
                          _launchUrl(Uri.parse(article.url ?? ""));
                        },
                        leading: Image.network(
                          article.urlToImage ?? PLACEHOLDER_IMAGE_LINK,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(PLACEHOLDER_IMAGE_LINK,
                                fit: BoxFit.cover);
                          },
                        ),
                        title: Text(article.title ?? "No Title"),
                        subtitle: Text(article.publishedAt != null
                            ? DateTime.parse(article.publishedAt!)
                                .toLocal()
                                .toString()
                                .substring(0, 16)
                            : ""),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
