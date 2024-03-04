//Best to have different
//Manages all interactions with Google
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

  void getUserMail() async {
    print("Caling getUserMail");
    gapis.AuthClient? client = await _getAuthClient();
    if (client == null) {
      print("Caling getUserMail return ");
      return;
    }

    ListMessagesResponse response =
        await GmailApi(client).users.messages.list("me");

    List<Message>? messages = response.messages;
    if (messages == null) {
      print("Message is null");
    } else {
      print("Length : " + messages.length.toString());
      for (int i = 0; i < messages.length; i++) {
        Message message =
            await GmailApi(client).users.messages.get("me", messages[i].id!);

        if (message.payload == null) {
          print(message.toJson().toString());
          continue;
        }

        message.payload!.headers!.forEach((header) {
          print(header.toJson());
        });

        if (message.payload!.parts != null) {
          message.payload!.parts!.forEach((part) {
            part.headers!.forEach((header) {
              print(header.toJson());
            });
            String decodedString = utf8.decode(part.body!.dataAsBytes);
            // print("Body of part " + decodedString);
          });
        }

        if (i > 10) {
          break;
        }
      }
    }
  }
}
