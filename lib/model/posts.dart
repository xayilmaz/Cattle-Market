import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Posts {
  final String userID;
  String postID;
  String url1;
  String url2;
  String url3;
  String url4;
  String title;
  String age;
  String kind;
  String price;
  String width;
  String height;
  String location;
  int earringNo;
  String desc;
  DateTime createdAt;
  String state;

  Posts(
      this.userID,
      this.url1,
      this.url2,
      this.url3,
      this.url4,
      this.title,
      this.age,
      this.kind,
      this.price,
      this.width,
      this.height,
      this.location,
      this.earringNo,
      this.desc,
      this.createdAt,
      this.state);

  Posts.fromMap(Map<String, dynamic> map)
      : userID = map['user_id'],
        postID = map['post_id'],
        url1 = map['url1'],
        url2 = map['url2'],
        url3 = map['url3'],
        url4 = map['url4'],
        title = map['title'],
        age = map['age'],
        kind = map['kind'],
        price = map['price'],
        width = map['width'],
        height = map['height'],
        location = map['location'],
        earringNo = map['earringNo'],
        desc = map['desc'],
        createdAt = (map['addedTime'] as Timestamp).toDate(),
        state = map['state'];

  @override
  String toString() {
    return 'Posts{userID: $userID, postID: $postID, url1: $url1, url2: $url2, url3: $url3, url4: $url4, title: $title, age: $age, kind: $kind, price: $price, width: $width, height: $height, location: $location, earringNo: $earringNo, desc: $desc, createdAt: $createdAt}';
  }
}
