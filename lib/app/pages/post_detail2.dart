import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come491_cattle_market/app/pages/user_detail.dart';
import 'package:come491_cattle_market/common_widget/platform_duyarli_alertDialog.dart';
import 'package:come491_cattle_market/components/image_content.dart';
import 'package:come491_cattle_market/constants.dart';
import 'package:come491_cattle_market/model/posts.dart';
import 'package:come491_cattle_market/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostDetail2 extends StatefulWidget {
  final Posts gelenPost;

  const PostDetail2(this.gelenPost);

  @override
  _PostDetail2State createState() => _PostDetail2State(gelenPost);
}

class _PostDetail2State extends State<PostDetail2> {
  PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;
  Posts gelenPost;

  _PostDetail2State(this.gelenPost);

  PageController controller = PageController();
  var currentPageValue = 0.0;
  List<String> splashData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    splashData = [
      gelenPost.url1,
      gelenPost.url2,
      gelenPost.url3,
      gelenPost.url4,
    ];
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    print("---------------------");
    _userModel.getUser(gelenPost.userID);
    _userModel.getUserName(gelenPost.userID);
    print("---------------------");

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        actionsIconTheme: IconThemeData(color: kPrimaryColor),
        actions: [
          FlatButton(
              onPressed: () {
                _removePost(_userModel.user.userID, gelenPost.postID);
                print("favori eklendi");
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Icon(
                  Icons.remove_circle_outline,
                  size: 34,
                  color: kLogoColor,
                ),
              ))
        ],
        title: Text("Post Details"),
      ),
      body: FutureBuilder<String>(
        future: _userModel.getUserName(gelenPost.userID),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            return SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 260,
                      width: double.infinity,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (value) {
                          setState(() {
                            currentPage = value;
                          });
                        },
                        itemCount: splashData.length,
                        itemBuilder: (context, index) => ImageContent(
                          image: splashData[index],
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            splashData.length,
                            (index) => buildDot(index: index),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      gelenPost.title,
                      style: TextStyle(
                          fontSize: 26, color: pColor, fontFamily: 'Noto'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(gelenPost.price + " \$",
                            style: TextStyle(
                                fontSize: 24,
                                color: pColor,
                                fontFamily: 'Noto')),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 20, top: 5),
                      child: Container(
                        height: 35,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: pColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserDetail(
                                            gelenUserID: gelenPost.userID,
                                          ))),
                              child: Text(sonuc.data,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: kLogoColor,
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'Noto')),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.all(color: pColor)),
                                child: Column(
                                  children: [
                                    Text("Kind",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: pColor,
                                            decoration:
                                                TextDecoration.underline,
                                            fontFamily: 'Noto')),
                                    Text(gelenPost.kind,
                                        style: TextStyle(
                                            fontSize: 20, color: pColor)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 60,
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.all(color: pColor)),
                                child: Column(
                                  children: [
                                    Text(
                                      "Age",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: pColor,
                                          decoration: TextDecoration.underline,
                                          fontFamily: 'Noto'),
                                    ),
                                    Text(
                                      gelenPost.age,
                                      style: TextStyle(
                                          fontSize: 20, color: pColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.all(color: pColor)),
                                child: Column(
                                  children: [
                                    Text("Weight",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: pColor,
                                            decoration:
                                                TextDecoration.underline,
                                            fontFamily: 'Noto')),
                                    Text(gelenPost.width + " Kg",
                                        style: TextStyle(
                                            fontSize: 20, color: pColor)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 60,
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.all(color: pColor)),
                                child: Column(
                                  children: [
                                    Text(
                                      "Ear No",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: pColor,
                                          decoration: TextDecoration.underline,
                                          fontFamily: 'Noto'),
                                    ),
                                    Text(
                                      gelenPost.earringNo.toString(),
                                      style: TextStyle(
                                          fontSize: 20, color: pColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.all(color: pColor)),
                                child: Column(
                                  children: [
                                    Text("Height",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: pColor,
                                            decoration:
                                                TextDecoration.underline,
                                            fontFamily: 'Noto')),
                                    Text(gelenPost.height + " cm",
                                        style: TextStyle(
                                            fontSize: 20, color: pColor)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 60,
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.all(color: pColor)),
                                child: Column(
                                  children: [
                                    Text("Location",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: pColor,
                                            decoration:
                                                TextDecoration.underline,
                                            fontFamily: 'Noto')),
                                    Text(gelenPost.location,
                                        style: TextStyle(
                                            fontSize: 18, color: pColor)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 5, right: 20, left: 25),
                      child: Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: pColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Added : ",
                                style: TextStyle(fontSize: 18, color: pColor)),
                            Text(
                                gelenPost.createdAt.toString().substring(0, 11),
                                style: TextStyle(fontSize: 18, color: pColor))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 20, top: 5),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: pColor)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: pColor,
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'Noto'),
                              ),
                              Text(gelenPost.desc,
                                  style: TextStyle(fontSize: 20, color: pColor))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Future<void> _removePost(String userID, String postID) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    List gelenList = [postID];

    await _firestore
        .collection("user_favorite")
        .doc(userID)
        .update({"favorites": FieldValue.arrayRemove(gelenList)});

    Navigator.pop(context);
  }
}
