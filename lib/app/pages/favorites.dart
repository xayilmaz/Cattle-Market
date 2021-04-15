import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come491_cattle_market/app/pages/post_detail2.dart';
import 'package:come491_cattle_market/common_widget/platform_duyarli_alertDialog.dart';
import 'package:come491_cattle_market/constants.dart';
import 'package:come491_cattle_market/model/posts.dart';
import 'package:come491_cattle_market/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List favoriler;

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite"),
      ),
      body: FutureBuilder<List<Posts>>(
        future: _userModel.getAllPosts(),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            var tumPost = sonuc.data;

            if (tumPost.length > 0) {
              return Column(
                children: [
                  SizedBox(
                    height: 610,
                    child: RefreshIndicator(
                      onRefresh: _postingYenile,
                      child: ListView.builder(
                        itemCount: tumPost.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          //_postingYenile();
                          var oankiPost = sonuc.data[index];
                          favorileriGetir(_userModel.user.userID);
                          if(favoriler != null){
                            if (favoriler.contains(oankiPost.postID)) {
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PostDetail2(oankiPost))),
                                child: buildCard(oankiPost),
                              );
                            } else
                              return SizedBox(
                                height: 1,
                              );
                          }
                          else return SizedBox(height: 1,);

                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return PlatformDuyarliAlertDialog("No Posting",
                  "No ads were found in the searched criteria", "Okey");
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<Null> _postingYenile() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {});

    return null;
  }

  Card buildCard(Posts oankiPost) {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.grey[100],
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 100,
        padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 12),
        child: Row(children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: NetworkImage(oankiPost.url1), fit: BoxFit.fill)),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 14,
            child: Container(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(oankiPost.title,
                          style: TextStyle(
                              color: pColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal)),
                      GestureDetector(child: Icon(Icons.remove_circle_outline,size: 30,),onTap: () {
                        _removePost(
                            _userModel.user.userID, oankiPost.postID);
                        setState(() {});
                      },)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        oankiPost.kind,
                        style: TextStyle(
                          color: pColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        oankiPost.price + " \$",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: pColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 18),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        oankiPost.location,
                        style: TextStyle(
                            color: pColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 18),
                      ),
                      Text(oankiPost.createdAt.toString().substring(0, 10),
                          style: TextStyle(
                              color: pColor,
                              fontSize: 18,
                              fontWeight: FontWeight.normal)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> favorileriGetir(String userID) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try{
      var documents = (await _firestore.collection('user_favorite').doc(userID).get());
      print(documents.data()['favorites'].length);
      favoriler = documents.data()['favorites'];
    }catch(e){
      print(e.toString());
      favoriler = null;
    }

    print("*******************");
    print(favoriler);
  }

  Future<void> _removePost(String userID, String postID) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    List gelenList = [postID];

    await _firestore
        .collection("user_favorite")
        .doc(userID)
        .update({"favorites": FieldValue.arrayRemove(gelenList)});
  }
}
