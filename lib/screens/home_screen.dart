import 'package:flutter/material.dart';
import '../screens/category_news_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'business',
      'entertainment',
      'general',
      'health',
      'science',
      'sports',
      'technology'
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text(
          'News Categories',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 3,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 버튼을 2열로 배치
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CategoryNewsScreen(category: category),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 6,
                shadowColor: Colors.black,
                backgroundColor: Colors.yellow[800],
                padding: const EdgeInsets.all(16),
              ),
              child: Text(
                category[0].toUpperCase() + category.substring(1), // 첫 글자 대문자
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}
