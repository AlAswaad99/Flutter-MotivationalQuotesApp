import 'dart:io';
import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';


class ScreenshotService{
Future<void> takeScreenshot(ScreenshotController _screenshotController) async {
  Uint8List _imageFile;
  // final directory = (await getApplicationDocumentsDirectory()).path;
  String fileName = DateTime.now().microsecondsSinceEpoch.toString();

  await _screenshotController.capture().then((value) {
    _imageFile = value;
  });
  // _toggleExpand();
  // ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Screenshot Successfully Saved In Gallery")));

  final result = await ImageGallerySaver.saveImage(_imageFile, name: fileName);

  print(result);
}

Future<bool> _requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}

Future<bool> saveScreenshot(ScreenshotController _screenshotController) async {
  Directory directory;
  try {
    if (Platform.isAndroid) {
      if (await _requestPermission(Permission.storage)) {
        directory = await getExternalStorageDirectory();
        String newPath = "";
        print(directory);
        List<String> paths = directory.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/RPSApp";
        directory = Directory(newPath);
      } else {
        return false;
      }
    } else {
      if (await _requestPermission(Permission.photos)) {
        directory = await getTemporaryDirectory();
      } else {
        return false;
      }
    }

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    if (await directory.exists()) {
      File saveFile = File(
          directory.path + DateTime.now().microsecondsSinceEpoch.toString());
      await takeScreenshot(_screenshotController);

      // _toggleExpand();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text("Screenshot Successfully Saved In Gallery")));

      if (Platform.isIOS) {
        await ImageGallerySaver.saveFile(saveFile.path,
            isReturnPathOfIOS: true);
      }

      return true;
    }
  } catch (e) {
    print(e);
  }

  return false;
}

}

