import 'dart:io';

import 'package:come491_cattle_market/common_widget/platform_duyarli_widget.dart';
import 'package:come491_cattle_market/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class PlatformDuyarliAlertDialog extends PlatformDuyarliWidget {
  final String baslik;
  final String icerik;
  final String anaButonYazisi;
  final String iptalButonYazisi;

  PlatformDuyarliAlertDialog(@required this.baslik, @required this.icerik,
      @required this.anaButonYazisi, {this.iptalButonYazisi});

  Future<bool> goster(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
        context: context, builder: (context) => this)
        : await showDialog<bool>(
        context: context,
        builder: (context) => this,
        barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(baslik),
      titleTextStyle: TextStyle(fontSize: 22,color: pColor,fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Text(icerik),
      contentTextStyle: TextStyle(fontSize: 18,color: pColor,),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    CupertinoAlertDialog(
      title: Text(baslik),
      content: Text(icerik),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  List<Widget> _dialogButonlariniAyarla(BuildContext context) {
    final tumButonlar = <Widget>[];

    if (Platform.isIOS) {
      tumButonlar.add(CupertinoDialogAction(child: Text(anaButonYazisi)));
    } else {
      tumButonlar.add(FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(anaButonYazisi)));

      if(iptalButonYazisi != null){
        tumButonlar.add(FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(iptalButonYazisi)));
      }


    }

    return tumButonlar;
  }
}
