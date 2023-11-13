import './../models/services/google_service.dart';
import 'package:flutter/material.dart';

class LaunchScreen extends StatefulWidget {
  @override
  LaunchScreenState createState() {
    return LaunchScreenState();
  }
}

class LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Expense manager - Email read',
        home: Scaffold(
          body: Container(
            color: Colors.white,
            child: Center(
                child: Column(children: [
              Image.asset(
                "assets/images/rupee-indian.png",
                height: 100,
                width: 100,
              ),
              TextButton(
                onPressed: GoogleService.instance?.signInService,
                child: Container(
                  color: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text(
                    'Flat Button',
                  ),
                ),
              ),
              TextButton(
                onPressed: MailService.instance?.getUserMail,
                child: Container(
                  color: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text(
                    'Print mail count',
                  ),
                ),
              )
            ])),
          ),
        ));
  }
}
