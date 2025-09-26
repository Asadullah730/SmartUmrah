import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_umrah_app/Models/UserProfileData/user_profile_model.dart';

class NewProfileDataCollection {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future<void> saveUserProfileData(UserProfileModel user) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw 'User not logged in';
      }
      print('USER WANT TO SAVE: $user');

      final docRef = database
          .collection("Users")
          .withConverter<UserProfileModel>(
            fromFirestore: (snap, _) =>
                UserProfileModel.fromFirebase(snap.data()!),
            toFirestore: (usr, _) => usr.toFirebase(),
          )
          .doc(uid);

      await docRef.set(user);

      if (kDebugMode) {
        print('Profile saved successfully for UID: $uid');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to save profile: $e');
      }
      rethrow;
    }
  }

  Future<UserProfileModel?> fetchUserProfileData(String uid) async {
    try {
      final docRef = database
          .collection("Users")
          .withConverter<UserProfileModel>(
            fromFirestore: (snap, _) =>
                UserProfileModel.fromFirebase(snap.data()!),
            toFirestore: (usr, _) => usr.toFirebase(),
          )
          .doc(uid);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        if (kDebugMode) print('No profile found for UID: $uid');
        return null;
      }
    } catch (e) {
      if (kDebugMode) print('Failed to fetch profile: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfileData(UserProfileModel user) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw 'User not logged in';
      }

      final docRef = database
          .collection("Profiles")
          .withConverter<UserProfileModel>(
            fromFirestore: (snap, _) =>
                UserProfileModel.fromFirebase(snap.data()!),
            toFirestore: (usr, _) => usr.toFirebase(),
          )
          .doc(uid);

      await docRef.update(user.toFirebase());

      if (kDebugMode) {
        print('Profile updated successfully for UID: $uid');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update profile: $e');
      }
      rethrow;
    }
  }
}
