import 'dart:convert';
import 'package:http/http.dart' as http;
import 'class.dart';

class NewsService {
  final String apiKey = '8bfd38043c404f2a87b4bfee7dd942aa';
  final String baseUrl = 'https://newsapi.org/v2/top-headlines';

  Future<NewsModel> fetchNews(String country) async {
    final response = await http.get(
      Uri.parse('$baseUrl?country=$country&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      return NewsModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load news');
    }
    }
}