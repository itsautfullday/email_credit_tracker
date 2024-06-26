import 'package:email_credit_tracker/controller/TransactionViewController.dart';
import 'package:email_credit_tracker/model/AutoIngestionManager.dart';
import 'package:email_credit_tracker/model/ExpenseCategoryManager.dart';
import 'package:email_credit_tracker/model/GmailManager.dart';
import 'package:email_credit_tracker/model/TransactionsManager.dart';
import 'package:email_credit_tracker/view/CommonWidgets/ViewScaffold.dart';
import 'package:email_credit_tracker/view/IntroductionView.dart';
import 'package:email_credit_tracker/view/TransactionView/TransactionView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// 1 Add the not-retrigger flow
// 2 Add email last read ts for accurate data parsing
// 4 Stress test - save and load flows

void main() async {
  // tells Flutter not to start running the application widget code until the Flutter framework is completely booted. Firebase uses native platform channels, which require the framework to be running.
  WidgetsFlutterBinding.ensureInitialized();

  //  sets up a connection between your Flutter app and your Firebase project. The DefaultFirebaseOptions.currentPlatform is imported from our generated firebase_options.dart file. This static value detects which platform you're running on, and passes in the corresponding Firebase keys.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initalizeApplication();
  runApp(EmailTransactionApp());
}

class AppDataManager {
  AppDataManager._();

  static AppDataManager? _instance;
  static AppDataManager get instance {
    _instance ??= AppDataManager._();
    return _instance!;
  }

  void load() async {
    await ExpenseCategoryManager.instance.loadCategoryInfo();
    await GmailManager.instance.load();
    await TransactionsManager.instance.loadTransactionsData();
    TransactionViewController.instance.updateTransactionsView();
    DataLoaded.instance.setDataLoaded(true);
  }

  void save() async {
    await TransactionsManager.instance.saveTransactionData();
    await GmailManager.instance.save();
  }
}

void initalizeApplication() {
  AppDataManager.instance.load();
  AutoIngestionManager.instance.manager = GmailManager.instance;
}

class DataLoaded extends ChangeNotifier {
  DataLoaded._();
  static DataLoaded? _instance;
  static DataLoaded get instance {
    _instance ??= DataLoaded._();
    return _instance!;
  }

  bool dataLoaded = false;
  void setDataLoaded(bool val) {
    dataLoaded = val;
    notifyListeners();
  }
}

class EmailTransactionApp extends StatefulWidget {
  @override
  EmailTransactionAppState createState() => EmailTransactionAppState();
}

class EmailTransactionAppState extends State<EmailTransactionApp>
    with WidgetsBindingObserver {
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
        // save();
        break;
      case AppLifecycleState.inactive:
        // save();
        break;
      case AppLifecycleState.paused:
        AppDataManager.instance.save();
        break;
      case AppLifecycleState.detached:
        // save();
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
              fontSize: 35,
            ),
            bodyMedium: GoogleFonts.vt323(
              fontSize: 30,
            ),
            displaySmall: GoogleFonts.vt323(fontSize: 20),
          ),
        ),
        home: ChangeNotifierProvider(
          create: (context) => DataLoaded.instance,
          child: Consumer<DataLoaded>(
            builder: (context, value, child) {
              if (!value.dataLoaded) {
                return ViewScaffold(
                    body: Container(
                  alignment: Alignment.center,
                  child: Text("Loading sign in status",
                      style: Theme.of(context).textTheme.bodyMedium),
                ));
              }
              if (GmailManager.instance.isUserSignedIn) {
                return TransactionView();
              } else {
                return IntroductionView();
              }
            },
          ),
        ));
  }
}
