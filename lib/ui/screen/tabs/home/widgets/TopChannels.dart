import 'package:flutter/material.dart';
import 'package:news_app/bloc/GetSourceBloc.dart';
import 'package:news_app/model/source.dart';
import 'package:news_app/model/source_response.dart';
import 'package:news_app/ui/screen/SourceDetailsScreen.dart';
import 'package:news_app/utils/Error.dart';
import 'package:news_app/utils/loader.dart';

class TopChannels extends StatefulWidget {
  const TopChannels({Key key}) : super(key: key);

  @override
  _TopChannelsState createState() => _TopChannelsState();
}

class _TopChannelsState extends State<TopChannels> {
  @override
  void initState() {
    super.initState();
    getSourcesBloc..getSource();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceResponse>(
      stream: getSourcesBloc.subject.stream,
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data.error != null && snap.data.error.length > 0) {
            return buildErrorWidget(snap.data.error);
          }
          return _buildTopChannelsWidget(snap.data);
        } else if (snap.hasError) {
          return buildErrorWidget(snap.data.error);
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildTopChannelsWidget(SourceResponse data) {
    List<SourceModel> source = data.sources;
    if (source.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [Text("No source")],
        ),
      );
    } else {
      return Container(
        height: 115.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: source.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(top: 10.0),
                width: 80.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SourceDetailsScreen(
                                  source: source[index],
                                )));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: source[index].id,
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.white12,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: Offset(1, 1))
                              ],
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/logos/${source[index].id}.png"))),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        source[index].name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.4,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        source[index].category,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54, fontSize: 9),
                      )
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }
}
