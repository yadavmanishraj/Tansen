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
    StreamController<double> streamController = StreamController.broadcast();

    var model =
        await isar.downloadModels.filter().modelIdEqualTo(id).findFirst();

    isar.downloadModels.watchLazy(fireImmediately: true).listen((event) async {
      model = await isar.downloadModels.filter().modelIdEqualTo(id).findFirst();
      if (model != null) {
        Rx.combineLatest2(downloadManager.getProgress(model!.taskId!),
            downloadManager.getStatus(model!.taskId!), (progress, status) {
          log("progress.toString()", name: "Progress");

          if (status == DownloadTaskStatus.complete) {
            streamController.add(100);
          } else {
            streamController.add(progress / 100);
          }
        }).doOnDone(() {
          streamController.close();
        });
      }
    });
    if (model != null) {
      Rx.combineLatest2(
          downloadManager.getProgress(id), downloadManager.getStatus(id),
          (progress, status) {
        if (status == DownloadTaskStatus.complete) {
          streamController.add(1);
        } else {
          streamController.add(progress / 100);
        }
      });
    } else {
      streamController.add(0);
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
