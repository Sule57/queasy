import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/src/model/question.dart';
import '../../utils/exceptions.dart';

/// The Quiz class is responsible for being an instance of a quiz and also,
/// for filling the quiz with questions whether it is a private or a public quiz.
/// This is done by using either the[getRandomQuestions] or the
/// [retrieveQuizFromId] methods.
class Quiz {
  /// Represents the id of the quiz, this will be set only if the quiz is
  /// private, since public quizzes aren't stored.
  late String id;

  /// Represents the category of the quiz, this is used to retrieve
  /// the questions from the firebase.
  late Category category;

  /// Represents the number of questions that the quiz will have.
  late int noOfQuestions;

  /// Represents the ID of the user who created the quiz or the word
  /// 'public' used to reference public quizzes.
  late String? ownerID;

  /// Stores the name of the quiz.
  late String? name;

  /// Represents the ID of the user who created the quiz.
  late String? UID;

  /// Stores the retrieved questions which will be displayed
  /// to the user to answer.
  List<Question> _questions = [];

  /// Stores the IDs of the questions already used in the
  /// quiz.
  List<String> _usedQuestions = [];

  /// Represents an instance of firebase connection,
  /// it is used to manipulate the firebase.
  late FirebaseFirestore? firestore;

  /// Represents whether the quiz is public or private.
  late bool isPublic;

  /// A getter for the list of questions.
  get questions => _questions;

  /// This is the createFromID constructor of the class, it will create an empty
  /// quiz for it to be filled either with [getRandomQuestions],
  /// [retrieveQuizFromId], or [createCustomQuiz] functions. It takes one optional
  /// parameter [firestore] which allows the programmer to pass the mocked
  /// firebase instance when testing.
  ///
  /// The constructor creates a default [category] to be used by the quiz
  /// provider until the actual category is retrieved from firebase or by the
  /// developer providing it.
  /// This constructor is basically creating an empty quiz that will be filled
  /// with data from the firebase.
  ///
  /// There is a conditional statement inside this constructor that will check
  /// if the [firestore] was passed as a parameter, if it was, it assumes that
  /// the developer is in testing and therefore the [UID] will be set to a
  /// default value, otherwise it will get the current user's ID and set it to
  /// the [UID] parameter. Also, if [firestore] was not passed as a parameter,
  /// it will initialize the [firestore] parameter with the actual firebase
  /// instance.
  ///
  /// The way to use this constructor when creating a quiz is calling it with
  /// Quiz() and then putting a function inside depending if we are accessing
  /// an already existing quiz or creating a new one.
  Quiz({firestore}) {
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }
    category = Category(name: 'default', firestore: firestore);
  }

  ///Dummy constructor for quiz that accept these parameters: string id,
  ///string name, list of questions, string category
  Quiz.dummy({required this.id, required this.name, required this.category});

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
  /// ID by using the [createID] method into the "tempID" variable and then
  /// it will check if the ID is already used by another quiz, if it is, it will
  /// call itself again, otherwise it will set the [id] parameter to the
  /// "tempID" and return.
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
  /// the [noOfQuestions] parameter. It also requires passing the [isPublic]
  /// parameter so it's clear if the quiz is supposed to be public or private.
  ///
  /// Besides these the function also takes the optional [name] parameter that
  /// will add a name to the quiz, though this should be passed only if the quiz
  /// is private, and another optional [firestore] parameter that will if passed
  /// make the code assume the developer is in testing and connect to the given
  /// instance, if it's not passed a default instance of Firebase Firestore will
  /// be used.
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
  Future<Quiz> getRandomQuestions(
      {required Category category,
        required int noOfQuestions,
        required bool isPublic,
        String? name,
        FirebaseFirestore? firestore}) async {
    this.category = category;
    this.noOfQuestions = noOfQuestions;
    this.isPublic = isPublic;
    this.name = name;

    if (firestore == null) {
      UID = await getCurrentUserID();
      this.firestore = FirebaseFirestore.instance;
    } else {
      this.firestore = firestore;
      UID = "test123456789";
    }

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

    /// for the number of questions in the quiz,
    /// get a random question from the category.
    for (int i = 0; i < noOfQuestions; i++) {
      /// create a random id from category.randomizer
      /// check if the id is already in the list of used questions
      /// if it is, create a new id
      /// if it is not, add it to the list of used questions
      /// add the question to the list of questions
      String tempID = await category.randomizer(public: isPublic);
      while (_usedQuestions.contains(tempID)) {
        tempID = await category.randomizer(public: isPublic);
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
    await this.firestore?.collection('quizzes').doc(id).set({
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
  /// After this is retrieved, the method will call a method "getPrivateQuestions"
  /// from [Category] class which will retrieve the questions from the firebase
  /// for the amount of times specified by the [noOfQuestions] variable, and the
  /// question IDs stored in the [_usedQuestions] variable.
  ///
  /// The function also takes an optional [firestore] parameter that will if passed
  /// make the code assume the developer is in testing and connect to the given
  /// instance, if it's not passed a default instance of Firebase Firestore will
  /// be used.
  Future<Quiz> retrieveQuizFromId(
      {required String id, FirebaseFirestore? firestore}) async {
    print('inside retrieveQuizFromId method. Id: $id');
    this.isPublic = false;

    if (firestore == null) {
      UID = await getCurrentUserID();
      this.firestore = FirebaseFirestore.instance;
    } else {
      this.firestore = firestore;
      UID = "test123456789";
    }
    print('id: ' + id + '');
    await this
        .firestore
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
        this.category = new Category(
            name: documentSnapshot['category']!, firestore: this.firestore);
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

  /// Checks if the quiz with the given [id] exists in the firebase. If it does,
  /// it will return true, otherwise it will return false.
  /// This method is an asynchronous method that parses through the stored
  /// quizzes in the firebase and checks if the document exists.
  /// It also accepts a optional parameter [firestore] which is the firestore
  /// instance that will be used to retrieve the data from the firebase.
  /// If the [firestore] parameter is null, the method will use the default
  /// firestore instance. If it is not null, it will use the given firestore
  /// instance.
  static Future<bool> checkIfQuizExists(
      {required String id, FirebaseFirestore? firestore}) async {
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }

    bool exists = false;
    await firestore
        .collection('quizzes')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        exists = true;
      } else {
        exists = false;
      }
    });
    return exists;
  }

  /// Allows the user to create their own custom quiz. It takes 3 mandatory
  /// parameters: a list of questionIDs [questions], a category [category],
  /// and a name for the quiz [name].
  ///
  /// It also takes an optional parameter [firestore] which is the firestore
  /// instance that will be used to retrieve the data from the firebase.
  /// If the [firestore] parameter is null, the method will use the default
  /// firestore instance. If it is not null, it will assume the user is in testing
  /// and fill some of the variables with test data and use the given firestore
  /// instance.
  Future<Quiz> createCustomQuiz(
      {required List<String> questions,
        required Category category,
        required String name,
        FirebaseFirestore? firestore}) async {
    this.isPublic = false;
    this._usedQuestions = questions;
    this.category = category;
    this.name = name;
    this.noOfQuestions = questions.length;

    if (firestore == null) {
      UID = await getCurrentUserID();
      this.firestore = FirebaseFirestore.instance;
    } else {
      this.firestore = firestore;
      UID = "test123456789";
    }

    if (UID == null) {
      throw UserNotLoggedInException();
    }
    this.ownerID = UID;
    await assignUniqueID();

    for (int i = 0; i < noOfQuestions; i++) {
      Question tempQuestion =
      await category.getPrivateQuestion(_usedQuestions[i], ownerID!);
      _questions.add(tempQuestion);
    }
    return this;
  }

  Future<void> updateQuiz() async{
    await firestore?.collection('quizzes').doc(id).update({
      'name': this.name,
      'questionIds': this._usedQuestions,
    });
  }

}
