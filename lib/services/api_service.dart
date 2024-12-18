import 'package:dio/dio.dart';
import '../models/news_model.dart';
import '../consts.dart'; // API 키와 상수 로드

class ApiService {
  final Dio _dio = Dio();

  // 뉴스 데이터를 가져오는 메서드
  Future<List<NewsModel>> fetchNews() async {
    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'country': 'us',
          'category': 'business',
          'apiKey': NEWS_API_KEY, // consts.dart에 정의된 API 키
        },
      );

      // JSON 데이터를 리스트로 변환
      final articleList = response.data["articles"] as List;
      // JSON -> NewsModel 변환 및 필터링
      List<NewsModel> newsList =
          articleList.map((article) => NewsModel.fromJson(article)).toList();

      // 필터링: 제목이 "[Removed]"인 뉴스 제외
      return newsList.where((news) => news.title != "[Removed]").toList();
    } catch (e) {
      // 오류를 콘솔에 출력
      print('Error fetching news: $e');
      // 빈 리스트 반환
      return [];
    }
  }
}
