import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/answer.dart';
import 'package:queasy/src/model/question.dart';


class Category {
  /// Firestore instance for the database.
  static var _firebaseFirestore = FirebaseFirestore.instance;

  /// Collection reference for the leaderboard in the database.
  static final DocumentReference _doc = _firebaseFirestore.collection('categories').doc('public');
  static String category = '-1';

  static Future<void> createFirestoreInstance(FirebaseFirestore instance) async {
    _firebaseFirestore = instance;
  }

  // Category(this.questions, this.color);

  static void setCategory(String cat) {
    category = cat;
  }

  static Future<List<String>> getPublicCategories() async{
    // retrieve list of keys from public categories from Firestore
    List<String> list = [];
    list = ['Art & Literature', 'Entertainment', 'Geography', 'History', 'Science', 'Sports'];
    // // get all document id from public categories
    // var snapshot = await _doc.get();
    // var data = snapshot.data();
    // var keys = data.keys;
    //
    //
    // // parse through the document and update the positions
    // await _firebaseFirestore.collection('categories').doc('public').get().then((DocumentSnapshot documentSnapshot) {
    //   if (documentSnapshot.get(field)) {
    //     print('Exists');
    //     Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    //     for (String key in data.keys) {
    //       print(key);
    //       list.add(key);
    //     }
    //   }
    // });
    return list;
  }
  // get all questions from a collection
  static Future<List<Question>> getQuestionsFromPublicCategory(String category) async {
    List<Question> questions = [];

    // get all document id from public categories
    await _firebaseFirestore.collection('categories').doc('public').collection(category).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        questions.add(Question.fromJson(doc.data() as Map<String, dynamic>));
      });
    });
    return questions;
  }

  static Future<List<Question>> getQuestionsFromPrivateCategory(String username, String category) async {
    List<Question> questions = [];

    // get all document id from public categories
    await _firebaseFirestore.collection('categories').doc(username).collection(category).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        questions.add(Question.fromJson(doc.data() as Map<String, dynamic>));
      });
    });
    return questions;
  }


  // get categories of a user from Firestore
  static Future<List<String>> getPrivateCategories(String username) async {
    List<String> list = [];
    // get all document id from public categories
    await _firebaseFirestore.collection('categories').doc(username).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Exists');
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        for (String key in data.keys) {
          print(key);
          list.add(key);
        }
      }
    });
    return list;
  }

}
