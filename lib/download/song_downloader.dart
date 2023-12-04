// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:isar/isar.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tansen/download/download_bloc.dart';
import 'package:tansen/download/download_model.dart';
import 'package:tansen/download/task_manager.dart';

class SongDownloader {
  Isar isar;
  late String baseDir;

  bool _initialized = false;
  bool get initialized => _initialized;

  DownloadManager downloadManager;
  SongDownloader(this.isar, this.downloadManager) {
    initialize();
  }

  initialize() async {
    final downloadDir = await getDownloadsDirectory();
    baseDir = (await Directory("${downloadDir?.path}/songs").create()).path;
    _initialized = true;
  }

  Stream<double> progress(String id) async* {
    StreamController<double> streamController = StreamController();

    var model =
        await isar.downloadModels.filter().modelIdEqualTo(id).findFirst();
    if (model != null) {
      downloadManager
          .getProgress(model.taskId!)
          .map((event) => event / 100)
          .pipe(streamController);
    } else {
      isar.downloadModels
          .watchLazy(fireImmediately: true)
          .listen((event) async {
        var model =
            await isar.downloadModels.filter().modelIdEqualTo(id).findFirst();
        if (model != null) {
          downloadManager
              .getProgress(model.taskId!)
              .map((event) => event / 100)
              .pipe(streamController);
        }
      });
    }

    yield* streamController.stream;
  }

  Stream<DownloadTaskStatus> status(String id) async* {
    StreamController<DownloadTaskStatus> streamController = StreamController();

    var model =
        await isar.downloadModels.filter().modelIdEqualTo(id).findFirst();
    if (model != null) {
      downloadManager.getStatus(model.taskId!).pipe(streamController);
    } else {
      isar.downloadModels
          .watchLazy(fireImmediately: true)
          .listen((event) async {
        var model =
            await isar.downloadModels.filter().modelIdEqualTo(id).findFirst();
        if (model != null) {
          downloadManager.getStatus(model.taskId!).pipe(streamController);
        }
      });
    }

    yield* streamController.stream;
  }


  Stream<DownloadTask> task(String id) async* {
    StreamController<DownloadTask> streamController = StreamController.broadcast();

    var model =
        await isar.downloadModels.filter().modelIdEqualTo(id).findFirst();
    if (model != null) {
      downloadManager.getTask(model.taskId!).pipe(streamController);
    } else {
      isar.downloadModels
          .watchLazy(fireImmediately: true)
          .listen((event) async {
        var model =
            await isar.downloadModels.filter().modelIdEqualTo(id).findFirst();
        if (model != null) {
          downloadManager.getTask(model.taskId!).pipe(streamController);
        }
      });
    }

    yield* streamController.stream;
  }

  downloadSong(BaseModel baseModel) async {
    isar.writeTxn(() async {
      final model = await isar.downloadModels
          .filter()
          .modelIdEqualTo(baseModel.id!)
          .findFirst();

      if (model == null) {
        final downloadDir = await getDownloadsDirectory();
        baseDir = (await Directory("${downloadDir?.path}/songs").create()).path;
        final dir = await Directory("$baseDir/${baseModel.id}").create();
        final taskId = await FlutterDownloader.enqueue(
          url: (baseModel as SongDetails).downloadUrl!,
          savedDir: dir.path,
          allowCellular: true,
          showNotification: false,
          openFileFromNotification: false,
          fileName: "${baseModel.id}.mp3",
        );
        isar.downloadModels
            .put(DownloadModel.fromBaseModel(baseModel, taskId!));
      }
    });
  }
}
