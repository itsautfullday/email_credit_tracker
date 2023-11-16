import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;

class GoogleService {
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [GmailApi.gmailReadonlyScope],
  );

  GoogleService._() {}

  static GoogleService? _instance;
  static GoogleService? get instance {
    _instance ??= GoogleService._();
    return _instance;
  }

  bool isUserSignedIn = false;

  void signInService() async {
    try {
      await googleSignIn.signIn();
    } catch (e) {
      print(e.toString());
      isUserSignedIn = false;
    }
    isUserSignedIn = true;
  }

  Future<gapis.AuthClient?> getAuthClient() {
    if (!isUserSignedIn) {
      throw Exception("Trying to fetch auth client before sign in");
    }
    return googleSignIn.authenticatedClient();
  }
}

class MailService {
  static MailService? _instance;
  MailService._() {}

  static MailService? get instance {
    _instance ??= MailService._();
    return _instance;
  }

  getUserMail() async {
    print("Caling getUserMail");
    gapis.AuthClient? client = await GoogleService.instance!.getAuthClient();
    if (client == null) {
      return;
    }

    ListMessagesResponse response = await GmailApi(client).users.messages.list("me");
    
  }
}
