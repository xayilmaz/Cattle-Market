import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come491_cattle_market/constants.dart';
import 'package:come491_cattle_market/model/user.dart';
import 'package:come491_cattle_market/viewmodel/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class UserDetail extends StatefulWidget {
  final String gelenUserID;

  const UserDetail({Key key, this.gelenUserID}) : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  var starState = true;


  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);

    print("---------------------");
    _userModel.getUser(widget.gelenUserID);
    _userModel.getUser(widget.gelenUserID);
    print("---------------------");

    return Scaffold(
      appBar: AppBar(
        title: Text("Seller Detail"),
      ),
      body: FutureBuilder<List<Kullanici>>(
        future: _userModel.getUser(widget.gelenUserID),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            var starPoint = sonuc.data[0].rank + .0;
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(sonuc.data[0].profilURL),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      sonuc.data[0].nameSurname,
                      style: TextStyle(fontSize: 28, color: pColor),
                    ),
                    RatingBar.builder(
                      ignoreGestures: starState == true ? false : true,
                      initialRating: starPoint = sonuc.data[0].rank + .0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        updatePoint(sonuc.data[0].userID, rating, context);
                        setState(() {
                          starState = false;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: pColor)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 36,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(sonuc.data[0].mobileNumber,
                                style: TextStyle(fontSize: 16, color: pColor)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: pColor)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.email,
                              size: 36,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(sonuc.data[0].email,
                                style: TextStyle(fontSize: 16, color: pColor)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: pColor)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 36,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(sonuc.data[0].location,
                                style: TextStyle(fontSize: 16, color: pColor)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: pColor)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "About",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: kLogoColor,
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'Noto'),
                              ),
                              Text(sonuc.data[0].about,
                                  style: TextStyle(fontSize: 16, color: pColor))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Call",
                          style: TextStyle(fontSize: 30),
                        ),
                        IconButton(
                            icon: Icon(Icons.call,size: 34,),
                            onPressed: () async {
                              FlutterPhoneDirectCaller.callNumber(
                                  sonuc.data[0].mobileNumber);
                            })
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
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

  Future<void> updatePoint(
      String userID, double rating, BuildContext context) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);

    List pointsList = [];
    List getIDList = [];
    getIDList.add(userID);

    try {
      var documents = (await _firestore
          .collection('users_point')
          .doc(_userModel.user.userID)
          .get());
      print(documents.data()['gettingID'].length);
      pointsList = documents.data()['gettingID'];
    } catch (e) {
      print(e.toString());
      pointsList = null;
    }
    print(pointsList.toString());

    if (pointsList != null && pointsList.contains(userID)) {
      print("zaten oylama yapılmış");
      setState(() {
        starState = false;
      });

    } else {
      final snapShot = await _firestore
          .collection('user_point')
          .doc(_userModel.user.userID)
          .get();

      if (snapShot == null || !snapShot.exists) {
        await _firestore
            .collection("users_point")
            .doc(_userModel.user.userID)
            .set({'gettingID': FieldValue.arrayUnion(getIDList)},
                SetOptions(merge: true));
      } else {
        await _firestore
            .collection("users_point")
            .doc(_userModel.user.userID)
            .update({'gettingID': FieldValue.arrayUnion(getIDList)});
      }

      DocumentSnapshot documentSnapshot =
          await _firestore.collection("users").doc(userID).get();

      var gelenDeger = documentSnapshot.data()['rank'];

      print("gelen değer : " + gelenDeger.toString());

      var yenideger = (gelenDeger + rating) / 2;
      _firestore
          .collection("users")
          .doc(userID)
          .set({'rank': yenideger}, SetOptions(merge: true)).then(
              (v) => debugPrint("Point Güncellendi."));
    }
  }
}
