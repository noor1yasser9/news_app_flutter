import 'package:flutter/material.dart';
import 'package:news_app/bloc/GetSourceBloc.dart';
import 'package:news_app/model/source.dart';
import 'package:news_app/model/source_response.dart';
import 'package:news_app/ui/screen/SourceDetailsScreen.dart';
import 'package:news_app/utils/NoData.dart';
import 'package:news_app/utils/loader.dart';

class SourceScreen extends StatefulWidget {
  const SourceScreen({Key key}) : super(key: key);

  @override
  _SourceScreenState createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {
  @override
  void initState() {
    super.initState();
    getSourcesBloc..getSource();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceResponse>(
      stream: getSourcesBloc.subject.stream,
      builder: (context, AsyncSnapshot<SourceResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return Container();
          }
          return _buildSourcesWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildSourcesWidget(data) {
    List<SourceModel> sources = data.sources;
    if (sources.length == 0) {
      return buildNoDataWidget("No More Sources", context);
    } else
      return GridView.builder(
        itemCount: sources.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.86),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SourceDetailsScreen(
                      source: sources[index],
                    ),
                  ),
                );
              },
              child: Container(
                width: 100.0,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[700],
                      blurRadius: 2.0,
                      spreadRadius: 0.50,
                      offset: Offset(
                        1.0,
                        1.0,
                      ),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: sources[index].id,
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/logos/${sources[index].id}.png"),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
                      child: Text(
                        sources[index].name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }
}
