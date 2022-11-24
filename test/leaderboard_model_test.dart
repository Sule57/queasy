import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src/model/leaderboard.dart';
import 'package:queasy/src/model/quiz.dart';

/// Main function for testing the [Quiz] class.
void main() async {
  /// Initialize the [FakeFirebaseFirestore] instance.
  final instance = FakeFirebaseFirestore();

  /// Instance of the [Leaderboard] class.
  Leaderboard lb = Leaderboard.test('Science', 'Sophia', instance);

  /// Initializing the default data for the [Leaderboard] class in database.
  await lb.createRandomLeaderboard();
  await lb.updateData();
  await lb.getData();

  /// Update the current user's score.
  await lb.updateCurrentUserPoints(12);

  /// First test: Normal points increase
  test('Number of points for current player should be increased', () {
    expect(lb.getCurrentPlayerPoints(), 97);
  });
  test('Position for current player should be increased', () {
    expect(lb.getCurrentPlayerPosition(), 2);
  });
  test(
      'Positions of players that were above and are still above should be the same',
      () {
    expect(
        lb.getEntries().any((element) =>
            element.getName == 'Julia' &&
            element.getScore == 100 &&
            element.getPosition == 1),
        true);
  });
  test(
      'Positions of players that were above but now are bellow should be decreased',
      () {
    expect(
        lb.getEntries().any((element) =>
            element.getName == 'Savo' &&
            element.getScore == 95 &&
            element.getPosition == 3),
        true);
  });

  /// Instance of the [Leaderboard] class for different player.
  Leaderboard lb1 = Leaderboard.test('Science', 'Anika', instance);
  await lb1.getData();

  /// Update the current user's score.
  await lb1.updateCurrentUserPoints(30);

  /// Second test: Points increase to the top of the leaderboard
  test('Number of points for current player should be increased', () {
    expect(lb1.getCurrentPlayerPoints(), 105);
  });
  test('Position for current player should be increased', () {
    expect(lb1.getCurrentPlayerPosition(), 1);
  });
  test(
      'Positions of players that were above but now are bellow should be decreased',
      () {
    expect(
        lb1.getEntries().any((element) =>
            element.getName == 'Julia' &&
            element.getScore == 100 &&
            element.getPosition == 2),
        true);
  });
  test(
      'Positions of players that were the same position but now are bellow should be decreased',
      () {
    expect(
        lb1.getEntries().any((element) =>
            element.getName == 'Nikol' &&
            element.getScore == 75 &&
            element.getPosition == 7),
        true);
  });

  /// Instance of the [Leaderboard] class for different player.
  Leaderboard lb2 = Leaderboard.test('Science', 'Gullu', instance);
  await lb2.getData();

  /// Update the current user's score.
  await lb2.updateCurrentUserPoints(20);
  lb2.printEntries();

  /// Third test: Points increase and player should have the same position as some other player
  test('Number of points for current player should be increased', () {
    expect(lb2.getCurrentPlayerPoints(), 80);
  });
  test('Position for current player should be increased', () {
    expect(lb2.getCurrentPlayerPosition(), 5);
  });
  test(
      'Positions of players that were above and are still above should be the same',
      () {
    expect(
        lb2.getEntries().any((element) =>
            element.getName == 'Julia' &&
            element.getScore == 100 &&
            element.getPosition == 2),
        true);
  });
  test(
      'Positions of players that were the same but now are bellow should be decreased',
      () {
    expect(
        lb2.getEntries().any((element) =>
            element.getName == 'Nikol' &&
            element.getScore == 75 &&
            element.getPosition == 8),
        true);
  });
  test(
      'Positions of players that were above but now are the same should be the same',
      () {
    expect(
        lb2.getEntries().any((element) =>
            element.getName == 'Stanislav' &&
            element.getScore == 80 &&
            element.getPosition == 5),
        true);
  });
  //
  // /// Testing if question0 is in the returned list
  // test('One of the questions should have the text \'What is the capital of France?\'', () {
  //   expect(_questions.any((element) => element.text == 'What is the capital of France?'), true);
  // });
  //
  // /// Testing if question1 is in the returned list
  // test('One of the questions should have the text \'What is the capital of Germany?\'', () {
  //   expect(_questions.any((element) => element.text == 'What is the capital of Germany?'), true);
  // });
  //
  // ///  Testing if question2 is in the returned list
  // test('One of the questions should have the text \'What is the capital of Italy?\'', () {
  //   expect(_questions.any((element) => element.text == 'What is the capital of Italy?'), true);
  // });
  // /// Testing if question3 is in the returned list
  // test('One of the questions should have the text \'What is the capital of England?\'', () {
  //   expect(_questions.any((element) => element.text == 'What is the capital of England?'), true);
  // });
  // /// Testing if question4 is in the returned list
  // test('One of the questions should have the text \'What is the capital of Spain?\'', () {
  //   expect(_questions.any((element) => element.text == 'What is the capital of Spain?'), true);
  // });
}
