import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FirestoreIslemleri extends StatefulWidget {
  @override
  _FirestoreIslemleriState createState() => _FirestoreIslemleriState();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
}

class _FirestoreIslemleriState extends State<FirestoreIslemleri> {
  PickedFile _secilenResim;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore Islemleri"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Veri Ekle"),
              color: Colors.green,
              onPressed: _veriEkle,
            ),
            RaisedButton(
              child: Text("Transaction Ekle"),
              color: Colors.blue,
              onPressed: _transactionEkle,
            ),
            RaisedButton(
              child: Text("Veri Sil"),
              color: Colors.red,
              onPressed: _veriSil,
            ),
            RaisedButton(
              child: Text("Veri Oku"),
              color: Colors.pink,
              onPressed: _veriOku,
            ),
            RaisedButton(
              child: Text("Veri Sorgula"),
              color: Colors.brown,
              onPressed: _veriSorgula,
            ),
            RaisedButton(
              child: Text("Galeriden Storagea Resim"),
              color: Colors.orange,
              onPressed: _galeriResimUpload,
            ),
            RaisedButton(
              child: Text("Kameradan Storagea Resim"),
              color: Colors.purple,
              onPressed: _kameraResimUpload,
            ),
            Expanded(
              child: _secilenResim == null
                  ? Text("Resim YOK")
                  : Image.file(File(_secilenResim.path)),
            )
          ],
        ),
      ),
    );
  }

  void _veriEkle() {
    Map<String, dynamic> emreEkle = Map();
    emreEkle['ad'] = "emre updated";
    emreEkle['lisanMezunu'] = true;
    emreEkle['lisanMezunu2'] = false;
    emreEkle['lisanMezunu23'] = true;
    emreEkle['okul'] = "ege";
    emreEkle['para'] = 500;

    _firestore
        .collection("users")
        .doc("emre_altunbilek")
        .set(emreEkle, SetOptions(merge: true))
        .then((v) => debugPrint("emre eklendi"));

    _firestore
        .collection("users")
        .doc("hasan_yilmaz")
        .set({'ad': 'Hasan', 'cinsiyet': 'erkek', 'para': 300}).whenComplete(
            () => debugPrint("hasan eklendi"));

    _firestore.doc("/users/ayse").set({'ad': 'ayse'});

    _firestore.collection("users").add({'ad': 'can', 'yas': 35});

    String yeniKullaniciID = _firestore.collection("users").doc().id;
    debugPrint("yeni doc id: $yeniKullaniciID");
    _firestore
        .doc("users/$yeniKullaniciID")
        .set({'yas': 30, 'userID': '$yeniKullaniciID'});

    _firestore.doc("users/emre_altunbilek").update({
      'okul': 'ege üniversitesi',
      'yas': 60,
      'eklenme': FieldValue.serverTimestamp(),
      'begeniSayisi': FieldValue.increment(10)
    }).then((v) {
      debugPrint("emre güncellendi");
    });
  }

  void _transactionEkle() {
    final DocumentReference emreRef = _firestore.doc("users/emre_altunbilek");

    debugPrint("doc id:" + emreRef.id);

    _firestore.runTransaction((Transaction transaction) async {
      DocumentSnapshot emreData = await emreRef.get();

      debugPrint("doc id:" + emreData.id);

      if (emreData.exists) {
        var emreninParasi = (emreData.data()['para']);

        if (emreninParasi > 100) {
          await transaction.update(emreRef, {'para': (emreninParasi - 100)});
          await transaction.update(_firestore.doc("users/hasan_yilmaz"),
              {'para': FieldValue.increment(100)});
        } else {
          debugPrint("yetersiz bakiye");
        }
      } else {
        debugPrint("emre dökümanı yok");
      }
    });
  }

  void _veriSil() {
    //Döküman silme
    _firestore.doc("users/9xmt7WeKp1BxQaaUWm8G").delete().then((aa) {
      debugPrint("ayse silindi");
    }).catchError((e) => debugPrint("Silerken hata cıktı" + e.toString()));

    _firestore
        .doc("users/hasan_yilmaz")
        .update({'cinsiyet': FieldValue.delete()}).then((aa) {
      debugPrint("cinsiyet silindi");
    }).catchError((e) => debugPrint("Silerken hata cıktı" + e.toString()));
  }

  Future _veriOku() async {
    //tek bir dökümanın okunması
    DocumentSnapshot documentSnapshot =
        await _firestore.doc("users/emre_altunbilek").get();

    debugPrint("Döküman id:" + documentSnapshot.id);
    debugPrint("Döküman var mı:" + documentSnapshot.exists.toString());
    debugPrint("Döküman string: " + documentSnapshot.toString());
    debugPrint("bekleyen yazma var mı:" + documentSnapshot.metadata.hasPendingWrites.toString());
    debugPrint("cacheden mi geldi:" + documentSnapshot.metadata.isFromCache.toString());
    debugPrint(".data :" + documentSnapshot.data().toString());
    debugPrint("ad :" + documentSnapshot.data()['ad']);
    debugPrint("para : " + documentSnapshot.data()['para'].toString());
    documentSnapshot.data().forEach((key, deger) {
      debugPrint("key : $key deger :$deger");
    });

    //koleksiyonun okunması
    _firestore.collection("users").get().then((querySnapshots) {
      debugPrint("User koleksiyonundaki eleman sayısı:" +
          querySnapshots.docs.length.toString());

      for (int i = 0; i < querySnapshots.docs.length; i++) {
        debugPrint(querySnapshots.docs[i].data().toString());
      }
      ////////LISTVIEW İLE EKRANA BASTIRMAK İSTERSEM BUNUN İÇİNE LİSTVIEW YAPMAK GEREKTİR.

      //anlık değişikliklerin dinlenmesi
      DocumentReference ref =
          _firestore.collection("users").doc("emre_altunbilek");
      ref.snapshots().listen((degisenVeri) {
        debugPrint("anlık :" + degisenVeri.data().toString());
      });

      _firestore.collection("users").snapshots().listen((snap) {
        debugPrint(snap.docs.length.toString());
      });
    });
  }

  void _veriSorgula() async {
    var dokumanlar = await _firestore
        .collection("users")
        .where("email", isEqualTo: 'emre@emre.com')
        .get();
    for (var dokuman in dokumanlar.docs) {
      debugPrint(dokuman.data().toString());
    }

    var limitliGetir =
        await _firestore.collection("users").limit(3).get();
    for (var dokuman in limitliGetir.docs) {
      debugPrint("Limitli getirenler" + dokuman.data().toString());
    }

    var diziSorgula = await _firestore
        .collection("users")
        .where("dizi", arrayContains: 'breaking bad')
        .get();
    for (var dokuman in diziSorgula.docs) {
      debugPrint("Dizi şartı ile getirenler" + dokuman.data().toString());
    }

    var stringSorgula = await _firestore
        .collection("users")
        .orderBy("email")
        .startAt(['emre']).endAt(['emre' + '\uf8ff']).get();
    for (var dokuman in stringSorgula.docs) {
      debugPrint("String sorgula ile getirenler" + dokuman.data().toString());
    }

    _firestore
        .collection("users")
        .doc("emre_altunbilek")
        .get()
        .then((docSnap) {
      debugPrint("emrenin verileri" + docSnap.data().toString());

      _firestore
          .collection("users")
          .orderBy('begeni')
          .endAt([docSnap.data()['begeni']])
          .get()
          .then((querySnap) {
            if (querySnap.docs.length > 0) {
              for (var bb in querySnap.docs) {
                debugPrint("emrenin begenisinden fazla olan user:" +
                    bb.data().toString());
              }
            }
          });
    });
  }

void _galeriResimUpload() async {
  var _picker = ImagePicker();
  var resim = await _picker.getImage(source: ImageSource.gallery);
  setState(() {
    _secilenResim = resim;
  });

  Reference ref = FirebaseStorage.instance
      .ref()
      .child("user")
      .child("emre")
      .child("profil.png");
  UploadTask uploadTask = ref.putFile(File(_secilenResim.path));

  var url = await (await uploadTask).ref.getDownloadURL();
  debugPrint("upload edilen resmin urlsi : " + url);
}

void _kameraResimUpload() async {
  var resim = await ImagePicker().getImage(source: ImageSource.camera);
  setState(() {
    _secilenResim = resim;
  });

  Reference ref = FirebaseStorage.instance
      .ref()
      .child("user")
      .child("hasan")
      .child("profil.png");
  UploadTask uploadTask = ref.putFile(File(_secilenResim.path));

  var url = await (await uploadTask).ref.getDownloadURL();
  debugPrint("upload edilen resmin urlsi : " + url);
}
}
