import 'package:path_provider/path_provider.dart';

String? _dirPath;

Future<String> initDirPath() async {
  _dirPath ??= (await getApplicationDocumentsDirectory()).path;
  return _dirPath!;
}

String filePath(String name) {
  return '$_dirPath/$name';
}
