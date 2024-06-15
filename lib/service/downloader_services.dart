import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';

import 'dart:async';

//import 'package:tiktok_downloader/service/permission_service.dart';

class DownloadServices {
  static const String portName = 'download_send_port';
  final StreamController<int> progressController =
      StreamController<int>.broadcast();
  ReceivePort receivePort = ReceivePort();

  DownloadServices() {
    registerIsolate();
  }

  Future<void> createEnque(String url, String savedDir, String fileName) async {
    // if(await PermissionService().requestStoragePermission()){
    Directory directory = Directory(savedDir);
    if (!await directory.exists()) {
      print('Directory does not exist, creating: $savedDir');
      await directory.create(recursive: true);
    } else {
      print('Directory already exists: $savedDir');
    }
    FlutterDownloader.registerCallback(callback);
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: savedDir,
      fileName: fileName,
      saveInPublicStorage: true,
      openFileFromNotification: true,
    );
    // }
  }

  @pragma('vm:entry-point')
  static void callback(String id, int status, int progress) {
    final SendPort? sendPort = IsolateNameServer.lookupPortByName(portName);
    sendPort?.send([id, status, progress]);
  }

  void registerIsolate() {
    bool success =
        IsolateNameServer.registerPortWithName(receivePort.sendPort, portName);
    if (!success) {
      IsolateNameServer.removePortNameMapping(portName);
      IsolateNameServer.registerPortWithName(receivePort.sendPort, portName);
    }
    receivePort.listen((dynamic data) {
      final int progress = data[2];
      progressController.add(progress);
    });
  }

  // void completed() {
  //   DownloadTaskStatus status = data[1];
  // }

  void dispose() {
    IsolateNameServer.removePortNameMapping(portName);
    receivePort.close();
    progressController.close();
  }
}

// class DownloadServices {
//    int downloadProgress = 0;
//   ReceivePort receivePort = ReceivePort();
//   Future<void> createEnque(String url, String savedDir) async {
//     FlutterDownloader.registerCallback(callback);
//     await FlutterDownloader.enqueue(
//         url: url, savedDir: savedDir, saveInPublicStorage: true);
//   }

//   @pragma('vm:entry-point')
//   static void callback(String id, DownloadTaskStatus status, int progress) {
//     final SendPort? sendPort = IsolateNameServer.lookupPortByName(portName);
//     sendPort?.send([id, status, progress]);
//   }

//   Future<void> registerIsolate() async {
//     bool success =
//         IsolateNameServer.registerPortWithName(receivePort.sendPort, portName);
//         receivePort.listen((dynamic data) {
//       downloadProgress = _getProgress(data[1], data[2]);
//     });
//   }
//    int _getProgress (DownloadTaskStatus status, int progress) {
//     switch(status.value) {
//       case 0:
//         downloadProgress = progress;
//        break;
//       case 1:
//         downloadProgress = progress;
      
//         break;
//       case 2:
//         downloadProgress = progress;
      
//         break;
//       case 3:
//         downloadProgress = progress;
        
//         break;
//       case 4:
//         downloadProgress = progress;
      
//         break;
//       case 5:
//         downloadProgress = progress;
       
//         break;
//       case 6:
//         downloadProgress = progress;
        
//         break;
//       default:
//         downloadProgress;
//     }
//     return downloadProgress;
//   }

//   void _dispose() {
//     IsolateNameServer.removePortNameMapping(portName);
//   }

// }
