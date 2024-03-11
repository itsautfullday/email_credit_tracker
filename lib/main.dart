import 'package:email_credit_tracker/view/IntroductionView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

  runApp(const MyApp());
}

void initalizeApplication() {
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          bodyMedium: GoogleFonts.vt323(),
          displaySmall: GoogleFonts.vt323(),
        ),
      ),
      home: IntroductionView(),
    );
  }
}
