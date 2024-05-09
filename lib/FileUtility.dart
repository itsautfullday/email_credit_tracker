import 'dart:io';
import 'package:email_credit_tracker/Constants.dart';
import 'package:path_provider/path_provider.dart';

//Gave in and CHAT GPTed this class
class FileUtil {
  // 1. Check if file exists
  static Future<bool> fileExist(String path) async {
    final localPath = await _localPath;
    String actualPath = '$localPath/$path';
    return File(actualPath).exists();
  }

  // 2. Write to file
  static Future<void> writeToFile(String path, String content,
      {int insertionType = Constants.FILE_OVERWRITE,
      bool forceCreate = false}) async {
    final localPath = await _localPath;
    String actualPath = '$localPath/$path';
    final file = File(actualPath);

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

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // 3. Read file
  static Future<String> readFile(String path) async {
    final localPath = await _localPath;
    String actualPath = '$localPath/$path';
    final file = File(actualPath);

    if (!await fileExist(path)) {
      throw Exception('File does not exist at $path');
    }

    return await file.readAsString();
  }
}
