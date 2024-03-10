import 'EmailContent.dart';

abstract class EmailManager {
  Future<List<EmailContent>> getUserMail();
}
