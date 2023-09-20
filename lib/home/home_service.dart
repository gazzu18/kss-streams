import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:streams_demo/home/article.dart';

class HomeService {
  Future<List<Article>> fetchArticles() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final List<Article> articles =
          jsonList.map((json) => Article.fromJson(json)).toList();
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
