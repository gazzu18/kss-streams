import 'dart:async';

import 'package:streams_demo/home/home_repository.dart';
import 'package:streams_demo/home/home_service.dart';
import 'package:streams_demo/utils/network_state.dart';



final homeService = HomeService();
final homeRepository = HomeRepository(homeService: homeService);
final homeController = HomeController(homeRepository: homeRepository);

class HomeController {
  final HomeRepository homeRepository;
  final StreamController<NetworkState> articleState = StreamController<NetworkState>();

  HomeController({required this.homeRepository});

  Future<void> fetchArticles() async {
    articleState.add(NetworkStateLoading());
    try {
      final articlesList = await homeRepository.getArticles();
      articleState.add(NetworkStateSuccess(data: articlesList));
    } catch (ex) {
      articleState.add(NetworkStateError(errorMessage: ex.toString()));
    }
  }

  void dispose() {
    articleState.close();
  }
}
