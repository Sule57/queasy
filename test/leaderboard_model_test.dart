import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src/model/leaderboard.dart';
import 'package:queasy/src/model/quiz.dart';

/// Main function for testing the [Quiz] class.
///
/// [instance] is the Fake Firestore instance for mocking of the database
///
/// [UID1] and other uids are the UID of test users who 'play' the quiz
///
/// [username1] and other usernames are the names of the test users who 'play' the quiz
void main() async {

  /// Initialize the [FakeFirebaseFirestore] instance.
  final instance = FakeFirebaseFirestore();
  String cat = 'Science';
  String UID1 = 'uid1';
  String username1 = 'Sophia';

  instance.collection('leaderboard').doc(cat).set({username1: {'position': 1, 'points': 100}});

  /// Instance of the [Leaderboard] class.
  Leaderboard lb = await Leaderboard.createPublic(cat, username1, instance: instance, id: 'id1');

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

  String UID2 = 'uid2';
  String username2 = 'Anika';

  /// Instance of the [Leaderboard] class for different player.
  Leaderboard lb1 = await Leaderboard.createPublic(cat, username2, instance: instance, id: UID2);
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

  String username3 = 'Gullu';
  String UID3 = 'uid3';

  /// Instance of the [Leaderboard] class for different player.
  Leaderboard lb2 = await Leaderboard.createPublic(cat, username3, instance:instance, id:UID3);
  await lb2.getData();

  /// Update the current user's score.
  await lb2.updateCurrentUserPoints(20);
  // lb2.printEntries();

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

  // ---------------------------------------------------------------------------------------
  // Private Leaderboards
  // ---------------------------------------------------------------------------------------

  String priv_cat = 'Programming 3';
  String UID4 = 'uid4';
  String username4 = 'Sophia';

  instance.collection('leaderboard').doc(UID4+ '-' + cat).set({username4: {'position': 1, 'points': 100}});

  /// Instance of the [Leaderboard] class.
  Leaderboard lb3 = await Leaderboard.createPrivate(cat, username4, instance: instance, id: UID4);

  /// Initializing the default data for the [Leaderboard] class in database.
  await lb3.createRandomLeaderboard();
  await lb3.updateData();
  await lb3.getData();

  /// Update the current user's score.
  await lb3.updateCurrentUserPoints(12);

  /// First test: Normal points increase
  test('Number of points for current player should be increased', () {
    expect(lb3.getCurrentPlayerPoints(), 97);
  });
  test('Position for current player should be increased', () {
    expect(lb3.getCurrentPlayerPosition(), 2);
  });
  test(
      'Positions of players that were above and are still above should be the same',
          () {
        expect(
            lb3.getEntries().any((element) =>
            element.getName == 'Julia' &&
                element.getScore == 100 &&
                element.getPosition == 1),
            true);
      });
  test(
      'Positions of players that were above but now are bellow should be decreased',
          () {
        expect(
            lb3.getEntries().any((element) =>
            element.getName == 'Savo' &&
                element.getScore == 95 &&
                element.getPosition == 3),
            true);
      });


}
