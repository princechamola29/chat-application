import 'package:chatapplication/feat/auth/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthRepositoryProvider = Provider(
      (ref) => FirebaseAuthRepository(ref),
);

class FirebaseAuthRepository {
  final Ref ref;

  FirebaseAuthRepository(this.ref);

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final value = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveDataOnFireStore(
        data: UserModel(uuid: value.user?.uid ?? "", name: name, email: email),
      );
      return "User SignUp Successfully";
    } on FirebaseAuthException catch (error) {
      print(error.message);
      return error.message ?? "Something Went Wrong";
    }
  }

  Future<void> saveDataOnFireStore({required UserModel data}) async {
    try {
      final value = await _firebaseFirestore.collection("users")
          .doc(data.uuid)
          .set({
        "Uuid": data.uuid,
        "name": data.name?.toLowerCase(),
        "email": data.email?.toLowerCase(),
      });
    } on FirebaseException catch (error) {}
  }

  Future<String> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final value = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Successfully Login";
    } on FirebaseAuthException catch (error) {
      return error.message ?? 'Something went wrong';
    }
  }

}
