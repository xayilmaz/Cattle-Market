import 'package:flutter/material.dart';

enum TabItem { Posts, MyPost, AddPost, Favorite, Profile }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Posts: TabItemData("Post", Icons.list_sharp),
    TabItem.MyPost: TabItemData("My Post", Icons.article_outlined),
    TabItem.AddPost: TabItemData("Add Post", Icons.add_circle_outline_rounded),
    TabItem.Favorite: TabItemData("Favorite", Icons.favorite_border),
    TabItem.Profile: TabItemData("Profile", Icons.person),
  };
}
