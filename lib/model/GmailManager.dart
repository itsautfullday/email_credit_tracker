//Best to have different
//Manages all interactions with Google
import 'package:email_credit_tracker/Constants.dart';
import 'package:email_credit_tracker/model/EmailContent.dart';
import 'package:email_credit_tracker/model/EmailManager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  Future<void> signIn() async {
    try {
      GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
      isUserSignedIn = (signInAccount != null);
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

  Future<void> loadSignInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final counter = prefs.getBool(Constants.SIGN_IN_STATUS) ?? 0;
    return;
  }

  void saveSignInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.SIGN_IN_STATUS, isUserSignedIn);
  }

  EmailContent? _parseMessage(Message message) {
    //Figure out raw messsage
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

    if (message.payload!.parts != null && message.payload!.parts!.isNotEmpty) {
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

    return null;
  }

  Future<List<EmailContent>> getUserMail() async {
    List<EmailContent> result = [];
    gapis.AuthClient? client = await _getAuthClient();
    if (client == null) {
      return result;
    }

    ListMessagesResponse response =
        await GmailApi(client).users.messages.list("me");

    List<Message>? messages = response.messages;
    if (messages == null) {
      return result;
    }

    for (int i = 0; i < messages.length; i++) {
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
    }

    print("After getting result len " + result!.length!.toString());

    return result;
  }
}
