import 'package:flutter/material.dart';
import 'package:news_app/bloc/GetSourceNewsBloc.dart';
import 'package:news_app/model/article.dart';
import 'package:news_app/model/article_response.dart';
import 'package:news_app/model/source.dart';
import 'package:news_app/style/ThemeStyle.dart';
import 'package:news_app/utils/function.dart';
import 'package:news_app/utils/loader.dart';

class SourceDetailsScreen extends StatefulWidget {
  final SourceModel source;

  const SourceDetailsScreen({Key key, @required this.source}) : super(key: key);

  @override
  _SourceDetailsScreen createState() => _SourceDetailsScreen(source);
}

class _SourceDetailsScreen extends State<SourceDetailsScreen> {
  final SourceModel source;

  _SourceDetailsScreen(this.source);

  @override
  void initState() {
    super.initState();
    getSourceNewsBloc..getSourceNews(source.id);
  }

  @override
  void dispose() {
    getSourceNewsBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeStyle.dark,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            centerTitle: false,
            elevation: 0.0,
            backgroundColor: ThemeStyle.mainColor,
            title: new Text(
              "",
            )),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            color: ThemeStyle.mainColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Hero(
                  tag: source.id,
                  child: SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2.0, color: Colors.white),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/logos/${source.id}.png"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  source.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  source.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder<ArticleResponse>(
            stream: getSourceNewsBloc.subject.stream,
            builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return Container();
                }
                return _buildSourceNewsWidget(snapshot.data);
              } else if (snapshot.hasError) {
                return Container();
              } else {
                return buildLoadingWidget();
              }
            },
          ))
        ],
      ),
    );
  }

  Widget _buildSourceNewsWidget(ArticleResponse data) {
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
    } else
      return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => DetailNews(
              //           article: articles[index],
              //         )));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white54, width: 1.0),
                ),
                color: Colors.black26,
              ),
              height: 150,
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
                    width: MediaQuery.of(context).size.width * 3 / 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          articles[index].title ?? "",
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13.0,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          articles[index].content ?? '',
                          maxLines: 5,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                            fontSize: 12.0,
                          ),
                        ),
                        Expanded(
                            child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    timeUntil(
                                        DateTime.parse(articles[index].date)),
                                    style: TextStyle(
                                      color: Colors.white38,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 10.0),
                      width: MediaQuery.of(context).size.width * 2 / 5,
                      height: 130,
                      child: FadeInImage.assetNetwork(
                          alignment: Alignment.topCenter,
                          placeholder: 'assets/img/placeholder.jpg',
                          image: articles[index].img == null
                              ? "http://to-let.com.bd/operator/images/noimage.png"
                              : articles[index].img,
                          fit: BoxFit.fitHeight,
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * 1 / 3))
                ],
              ),
            ),
          );
        },
      );
  }
}
