import 'dart:io';
import 'package:email_credit_tracker/Constants.dart';

//Gave in and CHAT GPTed this class
class FileUtil {
  // 1. Check if file exists
  static Future<bool> fileExist(String path) async {
    return File(path).exists();
  }

  // 2. Write to file
  static Future<void> writeToFile(String path, String content,
      {int insertionType = Constants.FILE_OVERWRITE, bool forceCreate = false}) async {
    final file = File(path);

    if (!forceCreate && !await fileExist(path)) {
      throw Exception('File does not exist at $path');
    }

    if (insertionType == Constants.FILE_OVERWRITE) {
      await file.writeAsString(content);
    } else if (insertionType == Constants.FILE_APPEND) {
      await file.writeAsString(content, mode: FileMode.append);
    } else {
      throw Exception('Invalid insertionType. Use OVERWRITE or APPEND.');
    }
  }

  // 3. Read file
  static Future<String> readFile(String path) async {
    final file = File(path);

    if (!await fileExist(path)) {
      throw Exception('File does not exist at $path');
    }

    return await file.readAsString();
  }
}