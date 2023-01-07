import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/src/model/question.dart';
import '../../utils/exceptions.dart';

/// The class that is responsible for being an object of quiz.
///
/// The Quiz class is also responsible for filling the quiz with questions whether it is a private or a public quiz.
/// This is done by using either the [getRandomQuestions] or the [retrieveQuizFromId] methods.
///
/// The [id] represents the id of the quiz, this will be set only if the quiz is private, since public quizzes aren't stored.
///
/// [noOfQuestions] represents the number of questions that the quiz will have.
///
/// The [_questions] list stores the retrieved questions which will be displayed to the user to answer and the [_usedQuestions] list stores the IDs of these questions.
///
/// The [category] represents the category of the quiz, this is used to retrieve the questions from the firebase.
///
/// [isPublic] represents whether the quiz is public or private.
///
/// The [firestore] represents an instance of firebase connection, it is used to manipulate the firebase.
///
/// The [name] represents the name of the quiz
///
/// The [UID] represents the ID of the user who created the quiz

class Quiz {
  late String id;
  late Category category;
  late int noOfQuestions;
  late String? ownerID, name,UID;
  List<Question> _questions = [];
  List<String> _usedQuestions = [];
  late FirebaseFirestore? firestore;
  late bool isPublic;

  /// A getter for the list of questions.
  get questions => _questions;

  /// This is the createRandom constructor of the class, it takes the number of
  /// questions [noOfQuestions], the [category] of the quiz, the boolean [isPublic]
  /// and the optional [name] of the quiz as parameters and assigns them to the
  /// corresponding parameters of the class. The reason why [name] is optional
  /// is because if the quiz is public, the name is not needed.
  ///
  /// It also takes another optional parameter [firestore] which allows the
  /// programmer to pass the mocked firebase instance when testing.
  ///
  /// There is a conditional statement inside this constructor that will check
  /// if the [firestore] was passed as a parameter, if it was, it assumes that
  /// the developer is in testing and therefore the [UID] will be set to a
  /// default value, otherwise it will get the current user's ID and set it to
  /// the [UID] parameter. Also, if [firestore] was not passed as a parameter,
  /// it will initialize the [firestore] parameter with the actual firebase
  /// instance.
  Quiz.createRandom({
    required this.category,
    required this.noOfQuestions,
    required this.isPublic,
    this.name,
    firestore,
  }) {
    if (firestore == null) {
      UID = getCurrentUserID();
      firestore = FirebaseFirestore.instance;
    }
    else {
      this.firestore = firestore;
      UID = "test123456789";
    }
    getRandomQuestions();
  }

  /// This is the createFromID constructor of the class, it takes one optional
  /// parameter [firestore] which allows the programmer to pass the mocked
  /// firebase instance when testing.
  ///
  /// The constructor creates a default [category] to be used by the quiz
  /// provider until the actual category is retrieved from firebase.
  /// This constructor is basically creating an empty quiz that will be filled
  /// with data from the firebase since constructors cannot be asynchronous.
  ///
  /// There is a conditional statement inside this constructor that will check
  /// if the [firestore] was passed as a parameter, if it was, it assumes that
  /// the developer is in testing and therefore the [UID] will be set to a
  /// default value, otherwise it will get the current user's ID and set it to
  /// the [UID] parameter. Also, if [firestore] was not passed as a parameter,
  /// it will initialize the [firestore] parameter with the actual firebase
  /// instance.
  Quiz({
    //required this.id,
    firestore,
  }) {
    category = Category(name: 'default', firestore: firestore);
    // isPublic = false;
    if (firestore == null) {
      UID = getCurrentUserID();
      this.firestore = FirebaseFirestore.instance;
    }
    else {
      this.firestore = firestore;
      UID = "test123456789";
    }
    // retrieveQuizFromId();
  }

  /// Creates a random ID for the quiz by using the [Random] class and the
  /// [String] function that gets a character from an integer value.
  String createID() {
    String id = "";
    for (int i = 0; i < 8; i++) {
      int random = Random().nextInt(62);
      if (random < 10) {
        id += random.toString();
      } else if (random < 36) {
        id += String.fromCharCode(random + 55);
      } else {
        id += String.fromCharCode(random + 61);
      }
    }
    return id;
  }

  /// Gives the quiz a random unique ID.
  /// This method is an asynchronous, recursive method that will store a random
  /// ID by using the [createID] method into the [tempID] variable and then
  /// it will check if the ID is already used by another quiz, if it is, it will
  /// call itself again, otherwise it will set the [id] parameter to the
  /// [tempID] and return.
  Future<void> assignUniqueID() async {
    String tempID = createID();

    // count how many questions already exist inside of the given category
    await firestore
        ?.collection('quizzes')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (tempID == doc['id']) {
          assignUniqueID();
        }
      });
    });

    this.id = tempID;
  }

  /// Fills the quiz with random questions from the specified [category] and
  /// the [noOfQuestions] parameter.
  ///
  /// This method is an asynchronous method that will retrieve an amount of
  /// questions equal to the [noOfQuestions] parameter from the firebase and
  /// store them in the [_questions] list. The IDs of each of these questions is
  /// stored into the [_usedQuestions] list so it can always be checked if the
  /// question was already added to the quiz, so it doesn't occur that there are
  /// two same questions in there.
  ///
  /// The method also contains if the [UID] is null, and if it is, this means
  /// a user is not logged in, so it will throw the [UserNotLoggedInException].
  ///
  /// If the quiz isn't public a unique ID will be assigned to the quiz by using
  /// the [assignUniqueID] method.
  Future<Quiz> getRandomQuestions() async {
    if (isPublic == false) {
      if (UID == null) {
        throw UserNotLoggedInException();
      }
      this.ownerID = UID;
      await assignUniqueID();

    } else {
      this.ownerID = 'public';
      this.id = 'whatever';
    }

    /// for the number of questions in the quiz, get a random question from the category
    for (int i = 0; i < noOfQuestions; i++) {
      /// create a random id from category.randomizer
      /// check if the id is already in the list of used questions
      /// if it is, create a new id
      /// if it is not, add it to the list of used questions
      /// add the question to the list of questions
      String tempID =
          await category.randomizer(public: isPublic);
      while (_usedQuestions.contains(tempID)) {
        tempID =
            await category.randomizer(public: isPublic);
      }
      _usedQuestions.add(tempID);
      Question tempQuestion =
          await category.getQuestion(tempID, public: isPublic);
      _questions.add(tempQuestion);
    }

    return this;
  }

  /// This method is an asynchronous method that will store the quiz into the
  /// firebase.
  Future<void> storeQuiz() async {
    await firestore?.collection('quizzes').doc(id).set({
      'id': id,
      'name': name,
      'creatorID': ownerID,
      'category': category.name,
      'questionIds': _usedQuestions,
    });
  }

  /// This method is an asynchronous method that will retrieve the quiz from
  /// the firebase and fill the quiz with the data retrieved. It takes one
  /// parameter [id] which is the ID of the quiz that will be retrieved.
  ///
  /// Inside the method [isPublic] is automatically set to false, because this
  /// method is only used for retrieving private quizzes.
  /// When it is called, the method will go to the given ID and fill the quiz
  /// object with the data retrieved from the firebase. In particular the
  /// variables [id], [name], [ownerID], [category], [noOfQuestions] and
  /// [_usedQuestions] will be retrieved from firebase.
  ///
  /// After this is retrieved, the method will call a method [getPrivateQuestions]
  /// from [Category] class which will retrieve the questions from the firebase
  /// for the amount of times specified by the [noOfQuestions] variable, and the
  /// question IDs stored in the [_usedQuestions] variable.
  Future<Quiz> retrieveQuizFromId({required String id}) async {
    print('inside retrieveQuizFromId method. Id: $id');
    this.isPublic = false;

    await firestore
        ?.collection('quizzes')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print('it got the collection');
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        this.name = documentSnapshot['name'];
        this.id = documentSnapshot['id'];
        this.ownerID = documentSnapshot['creatorID'];
        this.category = new Category(name: documentSnapshot['category']!, firestore: firestore);
        // this.categoryName = ;
        this.noOfQuestions = documentSnapshot['questionIds'].length;

        /// add all questionIds to the list of used questions
        for (int i = 0; i < noOfQuestions; i++) {
          _usedQuestions.add(documentSnapshot['questionIds'][i]);
        }
      } else {
        print('Document does not exist on the database');
      }
    });

    for (int i = 0; i < noOfQuestions; i++) {
      Question tempQuestion =
          await category.getPrivateQuestion(_usedQuestions[i], ownerID!);
      _questions.add(tempQuestion);
    }

    return this;
  }
}
