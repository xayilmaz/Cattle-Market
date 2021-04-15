import 'package:come491_cattle_market/app/pages/post_detail.dart';
import 'package:come491_cattle_market/common_widget/platform_duyarli_alertDialog.dart';
import 'package:come491_cattle_market/constants.dart';
import 'package:come491_cattle_market/model/posts.dart';
import 'package:come491_cattle_market/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_scroll_picker.dart';
import 'package:provider/provider.dart';

class Postings extends StatefulWidget {
  @override
  _PostingsState createState() => _PostingsState();
}

class _PostingsState extends State<Postings> {
  int age = -1;
  var selectedKind = "";
  List<String> kind = <String>[
    'Steer',
    'Calf',
    'Cow',
  ];

  var selectedUsState = "";
  List<String> usStates = <String>[
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
  ];

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    _userModel.getAllPosts();
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
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
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 5),
                          child: Text(
                            "Search",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: pColor),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        searchKind(),
                        SizedBox(
                          width: 10,
                        ),
                        searchLocation(),
                        IconButton(
                            icon: Icon(
                              Icons.refresh,
                              color: pColor,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedKind = "";
                                selectedUsState = "";
                              });
                            })
                      ],
                    ),
                    SizedBox(
                      height: 560,
                      child: RefreshIndicator(
                        onRefresh: _postingYenile,
                        child: ListView.builder(
                          itemCount: tumPost.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var oankiPost = sonuc.data[index];

                            if (selectedKind != "" && selectedUsState != "") {
                              if (oankiPost.kind == selectedKind &&
                                  oankiPost.location == selectedUsState && oankiPost.state=="1") {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetail(oankiPost))),
                                  child: buildCard(oankiPost),
                                );
                              } else
                                return SizedBox();
                            }
                            if (selectedUsState == "" && selectedKind != "") {
                              if (oankiPost.kind == selectedKind && oankiPost.state=="1") {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetail(oankiPost))),
                                  child: buildCard(oankiPost),
                                );
                              } else
                                return SizedBox();
                            }
                            if (selectedKind == "" && selectedUsState != "") {
                              if (oankiPost.location == selectedUsState && oankiPost.state=="1") {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetail(oankiPost))),
                                  child: buildCard(oankiPost),
                                );
                              } else
                                return SizedBox();
                            }
                            if (selectedKind != "" && selectedUsState == "" && oankiPost.state=="1") {
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PostDetail(oankiPost))),
                                child: buildCard(oankiPost),
                              );
                            } if( oankiPost.state=="1") {
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PostDetail(oankiPost))),
                                child: buildCard(oankiPost),
                              );
                            }else{
                              return SizedBox(height: 1,);
                            }
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

  Card buildCard(Posts oankiPost) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
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
                  borderRadius: BorderRadius.circular(8.0),
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
                              fontSize: 20,
                              fontWeight: FontWeight.normal)),
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

  searchKind() {
    return Container(
      width: 100,
      height: 30,
      child: RaisedButton(
        color: Colors.white,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: pColor),
        ),
        child: Text(
          selectedKind.toString() == "" ? "Kind" : selectedKind.toString(),
          style: TextStyle(color: pColor, fontFamily: 'Muli', fontSize: 18),
        ),
        onPressed: () => showMaterialScrollPicker(
          context: context,
          title: "Search Kind",
          showDivider: false,
          items: kind,
          selectedItem: selectedKind,
          onChanged: (value) => setState(() => selectedKind = value),
          onCancelled: () => print("Scroll Picker cancelled"),
          onConfirmed: () => print("Scroll Picker confirmed"),
        ),
      ),
    );
  }

  Future<Null> _postingYenile() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {});

    return null;
  }

  searchLocation() {
    return Container(
      width: 130,
      height: 30,
      child: RaisedButton(
        color: Colors.white,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: pColor),
        ),
        child: Text(
          selectedUsState.toString() == ""
              ? "Location"
              : selectedUsState.toString(),
          style: TextStyle(
            color: pColor,
            fontFamily: 'Muli',
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        onPressed: () => showMaterialScrollPicker(
          context: context,
          title: "Search City",
          showDivider: false,
          items: usStates,
          selectedItem: selectedUsState,
          onChanged: (value) => setState(() => selectedUsState = value),
          onCancelled: () => print("Scroll Picker cancelled"),
          onConfirmed: () => print("Scroll Picker confirmed"),
        ),
      ),
    );
  }
}
