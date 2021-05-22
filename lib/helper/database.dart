import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Stream<DocumentSnapshot> getResources(String org) {
    return FirebaseFirestore.instance
        .collection("organization")
        .doc(org)
        .snapshots();
  }

  Future<void> addUserInfo(userData, uid) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addVendorProduct(userData, uid) async {
    FirebaseFirestore.instance
        .collection("vendorproduct")
        .doc('products')
        .collection(uid)
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addNotifiction(userData, uid) async {
    FirebaseFirestore.instance
        .collection("vendorproduct")
        .doc('notification')
        .collection(uid)
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<QuerySnapshot> getVendorProduct(uid) async {
    FirebaseFirestore.instance
        .collection("vendorproduct")
        .doc('products')
        .collection(uid)
        .snapshots();
  }

  Future<void> addVendorInfo(userData, uid) async {
    FirebaseFirestore.instance
        .collection("vendors")
        .doc(uid)
        .set(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  updateUserInfo(String uid, type, val) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({'$type': val}).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String uid) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getVendorInfo(String uid) async {
    return FirebaseFirestore.instance
        .collection("vendors")
        .doc(uid)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getOrgInfo(String org) async {
    return FirebaseFirestore.instance
        .collection("organization")
        .doc(org)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getOrgInfoFuture(String org) async {
    return FirebaseFirestore.instance
        .collection("organization")
        .doc(org)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getOrgList(String id) async {
    return FirebaseFirestore.instance
        .collection("admin")
        .doc(id)
        .collection('settings')
        .doc('setting')
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getOrgSurvey(String org) async {
    return FirebaseFirestore.instance
        .collection("organization")
        .doc(org)
        .collection("surveys")
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }
}
