import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_tracking_app/features/auth/model/user_model.dart';

class AuthRepo {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<Either<String, String>> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firestore.collection("users").doc(userCredential.user!.uid).set({
        "username": username,
        "email": email,
        "uid": userCredential.user!.uid,
      });
      return right("Account Created Successfully");
    } catch (e) {
      log(e.toString());
      return left(" Error: ${e.toString()}");
    }
  }

  Future<Either<String, UserModel>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
   QuerySnapshot<Map<String, dynamic>> querySnapshot =   await firestore
          .collection("users")
          .where( "uid", isEqualTo: userCredential.user!.uid)
          .get() ;
          final userData = querySnapshot.docs.first.data();
          log( userData.toString());
          UserModel userModel = UserModel.fromMap(userData);
          log( userModel.toString());
      return right( userModel);
            
    } catch (e) {
      return left(" Error: ${e.toString()}");
    }
  }
}
