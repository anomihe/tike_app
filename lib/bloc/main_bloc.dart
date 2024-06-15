import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_downloader/bloc/bloc_events.dart';
import 'package:tiktok_downloader/bloc/bloc_state.dart';
import 'package:tiktok_downloader/service/dio_service.dart';

import '../service/downloader_services.dart';

class MainBloc extends Bloc<Downloader, DownloaderState> {
  final DownloadServices _downloadServices = DownloadServices();
  final DioServices services = DioServices();
  late StreamSubscription<int> _progressSubscription;
  MainBloc() : super(IntialState()) {
    on<EnterLink>(enteraddress);
    on<UpdateDownloadProgress>(_onUpdateDownloadProgress);
    _progressSubscription =
        _downloadServices.progressController.stream.listen((progress) {
      add(UpdateDownloadProgress(progress));
    });
    on<DownloadComplete>(_downloadComplete);
    on<CancelEvent>(_error);
  }
  @override
  Future<void> close() {
    _progressSubscription.cancel();
    _downloadServices.dispose();
    return super.close();
  }

  FutureOr<void> enteraddress(
      EnterLink link, Emitter<DownloaderState> emit) async {
    Directory? directory = await getExternalStorageDirectory();
    String savedDir = directory!.path;
    String fileName = path.basename(link.link);
    //Directory(savedDir).create(recursive: true);
    //String filePath = path.join(savedDir, fileName);
    String filePath = '$savedDir $fileName';
    //int i = 1;
    PermissionStatus status = await Permission.storage.request();
    //if (status == PermissionStatus.granted) {
    // if (File(filePath).existsSync()) {
    //   await _downloadServices.createEnque(
    //       fileName, filePath, '${fileName} ${i++}');
    // } else {
    //   await _downloadServices.createEnque(link.link, filePath, fileName);
    // }
    //}
    // emit(DownloadInProgress(0));

    // await _downloadServices.createEnque(
    //     link.link, savedDir, fileName);
    // await services.downloadVideo(link.link, savedDir, fileName);
     services.getData(link.link);
  }

  void _onUpdateDownloadProgress(
      UpdateDownloadProgress event, Emitter<DownloaderState> emit) async {
    PermissionStatus status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      if (event.progress == 100) {
        emit(DownloadingComplete(event.progress.toString()));
        // Future.delayed(Duration(minutes: 1));
        // emit(DownloadInProgress(0));
      } else {
        emit(DownloadInProgress(event.progress));
      }
    } else {
      openAppSettings();
    }
  }

  void _error(CancelEvent event, Emitter<DownloaderState> emit) {
    emit(DownloadFailed());
  }

  void _downloadComplete(
      DownloadComplete event, Emitter<DownloaderState> emit) {
    emit(DownloadingComplete(0.toString()));
  }
}
