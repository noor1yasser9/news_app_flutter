import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:news_app/bloc/BottomNavBarBloc.dart';
import 'package:news_app/style/ThemeStyle.dart';
import 'package:news_app/ui/screen/tabs/SearchScreen.dart';
import 'package:news_app/ui/screen/tabs/SourceScreen.dart';
import 'package:news_app/ui/screen/tabs/home/HomeScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BottomNavBarBloc _bottomNavBarBloc;

  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeStyle.dark,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: ThemeStyle.mainColor,
          title: Text(
            "News App",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<NavBarItem>(
          stream: _bottomNavBarBloc.itemStream,
          initialData: _bottomNavBarBloc.defaultItem,
          builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
            switch (snapshot.data) {
              case NavBarItem.HOME:
                return HomeScreen();
              case NavBarItem.SOURCES:
                return SourceScreen();
              case NavBarItem.SEARCH:
                return SearchScreen();
            }
            return Container();
          },
        ),
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                child: BottomNavigationBar(
                  backgroundColor: ThemeStyle.mainColor,
                  iconSize: 20.0,
                  unselectedItemColor: ThemeStyle.titleColor,
                  unselectedFontSize: 9.5,
                  selectedFontSize: 9.5,
                  type: BottomNavigationBarType.fixed,
                  fixedColor: ThemeStyle.grey,
                  currentIndex: snapshot.data.index,
                  onTap: _bottomNavBarBloc.pickItem,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(EvaIcons.homeOutline),
                        label: "Home",
                        activeIcon: Icon(EvaIcons.home)),
                    BottomNavigationBarItem(
                        icon: Icon(EvaIcons.gridOutline),
                        label: "Source",
                        activeIcon: Icon(EvaIcons.grid)),
                    BottomNavigationBarItem(
                        icon: Icon(EvaIcons.searchOutline),
                        label: "Search",
                        activeIcon: Icon(EvaIcons.search))
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
