import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:download/models/download_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

extension on DownloadTask {
  DownloadTask copyWith({
    String? taskId,
    DownloadTaskStatus? status,
    int? progress,
    String? url,
    String? filename,
    String? savedDir,
    int? timeCreated,
    bool? allowCellular,
  }) {
    return DownloadTask(
        taskId: taskId ?? this.taskId,
        status: status ?? this.status,
        progress: progress ?? this.progress,
        url: url ?? this.url,
        filename: filename ?? this.filename,
        savedDir: savedDir ?? this.savedDir,
        timeCreated: timeCreated ?? this.timeCreated,
        allowCellular: allowCellular ?? this.allowCellular);
  }
}

class DownloadManager {
  // final List<DownloadTask> _downloadTaskStatusList = [];
  final BehaviorSubject<List<DownloadTask>> _downloadTaskController =
      BehaviorSubject();

  late final Directory directory;

  final Isar _isar;

  DownloadManager(this._isar);

  final ReceivePort _receivePort = ReceivePort();
  final BehaviorSubject _tasksStreamContrller = BehaviorSubject.seeded([]);

  Future<void> initialize() async {
    await FlutterDownloader.initialize(debug: kDebugMode, ignoreSsl: true);
    init();
  }

  init() async {
    FlutterDownloader.loadTasks()
        .then((value) => _downloadTaskController.add(value ?? []));

    try {
      final dir = await getDownloadsDirectory();
      directory = dir!;
    } catch (e) {}

    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "download_sendport");

    _receivePort.pipe(_tasksStreamContrller);

    _tasksStreamContrller.listen(
      (data) async {
        final taskId = data[0];
        final DownloadTaskStatus status = DownloadTaskStatus.values[data[1]];
        final int progress = data[2];

        DownloadTask? task;
        bool isinList = false;

        try {
          task = _downloadTaskController.value
              .firstWhere((element) => element.taskId == taskId);
          isinList = true;
        } on StateError catch (_) {
          final tasks = await FlutterDownloader.loadTasksWithRawQuery(
              query: "SELECT * FROM task WHERE task_id = '$taskId'");
          task = tasks?.first;
        }

        if (task != null) {
          task =
              task.copyWith(progress: progress, taskId: taskId, status: status);

          if (isinList) {
            final taskIndex = _downloadTaskController.value
                .indexWhere((element) => element.taskId == task!.taskId);
            _downloadTaskController.value[taskIndex] == task;
            _downloadTaskController.add(_downloadTaskController.value);
          } else {
            _downloadTaskController.value.add(task);
            _downloadTaskController.add(_downloadTaskController.value);
          }
        }
      },
    );

    await FlutterDownloader.registerCallback(progressTracker);
  }

  @pragma('vm:entry-point')
  static void progressTracker(String id, int status, int progress) {
    final SendPort sendPort =
        IsolateNameServer.lookupPortByName("download_sendport")!;
    sendPort.send([id, status, progress]);
  }

  Stream<double> getProgress(String taskId) {
    return _downloadTaskController
        .map((event) =>
            event.firstWhere((element) => element.taskId == taskId).progress)
        .cast<double>();
  }

  Stream<DownloadTaskStatus> getStatus(String taskId) {
    return _downloadTaskController.map((event) =>
        event.firstWhere((element) => element.taskId == taskId).status);
  }

  Stream<List<DownloadTask>> get tasks => _downloadTaskController.stream;

  Future<String?> downloadFile(
      String url, String dir, String fileName, ValueChanged? onProgress) async {
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir,
      fileName: fileName,
      showNotification: false,
      openFileFromNotification: false,
      allowCellular: false,
    );

    if (taskId != null) {
      getProgress(taskId).listen(onProgress);
    }

    return taskId;
  }

  deleteFile(String taskId) {
    FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: true);
    _isar.writeTxn(() async {
      _isar.downloadModels.deleteByIndex("taskId", [taskId]);
    });
  }
}
