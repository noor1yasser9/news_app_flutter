import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:news_app/bloc/SearchBloc.dart';
import 'package:news_app/model/article.dart';
import 'package:news_app/model/article_response.dart';
import 'package:news_app/utils/NoData.dart';
import 'package:news_app/utils/function.dart';
import 'package:news_app/utils/loader.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchBloc..search("");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
          child: TextFormField(
            style: TextStyle(fontSize: 14.0, color: Colors.white70),
            controller: _searchController,
            onChanged: (changed) {
              searchBloc..search(_searchController.text);
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: Colors.black45,
              suffixIcon: _searchController.text.length > 0
                  ? IconButton(
                      icon: Icon(
                        EvaIcons.backspaceOutline,
                        color: Colors.grey[500],
                        size: 16.0,
                      ),
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _searchController.clear();
                          searchBloc..search(_searchController.text);
                        });
                      })
                  : Icon(
                      EvaIcons.searchOutline,
                      color: Colors.grey[500],
                      size: 16.0,
                    ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.grey[100].withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    new BorderSide(color: Colors.grey[100].withOpacity(0.3)),
              ),
              contentPadding: EdgeInsets.only(left: 15.0, right: 10.0),
              labelText: "Search...",
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500),
              labelStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
            autocorrect: false,
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
        Expanded(
            child: StreamBuilder<ArticleResponse>(
          stream: searchBloc.subject.stream,
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
    );
  }

  Widget _buildSourceNewsWidget(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;

    if (articles.length == 0) {
      return buildNoDataWidget("No more news", context);
    } else
      return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white54, width: 1.0),
                ),
                color: Colors.black26,
              ),
              height: 150,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
                    width: MediaQuery.of(context).size.width * 3 / 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          articles[index].title ?? '',
                          maxLines: 3,
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
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                        timeUntil(DateTime.parse(
                                            articles[index].date)),
                                        style: TextStyle(
                                            color: Colors.white38,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
