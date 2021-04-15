import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come491_cattle_market/app/sign_in/sign_in_email.dart';
import 'package:come491_cattle_market/common_widget/platform_duyarli_alertDialog.dart';
import 'package:come491_cattle_market/components/custom_button.dart';
import 'package:come491_cattle_market/model/user.dart';
import 'package:come491_cattle_market/viewmodel/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../constants.dart';
import '../hata_exception.dart';

enum FormType { Busy, Idle }

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  var _formType = FormType.Idle;

  File _postResim1;
  File _postResim2;
  File _postResim3;
  File _postResim4;

  String url1;
  String url2;
  String url3;
  String url4;

  var age = -1;
  double _currentSliderValue = 0;
  double _currentWidthValue = 0;
  double _currentHeightValue = 0;
  String _title;
  String _desc;
  int earingNo;

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

  var selectedKind = "";
  List<String> kind = <String>[
    'Steer',
    'Calf',
    'Cow',
  ];

  _addPost(
      BuildContext context,
      String age,
      String _title,
      String selectedKind,
      String _currentSliderValue,
      String _currentWidthValue,
      String _currentHeightValue,
      String selectedUsState,
      String _desc) async {
    //_formKey.currentState.save();
    //debugPrint("Email : $_email Password: $_sifre");
    final _userModel = Provider.of<UserModel>(context, listen: false);
    try {
      // Kullanici _olusturulanUser =
      // await _userModel.createUserWithEmailandPassword(_email, _sifre);
      var uuid = Uuid();
      print(uuid.v1());

      _firestore.collection("posts").doc().set({
        'post_id': uuid.v1(),
        'addedTime': FieldValue.serverTimestamp(),
        'age': age,
        'location': selectedUsState,
        'price': _currentSliderValue,
        'title': _title,
        'desc': _desc,
        'url1': url1,
        'url2': url2,
        'url3': url3,
        'url4': url4,
        'kind': selectedKind,
        'width': _currentWidthValue,
        'height': _currentHeightValue,
        'earringNo': earingNo,
        'user_id': _userModel.user.userID,
        'state' : "1"
      }).whenComplete(() {
        PlatformDuyarliAlertDialog(
                "Success", "Your ad has been uploaded successfully.", "OK")
            .goster(context);

      });
    } on FirebaseAuthException catch (e) {
      PlatformDuyarliAlertDialog(
        "Oturum Oluşturma Hata",
        Hatalar.goster(e.code),
        "Tamam",
      ).goster(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Post"),
        ),
        body: _formType == FormType.Idle
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildGestureDetector1(context),
                                buildGestureDetector2(context),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Text("Left Side"),
                                SizedBox(
                                  width: 40,
                                ),
                                Text("Right Side"),
                              ],
                            )
                          ],
                        ),

                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildGestureDetector3(context),
                                buildGestureDetector4(context),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Head Side"),
                                SizedBox(
                                  width: 30,
                                ),
                                Text("Back Side"),
                              ],
                            )
                          ],
                        ),

                        SizedBox(
                          height: 16,
                        ),

                        buildTitleTextField(),
                        //EmailText
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildAgePicker(context),
                              buildKindPicker(),
                              buildLocationPicker(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),

                        //EmailText

                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 6,
                                  ),
                                  child: Container(
                                      width: 270, child: buildSlider()),
                                ),
                                Text(
                                    _currentSliderValue.round().toString() +
                                        " \$",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Muli",
                                        color: pColor)),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Container(
                                    width: 270,
                                    child: buildHeightSlider(),
                                  ),
                                ),
                                Text(
                                    _currentWidthValue.round().toString() +
                                        " Kg",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Muli",
                                        color: pColor))
                              ],
                            ),
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Container(
                                  width: 205,
                                  child: buildWithdSlider(),
                                ),
                              ),
                              Text(
                                  _currentHeightValue.round().toString() +
                                      " Cm Height",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Muli",
                                      color: pColor))
                            ])
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: buildEarringNo(),
                        ),

                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: buildDescTextField(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DefaultButton(
                            text: "Add Post",
                            press: () {
                              _formKey.currentState.save();
                              if (_formKey.currentState.validate() &&
                                  _postResim1 != null &&
                                  _postResim2 != null &&
                                  _postResim3 != null &&
                                  _postResim4 != null &&
                                  age != -1 &&
                                  selectedKind != "" &&
                                  selectedUsState != "" &&
                                  _currentWidthValue != 0 &&
                                  _currentHeightValue != 0 &&
                                  _currentSliderValue != 0) {
                                storageUp();

                                setState(() {
                                  _formType = FormType.Busy;
                                });
                                Timer(Duration(seconds: 8), () {
                                  _addPost(
                                      context,
                                      age.toString(),
                                      _title,
                                      selectedKind,
                                      _currentSliderValue.round().toString(),
                                      _currentWidthValue.round().toString(),
                                      _currentHeightValue.round().toString(),
                                      selectedUsState,
                                      _desc);
                                  setState(() {
                                    _formType = FormType.Idle;
                                    //_formKey.currentState.reset();
                                    _postResim1 = null;
                                    _postResim2 = null;
                                    _postResim3 = null;
                                    _postResim4 = null;
                                    _title = "";
                                    selectedKind = "";
                                    _currentSliderValue = 0;
                                    _currentHeightValue = 0;
                                    _currentWidthValue = 0;
                                    selectedUsState = "";
                                    earingNo = null;age = -1;
                                  });


                                });
                              } else {
                                PlatformDuyarliAlertDialog(
                                        "Alert",
                                        (_postResim1 == null
                                                ? "Left Side Picture\n"
                                                : "") +
                                            (_postResim2 == null
                                                ? "Right Side Picture\n"
                                                : "") +
                                            (_postResim3 == null
                                                ? "Head Side Picture\n"
                                                : "") +
                                            (_postResim4 == null
                                                ? "Back Side Picture\n"
                                                : "") +
                                            (_title == "" ? "Title\n" : "") +
                                            (age == -1 ? "Age\n" : "") +
                                            (selectedKind == ""
                                                ? "Kind\n"
                                                : "") +
                                            (selectedUsState == ""
                                                ? "Location\n"
                                                : "") +
                                            (_currentSliderValue == 0
                                                ? "Price\n"
                                                : "") +
                                            (_currentWidthValue == 0
                                                ? "Weight\n"
                                                : "") +
                                            (_currentHeightValue == 0
                                                ? "Height\n"
                                                : "") +
                                            (earingNo == null
                                                ? "Earing No\n"
                                                : "") +
                                            (_desc == ""
                                                ? "Description\n"
                                                : "") +
                                            "\nInformation should be entered",
                                        "OK")
                                    .goster(context);
                              }
                            }),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(semanticsValue: "Your Post is Adding",
                semanticsLabel: "Your Post is Adding",
              )));
  }

  GestureDetector buildGestureDetector1(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 160,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.camera),
                        title: Text("Gallery"),
                        onTap: () {
                          _galeridenResimSec1();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.camera),
                        title: Text("Camera"),
                        onTap: () {
                          _kameradanFotoCek1();
                        },
                      ),
                    ],
                  ),
                );
              });
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: _postResim1 == null
                      ? ExactAssetImage('assets/images/photoLogo.png')
                      : FileImage(_postResim1))),
          //       : FileImage(_postResim1)
        ));
  }

  GestureDetector buildGestureDetector2(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 160,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.collections),
                        title: Text("Gallery"),
                        onTap: () {
                          _galeridenResimSec2();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text("Camera"),
                        onTap: () {
                          _kameradanFotoCek2();
                        },
                      ),
                    ],
                  ),
                );
              });
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: _postResim2 == null
                      ? ExactAssetImage('assets/images/photoLogo.png')
                      : FileImage(_postResim2))),
          //       : FileImage(_postResim1)
        ));
  }

  GestureDetector buildGestureDetector3(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 160,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.collections),
                        title: Text("Gallery"),
                        onTap: () {
                          _galeridenResimSec3();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text("Camera"),
                        onTap: () {
                          _kameradanFotoCek3();
                        },
                      ),
                    ],
                  ),
                );
              });
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: _postResim3 == null
                      ? ExactAssetImage('assets/images/photoLogo.png')
                      : FileImage(_postResim3))),
          //       : FileImage(_postResim1)
        ));
  }

  GestureDetector buildGestureDetector4(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 160,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.collections),
                        title: Text("Gallery"),
                        onTap: () {
                          _galeridenResimSec4();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text("Camera"),
                        onTap: () {
                          _kameradanFotoCek4();
                        },
                      ),
                    ],
                  ),
                );
              });
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: _postResim4 == null
                      ? ExactAssetImage('assets/images/photoLogo.png')
                      : FileImage(_postResim4))),
          //       : FileImage(_postResim1)
        ));
  }

  Slider buildSlider() {
    return Slider(
      value: _currentSliderValue,
      min: 0,
      max: 10000,
      divisions: 1000,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }

  Row buildAgePicker(BuildContext context) {
    return Row(children: [
      Container(
        width: 100,
        height: 60,
        color: Colors.white,
        child: RaisedButton(
          color: Colors.white,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
          ),
          child: Text(
            age.toString() == "-1" ? "Select Age" : "Age\n" + age.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(color: pColor, fontFamily: 'Muli', fontSize: 18),
          ),
          onPressed: () => showMaterialNumberPicker(
            context: context,
            title: "Select Cattle Age",
            maxNumber: 26,
            minNumber: 0,
            step: 1,
            confirmText: "Select",
            cancelText: "Close",
            selectedNumber: age,
            onChanged: (value) => setState(() => age = value),
          ),
        ),
      ),
    ]);
  }

  buildTitleTextField() {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
      ],
      onSaved: (String girilenTitle) {
        _title = girilenTitle;
      },
      cursorColor: pColor,
      style: TextStyle(fontSize: 18),
      validator: (value) {
        if (value.isEmpty) {
          return "\u26A0 Field is empty.";
        }
        return null;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(fontFamily: 'Muli', fontSize: 16),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.redAccent),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        labelText: "Title",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli', fontSize: 22),
        hintText: "enter title for post",
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: pColor, width: 2),
            borderRadius: BorderRadius.circular(28)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  buildKindPicker() {
    return Container(
      width: 100,
      height: 60,
      child: RaisedButton(
        color: Colors.white,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: pColor),
        ),
        child: Text(
          selectedKind.toString() == ""
              ? "Select Kind"
              : "Kind\n" + selectedKind.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: pColor,
            fontFamily: 'Muli',
            fontSize: 18,
          ),
        ),
        onPressed: () => showMaterialScrollPicker(
          context: context,
          title: "Select Cattle Kind",
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

  buildLocationPicker() {
    return Container(
      width: 150,
      height: 60,
      child: RaisedButton(
        color: Colors.white,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: pColor),
        ),
        child: Text(
          selectedUsState.toString() == ""
              ? "Select Location"
              : "Location\n" + selectedUsState.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(color: pColor, fontFamily: 'Muli', fontSize: 18),
        ),
        onPressed: () => showMaterialScrollPicker(
          context: context,
          title: "Pick Your City",
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

  buildHeightSlider() {
    return Container(
      width: 220,
      child: Slider(
        value: _currentWidthValue,
        min: 0,
        max: 1000,
        divisions: 1000,
        label: _currentWidthValue.round().toString(),
        onChanged: (double value) {
          setState(() {
            _currentWidthValue = value;
          });
        },
      ),
    );
  }

  buildWithdSlider() {
    return Container(
      width: 220,
      child: Slider(
        value: _currentHeightValue,
        min: 0,
        max: 300,
        divisions: 300,
        label: _currentHeightValue.round().toString(),
        onChanged: (double value) {
          setState(() {
            _currentHeightValue = value;
          });
        },
      ),
    );
  }

  buildDescTextField() {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(100),
      ],
      onSaved: (String girilenDesc) {
        _desc = girilenDesc;
      },
      cursorColor: pColor,
      maxLines: 2,
      style: TextStyle(fontSize: 18),
      validator: (value) {
        if (value.isEmpty) {
          return "\u26A0 Field is empty.";
        }
        return null;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(fontFamily: 'Muli', fontSize: 16),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.redAccent),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        labelText: "Description",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli', fontSize: 22),
        hintText: "enter title for post",
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: pColor, width: 2),
            borderRadius: BorderRadius.circular(28)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  buildEarringNo() {
    return Container(
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
        ],
        keyboardType: TextInputType.number,
        onSaved: (girilenNo) {
          if (girilenNo != "") {
            earingNo = int.parse(girilenNo);
          }
        },
        cursorColor: pColor,
        style: TextStyle(fontSize: 18),
        validator: (value) {
          if (value.isEmpty) {
            return "\u26A0 Field is empty.";
          }
          return null;
        },
        decoration: InputDecoration(
          errorStyle: TextStyle(fontFamily: 'Muli', fontSize: 16),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(color: Colors.redAccent),
              gapPadding: 5),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(color: kPrimaryColor),
              gapPadding: 5),
          labelText: "Earring No",
          labelStyle:
              TextStyle(color: pColor, fontFamily: 'Muli', fontSize: 22),
          hintText: "cattle earring number",
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(color: pColor),
              gapPadding: 5),
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: pColor, width: 2),
              borderRadius: BorderRadius.circular(28)),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  void _kameradanFotoCek1() async {
    var _pickedFoto = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _postResim1 = File(_pickedFoto.path);
      Navigator.of(context).pop();
    });
  }

  void _galeridenResimSec1() async {
    var _pickedFoto = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _postResim1 = File(_pickedFoto.path);
      Navigator.of(context).pop();
    });
  }

  void _kameradanFotoCek2() async {
    var _pickedFoto = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _postResim2 = File(_pickedFoto.path);
      Navigator.of(context).pop();
    });
  }

  void _galeridenResimSec2() async {
    var _pickedFoto = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _postResim2 = File(_pickedFoto.path);
      Navigator.of(context).pop();
    });
  }

  void _kameradanFotoCek3() async {
    var _pickedFoto = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _postResim3 = File(_pickedFoto.path);
      Navigator.of(context).pop();
    });
  }

  void _galeridenResimSec3() async {
    var _pickedFoto = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _postResim3 = File(_pickedFoto.path);
      Navigator.of(context).pop();
    });
  }

  void _kameradanFotoCek4() async {
    var _pickedFoto = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _postResim4 = File(_pickedFoto.path);
      Navigator.of(context).pop();
    });
  }

  void _galeridenResimSec4() async {
    var _pickedFoto = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _postResim4 = File(_pickedFoto.path);
      Navigator.of(context).pop();
    });
  }

  storageUp() async {
    Reference _storageReference1;
    Reference _storageReference2;
    Reference _storageReference3;
    Reference _storageReference4;

    var uuid = Uuid();
    var code = uuid.v1();

    _storageReference1 =
        _firebaseStorage.ref().child(code).child("post").child("first.jpg");
    _storageReference2 =
        _firebaseStorage.ref().child(code).child("post").child("second.jpg");
    _storageReference3 =
        _firebaseStorage.ref().child(code).child("post").child("third.jpg");
    _storageReference4 =
        _firebaseStorage.ref().child(code).child("post").child("fourth.jpg");

    var uploadTask1 = await _storageReference1.putFile(_postResim1);
    var uploadTask2 = await _storageReference2.putFile(_postResim2);
    var uploadTask3 = await _storageReference3.putFile(_postResim3);
    var uploadTask4 = await _storageReference4.putFile(_postResim4);

    url1 = await (uploadTask1).ref.getDownloadURL();
    url2 = await (uploadTask2).ref.getDownloadURL();
    url3 = await (uploadTask3).ref.getDownloadURL();
    url4 = await (uploadTask4).ref.getDownloadURL();
    debugPrint("upload edilen 1. resmin urlsi : " + url1);
    debugPrint("upload edilen 2. resmin urlsi : " + url2);
    debugPrint("upload edilen 3. resmin urlsi : " + url3);
    debugPrint("upload edilen 4. resmin urlsi : " + url4);
  }
}
