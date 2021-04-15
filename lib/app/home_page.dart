import 'package:come491_cattle_market/app/kullanicilar.dart';
import 'package:come491_cattle_market/app/my_custom_buttom_navi.dart';
import 'package:come491_cattle_market/app/pages/addpost.dart';
import 'package:come491_cattle_market/app/pages/favorites.dart';
import 'package:come491_cattle_market/app/pages/my_posts.dart';
import 'package:come491_cattle_market/app/pages/postings.dart';
import 'package:come491_cattle_market/app/pages/profiles.dart';
import 'package:come491_cattle_market/app/tab_items.dart';
import 'package:come491_cattle_market/model/user.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Kullanici user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Posts;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Posts: GlobalKey<NavigatorState>(),
    TabItem.AddPost: GlobalKey<NavigatorState>(),
    TabItem.Favorite: GlobalKey<NavigatorState>(),
    TabItem.Profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Posts: Postings(),
      TabItem.MyPost: MyPost(),
      TabItem.AddPost: AddPost(),
      TabItem.Favorite: Favorite(),
      TabItem.Profile: Profile(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        navigatorKeys: navigatorKeys,
        sayfaOlusturucu: tumSayfalar(),
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
            debugPrint("Seçilen Tab Item" + secilenTab.toString());
          }
        },
      ),
    );
  }
}
