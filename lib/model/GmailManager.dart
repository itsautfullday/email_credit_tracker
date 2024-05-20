//Best to have different
//Manages all interactions with Google
import 'package:email_credit_tracker/Constants.dart';
import 'package:email_credit_tracker/model/EmailContent.dart';
import 'package:email_credit_tracker/model/EmailManager.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';

class GmailManager extends EmailManager {
  GmailManager._internal_constructor() {
    print("Creating the internal constructor");
  }

  static GmailManager? _instance;

  static GmailManager get instance {
    _instance ??= GmailManager._internal_constructor();
    return _instance!;
  }

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [GmailApi.gmailReadonlyScope],
  );

  bool isUserSignedIn = false;
  bool emailFetchInProgress = false;
  String lastReadEmailIdentifier = "";

  @override
  String getLastReadEmailIdentifier() {
    return lastReadEmailIdentifier;
  }

  void setLastReadEmailIdentifier(String value) {
    lastReadEmailIdentifier = value;
  }

  Future<void> signIn() async {
    try {
      GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
      isUserSignedIn = (signInAccount != null);

      //Probably not the best way to do this
      DataLoaded.instance.setDataLoaded(true);
    } catch (e) {
      print(e.toString());
      isUserSignedIn = false;
    }

    print("Sign in status " + isUserSignedIn.toString());
  }

  Future<gapis.AuthClient?> _getAuthClient() {
    if (!isUserSignedIn) {
      throw Exception("Trying to fetch auth client before sign in");
    }
    return googleSignIn.authenticatedClient();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    lastReadEmailIdentifier = prefs.getString(Constants.LAST_READ_ID) ?? "";
    isUserSignedIn = prefs.getBool(Constants.SIGN_IN_STATUS) ?? false;

    if (isUserSignedIn) {
      await googleSignIn.signIn();
    }
    return;
  }

  Future<bool> save() async {
    final prefs = await SharedPreferences.getInstance();
    bool result = true;
    result = result &&
        await prefs.setString(Constants.LAST_READ_ID, lastReadEmailIdentifier);
    result =
        result && await prefs.setBool(Constants.SIGN_IN_STATUS, isUserSignedIn);
    return result;
  }

  EmailContent? _parseMessage(Message message) {
    try {
      Map<String, String> headers = Map();
      message.payload!.headers!.forEach((element) {
        headers[element.name!] = element.value!;
      });

      EmailContent emailContent = EmailContent();

      if (headers.containsKey("From")) {
        String fromHeader = headers["From"]!;
        int indexOpen = fromHeader.indexOf("<");
        int indexClose = fromHeader.indexOf(">");

        if (indexClose == -1 && indexOpen == -1) {
          emailContent.from = fromHeader!;
        } else {
          if (indexClose == -1 || indexOpen == -1) {
            //Some condusing error case
            return null;
          }
          emailContent.from = fromHeader.substring(indexOpen + 1, indexClose);
        }
      }

      if (headers.containsKey("Subject")) {
        emailContent.subject = headers["Subject"];
      }

      if (headers.containsKey('Date')) {
        emailContent.date = headers["Date"];
      }

      if (message.payload!.parts != null &&
          message.payload!.parts!.isNotEmpty) {
        print(emailContent.from);
        print(message.payload!.parts!.length);

        if (message.payload!.parts!.length != 1) {
          return null;
        }

        emailContent.elementType = message.payload!.parts!.first.mimeType;
        emailContent.emailTextRaw =
            utf8.decode(message.payload!.parts!.first.body!.dataAsBytes);

        return emailContent;
      }
    } catch (e, s) {
      print(
          "Exception here motherfucker : " + e.toString() + " " + s.toString());

      return null;
    }
    //Figure out raw messsage
  }

  Future<List<EmailContent>> getUserMail() async {
    print("Calling get user mail");
    if (emailFetchInProgress) {
      print("Calling get user mail again while fetch in progress");
      return [];
    }
    emailFetchInProgress = true;
    List<EmailContent> result = [];
    gapis.AuthClient? client = await _getAuthClient();
    if (client == null) {
      print("Calling get client is null");
      return result;
    }

    print("Calling get user whats up");

    ListMessagesResponse response =
        await GmailApi(client).users.messages.list("me");

    List<Message>? messages = response.messages;
    if (messages == null) {
      print("Calling get user messsages is null?");
      return result;
    }

    int lastMessage = messages.length - 1;
    String lastRead = getLastReadEmailIdentifier();
    print("Last read email is " + lastRead);

    for (int i = 0; i < messages.length; i++) {
      if (messages[i].id == lastRead) {
        lastMessage = i - 1;
        break;
      }
    }

    for (int i = 0; i <= lastMessage; i++) {
      Message message =
          await GmailApi(client).users.messages.get("me", messages[i].id!);

      if (message.payload == null) {
        print("Message payload is null " + message.toJson().toString());
        continue;
      }

      EmailContent? emailContent = _parseMessage(message);

      if (emailContent != null) {
        result.add(emailContent);
      }

      String parsedThroughString =
          ((i / messages.length) * 100).toInt().toString();
      sendPercentageMessage(parsedThroughString);
    }
    print("Read all messages ");

    setLastReadEmailIdentifier(messages!.first.id!);

    emailFetchInProgress = false;
    return result;
  }

  void sendPercentageMessage(String parsedThroughString) {
    print("Sending message " + parsedThroughString);
    Fluttertoast.showToast(
        msg: "Parsed $parsedThroughString% of messages",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
