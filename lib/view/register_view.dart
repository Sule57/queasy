import 'package:flutter/material.dart';
import 'package:queasy/view/login_view.dart';
import 'widgets/rounded-button.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LogInView(),
                  )))),
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Create an account'),
            const TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            const TextField(
              decoration: InputDecoration(
                  labelText: 'Email', hintText: 'yourname@example.com'),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Password',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Password',
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: RoundedButton(buttonName: "Sign Up"),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text('or sign up with'),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Image.asset('lib/assets/images/google.png'),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Image.asset(
                        'lib/assets/images/twitter.png',
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Image.asset(
                        'lib/assets/images/facebook.png',
                      ),
                      onPressed: () {},
                    ),
                  ],
                ))
          ],
        ),
      ]),
    );
  }
}
