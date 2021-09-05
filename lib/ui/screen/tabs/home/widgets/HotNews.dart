import 'package:flutter/material.dart';
import 'package:news_app/bloc/GetHotNewsBloc.dart';
import 'package:news_app/model/article.dart';
import 'package:news_app/model/article_response.dart';
import 'package:news_app/style/ThemeStyle.dart';
import 'package:news_app/utils/Error.dart';
import 'package:news_app/utils/function.dart';
import 'package:news_app/utils/loader.dart';

class HotNews extends StatefulWidget {
  const HotNews({Key key}) : super(key: key);

  @override
  _HotNewsState createState() => _HotNewsState();
}

class _HotNewsState extends State<HotNews> {
  @override
  void initState() {
    super.initState();
    getHotNewsBloc..getHotNews();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: getHotNewsBloc.subject.stream,
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data.error != null && snap.data.error.length > 0) {
            return buildErrorWidget(snap.data.error);
          }
          return _buildHotNewsWidget(snap.data);
        } else if (snap.hasError) {
          return buildErrorWidget(snap.data.error);
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildHotNewsWidget(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;

    if (articles.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "No more news",
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: articles.length / 2 * 210.0,
        padding: EdgeInsets.all(5.0),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: articles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.85),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 220.0,
                  decoration: BoxDecoration(
                    color: ThemeStyle.mainColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0)),
                                image: DecorationImage(
                                    image: articles[index].img == null
                                        ? AssetImage(
                                            "assets/img/placeholder.jpg")
                                        : NetworkImage(articles[index].img),
                                    fit: BoxFit.cover)),
                          )),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            width: 180,
                            height: 1.0,
                            color: Colors.black12,
                          ),
                          Container(
                            width: 30,
                            height: 3.0,
                            color: ThemeStyle.mainColor,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                articles[index].source.name,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 9.0),
                              ),
                              Text(
                                timeUntil(DateTime.parse(articles[index].date)),
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 9.0),
                              )
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          articles[index].content,
                          maxLines: 5,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 9.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }


}
