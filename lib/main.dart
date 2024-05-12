import 'package:email_credit_tracker/model/AutoIngestionManager.dart';
import 'package:email_credit_tracker/model/GmailManager.dart';
import 'package:email_credit_tracker/model/TransactionsManager.dart';
import 'package:email_credit_tracker/view/TransactionView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

void main() async {
  // tells Flutter not to start running the application widget code until the Flutter framework is completely booted. Firebase uses native platform channels, which require the framework to be running.
  WidgetsFlutterBinding.ensureInitialized();

  //  sets up a connection between your Flutter app and your Firebase project. The DefaultFirebaseOptions.currentPlatform is imported from our generated firebase_options.dart file. This static value detects which platform you're running on, and passes in the corresponding Firebase keys.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initalizeApplication();
  runApp(MyApp());
}

void load() {
  TransactionsManager.instance.loadTransactionsData();
  GmailManager.instance.loadSignInStatus();
}

//TODO : Figure out where to use save!
void save() async {
  await TransactionsManager.instance.saveTransactionData();
  GmailManager.instance.saveSignInStatus();
}

void initalizeApplication() {
  AutoIngestionManager.instance.manager = GmailManager.instance;
  load();
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        save();
        break;
      case AppLifecycleState.paused:
        save();
      case AppLifecycleState.detached:
        save();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const appName = 'Custom Themes';

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        useMaterial3: true,
        // Define the default brightness and colors.
        scaffoldBackgroundColor: Color.fromRGBO(238, 231, 215, 1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(238, 231, 215, 1),
          // TRY THIS: Change to "Brightness.light"
          //           and see that all colors change
          //           to better contrast a light background.
          brightness: Brightness.light,
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // TRY THIS: Change one of the GoogleFonts
          //           to "lato", "poppins", or "lora".
          //           The title uses "titleLarge"
          //           and the middle text uses "bodyMedium".
          titleLarge: GoogleFonts.vt323(
            fontSize: 30,
          ),
          bodyMedium: GoogleFonts.vt323(
            fontSize: 25,
          ),
          displaySmall: GoogleFonts.vt323(
            fontSize: 10
          ),
        ),
      ),
      home: TransactionView(),
    );
  }
}

