import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:come491_cattle_market/common_widget/platform_duyarli_alertDialog.dart';
import 'package:come491_cattle_market/components/custom_button.dart';
import 'package:come491_cattle_market/constants.dart';
import 'package:come491_cattle_market/model/user.dart';
import 'package:come491_cattle_market/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String photoUrl;
  String nameSurname;
  String phone;
  String location;
  String about;

  TextEditingController _controllerPhoneNumber;
  TextEditingController _controllerLocation;
  TextEditingController _controllerNameSurname;
  TextEditingController _controllerAbout;
  File _profilFoto;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    super.initState();
    getUserInfo(_userModel.user.userID);
    _controllerPhoneNumber = TextEditingController();
    _controllerLocation = TextEditingController();
    _controllerNameSurname = TextEditingController();
    _controllerAbout = TextEditingController();
  }

  @override
  void dispose() {
    _controllerPhoneNumber.dispose();
    _controllerLocation.dispose();
    _controllerNameSurname.dispose();
    _controllerAbout.dispose();
    super.dispose();
  }

  void _kameradanFotoCek() async {
    var _pickedFoto = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _profilFoto = File(_pickedFoto.path);
      Navigator.of(context).pop();
    });
  }

  void _galeridenResimSec() async {
    var _pickedFoto = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _profilFoto = File(_pickedFoto.path);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);

    getUserInfo(_userModel.user.userID);

    print("Profil Sayfasındaki User Değerleri : " + _userModel.user.toString());
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        actionsIconTheme: IconThemeData(color: kPrimaryColor),
        actions: [
          FlatButton(
              onPressed: () => _cikisOnay(context),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Icon(
                  Icons.logout,
                  size: 34,
                  color: pColor,
                ),
              ))
        ],
        title: Text("Profile"),
      ),
      body: FutureBuilder<List<Kullanici>>(
        future: _userModel.getUser(_userModel.user.userID),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, top: 0, right: 16, bottom: 16),
                  child: Column(
                    children: [
                      GestureDetector(
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
                                          _galeridenResimSec();
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text("Camera"),
                                        onTap: () {
                                          _kameradanFotoCek();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          backgroundImage: _profilFoto == null
                              ? NetworkImage(sonuc.data[0].profilURL)
                              : FileImage(_profilFoto),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      buildNameTextField(_userModel),
                      SizedBox(
                        height: 10,
                      ),
                      buildPhoneNumberField(_userModel),
                      SizedBox(
                        height: 10,
                      ),
                      buildAddressField(_userModel),
                      SizedBox(
                        height: 10,
                      ),
                      buildAboutTextField(_userModel),
                      SizedBox(
                        height: 10,
                      ),
                      DefaultButton(
                        text: "Save Changes",
                        press: () {
                          _userPhoneGuncelle(context);
                          _profilFotoGuncelle(context);
                          _userLocationGuncelle(context);
                          _userNameSurnameGuncelle(context);
                          _userAboutGuncelle(context);
                          PlatformDuyarliAlertDialog("Success","Your information has been updated.","OK").goster(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          } else
            return CircularProgressIndicator();
        },
      ),
    );
  }

  buildNameTextField(UserModel userModel) {
    return TextFormField(
      autofocus: false,
      controller: _controllerNameSurname,
      cursorColor: pColor,
      style: TextStyle(fontSize: 18),
      validator: (value) {
        if (value.isEmpty) {
          return "\u26A0 Field is empty.";
        } else
          return null;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(fontFamily: 'Muli', fontSize: 16),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        labelText: "Name Surname",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli'),
        hintText: "enter name & surname",
        hintStyle: TextStyle(fontFamily: 'Muli', fontSize: 18),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding:
            EdgeInsets.only(left: 36, top: 12, bottom: 12, right: 4),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: pColor, width: 2),
            borderRadius: BorderRadius.circular(28)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            15,
            15,
            15,
          ),
          child: Icon(Icons.person, size: 36),
        ),
      ),
    );
  }

  buildPhoneNumberField(UserModel userModel) {
    return TextFormField(
      autofocus: false,
      inputFormatters: [
        LengthLimitingTextInputFormatter(11),
        FilteringTextInputFormatter.digitsOnly
      ],
      keyboardType: TextInputType.number,
      controller: _controllerPhoneNumber,
      cursorColor: pColor,
      style: TextStyle(fontSize: 18),
      validator: (value) {
        if (value.isEmpty) {
          return "\u26A0 Field is empty.";
        } else
          return null;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(fontFamily: 'Muli', fontSize: 16),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        labelText: "Phone",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli'),
        hintText: "enter phone number",
        hintStyle: TextStyle(fontFamily: 'Muli', fontSize: 20),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding:
            EdgeInsets.only(left: 36, top: 12, bottom: 12, right: 4),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: pColor, width: 2),
            borderRadius: BorderRadius.circular(28)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            15,
            15,
            15,
          ),
          child: Icon(Icons.phone, size: 36),
        ),
      ),
    );
  }

  buildAddressField(UserModel userModel) {
    return TextFormField(
      autofocus: false,
      controller: _controllerLocation,
      cursorColor: pColor,
      style: TextStyle(fontSize: 18),
      validator: (value) {
        if (value.isEmpty) {
          return "\u26A0 Field is empty.";
        } else
          return null;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(fontFamily: 'Muli', fontSize: 16),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        labelText: "Location",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli'),
        hintText: "enter location",
        hintStyle: TextStyle(fontFamily: 'Muli', fontSize: 20),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding:
            EdgeInsets.only(left: 36, top: 12, bottom: 12, right: 4),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: pColor, width: 2),
            borderRadius: BorderRadius.circular(28)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            15,
            15,
            15,
          ),
          child: Icon(Icons.home, size: 36),
        ),
      ),
    );
  }

  buildAboutTextField(UserModel userModel) {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      controller: _controllerAbout,
      cursorColor: pColor,
      style: TextStyle(fontSize: 18),
      validator: (value) {
        if (value.isEmpty) {
          return "\u26A0 Field is empty.";
        } else
          return null;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(fontFamily: 'Muli', fontSize: 16),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kPrimaryColor),
            gapPadding: 10),
        labelText: "About",
        labelStyle: TextStyle(color: pColor, fontFamily: 'Muli'),
        hintText: "enter info about",
        hintStyle: TextStyle(fontFamily: 'Muli', fontSize: 20),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: pColor),
            gapPadding: 10),
        contentPadding:
            EdgeInsets.only(left: 36, top: 12, bottom: 12, right: 4),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: pColor, width: 2),
            borderRadius: BorderRadius.circular(28)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            15,
            15,
            15,
          ),
          child: Icon(Icons.text_fields, size: 36),
        ),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool cikisDurumu = await _userModel.signOut();
    return cikisDurumu;
  }

  Future _cikisOnay(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      "Are You Sure ?",
      "Do You Want To Sign Out ?",
      "Yes",
      iptalButonYazisi: "No",
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  Future<void> _userPhoneGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user.mobileNumber != _controllerPhoneNumber.text) {
      var updateResult = await _userModel.updatePhoneNumber(
          _userModel.user.userID, _controllerPhoneNumber.text);
      if (updateResult == true) {
        _userModel.user.mobileNumber = _controllerPhoneNumber.text;
      } else {
        _controllerPhoneNumber.text = _userModel.user.mobileNumber;
        PlatformDuyarliAlertDialog("Error", "Phone Number Error", "Okey")
            .goster(context);
      }
    }
  }

  Future<void> _userNameSurnameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (nameSurname != _controllerNameSurname.text) {
      var updateResult = await _userModel.updateNameSurname(
          _userModel.user.userID, _controllerNameSurname.text);
      if (updateResult == true) {
        nameSurname = _controllerNameSurname.text;
      } else {
        _controllerNameSurname.text = nameSurname;
        PlatformDuyarliAlertDialog("Error", "Name Surname Error", "Okey")
            .goster(context);
      }
    }
  }

  Future<void> _userLocationGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (location != _controllerLocation.text) {
      var updateResult = await _userModel.updateLocation(
          _userModel.user.userID, _controllerLocation.text);
      if (updateResult == true) {
        location = _controllerLocation.text;
      } else {
        _controllerLocation.text = location;
        PlatformDuyarliAlertDialog("Error", "Location Info Error", "Okey")
            .goster(context);
      }
    }
  }

  Future<void> _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_profilFoto != null) {
      var url = await _userModel.uploadFile(
          _userModel.user.userID, "profilFoto", _profilFoto);
      print("Gelen url : " + url);
      _profilFoto = null;
    }
  }

  Future<void> _userAboutGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (about != _controllerAbout.text) {
      var updateResult = await _userModel.updateAbout(
          _userModel.user.userID, _controllerAbout.text);
      if (updateResult == true) {
        about = _controllerAbout.text;
      } else {
        _controllerAbout.text = about;
        PlatformDuyarliAlertDialog("Error", "About Info Error", "Okey")
            .goster(context);
      }
    }
  }

  Future<void> getUserInfo(userID) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection("users").doc(userID).get();

    debugPrint("ad :" + documentSnapshot.data()['nameSurname']);
    debugPrint("number :" + documentSnapshot.data()['mobileNumber']);
    debugPrint("location :" + documentSnapshot.data()['location']);
    debugPrint("about :" + documentSnapshot.data()['about']);
    debugPrint("photo :" + documentSnapshot.data()['profilURL']);

    photoUrl = documentSnapshot.data()['profilURL'];

    nameSurname = documentSnapshot.data()['nameSurname'];
    phone = documentSnapshot.data()['mobileNumber'];
    location = documentSnapshot.data()['location'];
    about = documentSnapshot.data()['about'];

    _controllerPhoneNumber.text = phone;

    _controllerLocation.text = location;

    _controllerNameSurname.text = nameSurname;

    _controllerAbout.text = about;
  }
}
