import 'package:come491_cattle_market/app/tab_items.dart';
import 'package:come491_cattle_market/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomBottomNavigation extends StatelessWidget {
  const MyCustomBottomNavigation(
      {Key key,
      @required this.currentTab,
      @required this.onSelectedTab,
      @required this.sayfaOlusturucu,
      this.navigatorKeys})
      : super(key: key);
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> sayfaOlusturucu;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            activeColor: kPrimaryColor,
            items: [
              _naviItemOlustur(TabItem.Posts),
              _naviItemOlustur(TabItem.MyPost),
              _naviItemOlustur(TabItem.AddPost),
              _naviItemOlustur(TabItem.Favorite),
              _naviItemOlustur(TabItem.Profile),
            ],
            onTap: (index) {
              onSelectedTab(TabItem.values[index]);
            }),
        tabBuilder: (context, index) {
          final gosterilecekItem = TabItem.values[index];
          return CupertinoTabView(
            navigatorKey: navigatorKeys[gosterilecekItem],
            builder: (context) {
              return sayfaOlusturucu[gosterilecekItem];
            },
          );
        });
  }

  BottomNavigationBarItem _naviItemOlustur(TabItem tabItem) {
    final olusturulacakTab = TabItemData.tumTablar[tabItem];

    return BottomNavigationBarItem(
        icon: Icon(olusturulacakTab.icon), title: Text(olusturulacakTab.title));
  }
}
