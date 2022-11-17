import 'package:flutter/material.dart';
import 'widgets/custom_bottom_nav_bar.dart';

const List<String> list = <String>['All', 'Art', 'Science', 'Sports'];

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({Key? key}) : super(key: key);

  @override
  State<LeaderboardView> createState() => _LeaderboardView();
}

class _LeaderboardView extends State<LeaderboardView> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(pageTitle: 'Leaderboard'),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: const Color(0xFFB366FF),
            pinned: true,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text('Leaderboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                  ) //TextStyle
                  ),
            ),
            actions: [
              DropdownButton<String>(
                alignment: AlignmentDirectional.centerStart,
                borderRadius: BorderRadius.circular(15),
                value: dropdownValue,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 0,
                  color: const Color(0xFFB366FF),
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    const Divider(
                      height: 20,
                      color: Colors.white,
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      tileColor: index == 0
                          ? const Color(0x40B366FF)
                          : const Color(0x40D9D9D9),
                      textColor: const Color(0xFFFF8C66),
                      iconColor: Colors.white,
                      leading: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      title: index != 0
                          ? const Text(
                              'username',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 26),
                              textAlign: TextAlign.center,
                            )
                          : const Text(
                              'username',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 26),
                              textAlign: TextAlign.center,
                            ),
                      //const Icon(Icons.back_hand_outlined),
                      //subtitle: index == 0 ? const Text('username', textAlign: TextAlign.center,style:TextStyle(color: Colors.black, fontSize: 26),): null,
                      trailing: const Text(
                        'points',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
