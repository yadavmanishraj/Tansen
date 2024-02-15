// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:isar/isar.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tansen/download/download_model.dart';
import 'package:tansen/download/song_collection.dart';
import 'package:tansen/download/task_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DownloadedModel {
  DownloadTask task;
  String modelId;
  DownloadedModel({
    required this.task,
    required this.modelId,
  });
}

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
    streamInit();
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

  BehaviorSubject<List<DownloadedModel>> songsList = BehaviorSubject();

  close() {
    songsList.close();
  }

  streamInit() async {
    var songs = await isar.downloadModels.filter().modelIdIsNotNull().findAll();
    isar.downloadModels.watchLazy(fireImmediately: true).listen((event) async {
      songs = await isar.downloadModels.filter().modelIdIsNotNull().findAll();
      downloadManager.tasksList
          .map((event) => event
              .map((e) => DownloadedModel(
                  task: e,
                  modelId: songs
                      .firstWhere((element) => element.taskId == e.taskId)
                      .modelId!))
              .toList())
          .pipe(songsList);
    });
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

  Stream<DownloadTask> taskAlt(String id) {
    return songsList.flatMap((value) => Stream.value(
        value.firstWhere((element) => element.modelId == id).task));
  }

  Stream<double> progressAlt(String id) {
    return songsList.flatMap((value) => Stream.value(
        value.firstWhere((element) => element.modelId == id).task.progress /
            100));
  }

  Stream<DownloadTaskStatus> statusAlt(String id) {
    return songsList.flatMap((value) => Stream.value(
        value.firstWhere((element) => element.modelId == id).task.status));
  }

  Stream<DownloadTask> task(String id) async* {
    StreamController<DownloadTask> streamController =
        StreamController.broadcast();

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
    DefaultCacheManager().downloadFile(baseModel.veryHigh!);
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

  downloadSongs(BaseModel collection, List<BaseModel> songs) async {
    isar.writeTxn(() async {
      var collectiond = await isar.songCollections
          .filter()
          .modelIdEqualTo(collection.id!)
          .findFirst();
      if (collectiond == null) {
        isar.songCollections.put(SongCollection(
            imageSrc: collection.veryHigh,
            subTitle: collection.subText,
            title: collection.title,
            type: collection.type,
            modelId: collection.id!,
            songs: songs.map((e) => e.id!).toList()));
      }
    });
    songs.forEach(downloadSong);
  }
}
