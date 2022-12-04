import 'package:flutter/material.dart';
import 'package:queasy/src/model/leaderboard_entry.dart';

class UserTileDesktop extends StatelessWidget {
  final int index;
  final List<LeaderboardEntry> entries;

  const UserTileDesktop(
      {super.key, required this.index, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // const Divider(
        //   height: 20,
        // ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: ListTile(
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            tileColor: Colors.white,
            textColor: const Color(0xFFFF8C66),
            iconColor: Colors.white,
            leading: Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                    color: Color(0xFFFF8C66), shape: BoxShape.circle),
                child: Center(
                    child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ))),
            title: Text(
              entries[index].getName,
              style: TextStyle(color: Colors.black, fontSize: 26),
            ),
            subtitle: Text(
              entries[index].getScore.toString(),
            ),
            //const Icon(Icons.back_hand_outlined),
            //subtitle: index == 0 ? const Text('username', textAlign: TextAlign.center,style:TextStyle(color: Colors.black, fontSize: 26),): null,
          ),
        ),
      ],
    );
  }
}
