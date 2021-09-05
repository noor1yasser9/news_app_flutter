import 'package:flutter/material.dart';
import 'package:news_app/ui/screen/tabs/home/widgets/HeadlineSlider.dart';
import 'package:news_app/ui/screen/tabs/home/widgets/HotNews.dart';
import 'package:news_app/ui/screen/tabs/home/widgets/TopChannels.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HeadlineSlider(),
        Padding(
          padding: EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 10),
          child: Text(
            "Top Channels",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17
            ),
          ),
        ),
        TopChannels(),
        Padding(
          padding: EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 10),
          child: Text(
            "Hot News",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17
            ),
          ),
        ),
        HotNews(),
      ],
    );
  }
}
