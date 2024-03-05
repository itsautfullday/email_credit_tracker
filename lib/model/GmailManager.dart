//Best to have different
//Manages all interactions with Google
import 'package:email_credit_tracker/model/EmailContent.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;
import 'dart:convert';

class GmailManager {
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

  EmailContent _parseMessage(Message message) {
    //Figure out from and to
    //Figure out raw messsage
    //This is present in the headers of the primary message part
    //Have to figure out how to make raw!

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

      result.add(_parseMessage(message));
    }

    return result;
  }
}
