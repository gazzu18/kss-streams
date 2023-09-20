
import 'package:streams_demo/home/article.dart';
import 'package:streams_demo/home/home_service.dart';
class HomeRepository {
  final HomeService homeService;

  HomeRepository({required this.homeService});

  Future<List<Article>> getArticles() => homeService.fetchArticles();
}
