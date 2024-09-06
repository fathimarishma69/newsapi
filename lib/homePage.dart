import 'package:flutter/material.dart';
import 'package:newsapi/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'class.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<NewsModel> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = NewsService().fetchNews('us');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Daily News'),
      ),
      body: FutureBuilder<NewsModel>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.articles == null || snapshot.data!.articles!.isEmpty) {
            return Center(child: Text('No news available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.articles!.length,
              itemBuilder: (context, index) {
                final article = snapshot.data!.articles![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.urlToImage != null)
                        Image.network(
                          article.urlToImage!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.title ?? 'No title',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              article.description ?? 'No description',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                if (article.url != null) {
                                  _launchURL(article.url!);
                                }
                              },
                              child: Text(
                                'Read More',
                                style: TextStyle(color: Colors.purple),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
