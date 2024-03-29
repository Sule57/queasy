import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src/model/leaderboard.dart';
import 'package:queasy/src/model/quiz.dart';

/// Main function for testing the [Quiz] class.
void main() async {

  /// Initialize the [FakeFirebaseFirestore] instance.
  final instance = FakeFirebaseFirestore();
  String cat = 'Science';
  String UID1 = 'uid1';
  String username1 = 'Sophia';

  instance.collection('leaderboard').doc(cat).set({username1: {'position': 1, 'points': 100}});

  /// Instance of the [Leaderboard] class.
  Leaderboard lb = await Leaderboard.createPublic(cat, username1, instance: instance, id: UID1);

  /// Initializing the default data for the [Leaderboard] class in database.
  await lb.createRandomLeaderboard(isTest: true);
  await lb.updateData(isTest: true);
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

  test(
      'Points are not updated when the user plays the quiz for the first time',
          () async {
            String UID4 = 'uid4';
            String username4 = 'Stefan';


            String new_cat = 'Programming 1';
            String UID5 = 'uid5';
            String username5 = 'Marko';

            await instance.collection('leaderboard').doc(UID4+ '-' + new_cat).set({username4: {'position': 1, 'points': 100}});

            /// Instance of the [Leaderboard] class.
            Leaderboard lb4 = await Leaderboard.createPublic(new_cat, username4, instance: instance, id: UID4);

            await lb4.getData();


            Leaderboard lb5 = await Leaderboard.createPublic(new_cat, username5, instance: instance, id: UID4);

            await lb5.updateCurrentUserPoints(50);

            await lb5.getData();


        expect(
            await lb5.getEntries().any((element) =>
            element.getName == 'Marko' &&
                element.getScore == 50 &&
                element.getPosition == 1),
            true);
      });


}
