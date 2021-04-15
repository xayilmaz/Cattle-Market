import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come491_cattle_market/app/pages/update_post.dart';
import 'package:come491_cattle_market/common_widget/platform_duyarli_alertDialog.dart';
import 'package:come491_cattle_market/constants.dart';
import 'package:come491_cattle_market/model/posts.dart';
import 'package:come491_cattle_market/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPost extends StatefulWidget {
  @override
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Posts"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Posts>>(
          future: _userModel.getAllPosts(),
          builder: (context, sonuc) {
            if (sonuc.hasData) {
              var tumPost = sonuc.data;

              if (tumPost.length > 0) {
                return Column(
                  children: [
                    SizedBox(
                      height: 560,
                      child: RefreshIndicator(
                        onRefresh: _postingYenile,
                        child: ListView.builder(
                          itemCount: tumPost.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var oankiPost = sonuc.data[index];
                            if (oankiPost.userID == _userModel.user.userID) {
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UpdatePost(oankiPost))),
                                child: buildCard(oankiPost),
                              );
                            } else
                              return SizedBox(
                                height: 1,
                              );
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
                              fontSize: 18,
                              fontWeight: FontWeight.normal)),
                      GestureDetector(
                        child: Row(children: [Text("Delete"),Icon(
                          Icons.delete_outline,
                          size: 30,
                        )],),
                        onTap: () {
                          _deletePost(_userModel.user.userID, oankiPost.postID);
                          setState(() {});
                        },
                      )
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
                      GestureDetector(
                        child: oankiPost.state =="1" ? Row(children: [Text("Hide"),SizedBox(width: 4,),Icon(
                          Icons.remove_red_eye,
                          size: 30,
                        )],):Row(children: [Text("Show"),SizedBox(width: 4,),Icon(
                          Icons.remove_red_eye,
                          size: 30,
                          color: Colors.grey,
                        ),],),
                        onTap: () {
                          _showHide(_userModel.user.userID, oankiPost.postID,oankiPost.state);
                          setState(() {
                            _postingYenile();
                          });
                        },
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        oankiPost.price + " \$",
                        textAlign: TextAlign.right,
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

  Future<void> _deletePost(String userID, String postID) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    var dokumanlar = await _firestore
        .collection("posts")
        .where("post_id", isEqualTo: postID)
        .get();

    print("*********" + dokumanlar.docs[0].id);

    //Döküman silme
    await _firestore
        .collection("posts")
        .doc(dokumanlar.docs[0].id)
        .delete()
        .then((aa) {
      debugPrint("Kayıt Silindi");
    }).catchError(
            (e) => debugPrint("Kayıt Silinirken Hata Oluştu" + e.toString()));
  }

  Future<void> _showHide(String userID, String postID, String state) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    var dokumanlar = await _firestore
        .collection("posts")
        .where("post_id", isEqualTo: postID)
        .get();
    print("*********" + dokumanlar.docs[0].id);

    if(state =="1"){
      _firestore
          .collection("posts")
          .doc(dokumanlar.docs[0].id)
          .set({'state':"0"},SetOptions(merge: true))
          .then((v) => debugPrint("Changes."));

    }
    else{
      _firestore
          .collection("posts")
          .doc(dokumanlar.docs[0].id)
          .set({'state':"1"},SetOptions(merge: true))
          .then((v) => debugPrint("Changes."));
    }


  }
}
