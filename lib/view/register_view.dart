import 'package:flutter/material.dart';
import 'package:queasy/view/widgets/rounded-button.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // This avoids the overflow error
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Logo and name
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 7,
                child: Image.asset(
                  'lib/assets/images/logo_and_name.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Container with the text fields and sign up button
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Container(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const TextField(
                          decoration: InputDecoration(
                              labelText: 'E-mail',
                              hintText: 'yourname@example.com'),
                        ),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                          ),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: RoundedButton(
                            buttonName: 'Sign Up',
                            backgroundColor: Colors.white,
                            textColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Line divider with 'or' text
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 14.0),
                    child: const Divider(
                        color: Colors.grey, height: 36, thickness: 1.0),
                  ),
                ),
                const Text("or sign up with", style: TextStyle(fontSize: 16.0)),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 14.0, right: 10.0),
                    child: const Divider(
                        color: Colors.grey, height: 36, thickness: 1.0),
                  ),
                ),
              ],
            ),

            // Social media sign up buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Image.asset('lib/assets/images/google.png'),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Image.asset(
                    'lib/assets/images/facebook.png',
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Image.asset(
                    'lib/assets/images/twitter.png',
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
