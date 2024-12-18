import 'package:dio/dio.dart';
import '../models/news_model.dart';
import '../consts.dart';

class ApiService {
  final Dio _dio = Dio();

  // 카테고리 기반 뉴스 가져오기
  Future<List<NewsModel>> fetchNewsByCategory(String category) async {
    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'country': 'us',
          'category': category, // 카테고리 동적 추가
          'apiKey': NEWS_API_KEY,
        },
      );

      final articleList = response.data["articles"] as List;
      List<NewsModel> newsList =
          articleList.map((article) => NewsModel.fromJson(article)).toList();

      // 제목이 "[Removed]"인 뉴스 제외
      return newsList.where((news) => news.title != "[Removed]").toList();
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }
}
