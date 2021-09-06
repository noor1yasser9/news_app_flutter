import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/bloc/GetTopHeadlinesBloc.dart';
import 'package:news_app/model/article.dart';
import 'package:news_app/model/article_response.dart';
import 'package:news_app/ui/screen/SourceDetailsScreen.dart';
import 'package:news_app/utils/Error.dart';
import 'package:news_app/utils/function.dart';
import 'package:news_app/utils/loader.dart';

class HeadlineSlider extends StatefulWidget {
  const HeadlineSlider({Key key}) : super(key: key);

  @override
  _HeadlineSliderState createState() => _HeadlineSliderState();
}

class _HeadlineSliderState extends State<HeadlineSlider> {
  @override
  void initState() {
    super.initState();
    getTopHeadlinesBloc..getHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: getTopHeadlinesBloc.subject.stream,
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data.error != null && snap.data.error.length > 0) {
            return buildErrorWidget(snap.data.error);
          }
          return _buildHeadlineSliderWidget(snap.data);
        } else if (snap.hasError) {
          return buildErrorWidget(snap.data.error);
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildHeadlineSliderWidget(ArticleResponse data) {
    List<ArticleModel> article = data.articles;
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
            enlargeCenterPage: false, height: 200.0, viewportFraction: 0.9),
        items: getExpenseSlider(article),
      ),
    );
  }

  getExpenseSlider(List<ArticleModel> article) {
    return article
        .map(
          (e) => GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: e.img == null
                            ? AssetImage("assets/img/placeholder.jpg")
                            : NetworkImage(e.img),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [
                            0.1,
                            0.9
                          ],
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.white.withOpacity(0.0)
                          ]),
                    ),
                  ),
                  Positioned(
                    bottom: 30.0,
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      width: 250.0,
                      child: Column(
                        children: [
                          Text(
                            e.title,
                            style: TextStyle(
                                height: 1.5,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10.0,
                    left: 10.0,
                    child: Text(
                      e.source.name,
                      style: TextStyle(color: Colors.white54, fontSize: 9.0),
                    ),
                  ),
                  Positioned(
                    bottom: 10.0,
                    right: 10.0,
                    child: Text(
                      timeUntil(
                        DateTime.parse(e.date),
                      ),
                      style: TextStyle(color: Colors.white54, fontSize: 9.0),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
        .toList();
  }
}
