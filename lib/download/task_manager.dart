import 'dart:async';
import 'dart:isolate';
import 'package:logger/logger.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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
  final BehaviorSubject<List<DownloadTask>> _downloadTaskController =
      BehaviorSubject();

  final ReceivePort _receivePort = ReceivePort();
  final BehaviorSubject _tasksStreamContrller = BehaviorSubject();

  DownloadManager() {
    initialize();
  }

  Stream<List<DownloadTask>> get tasksList => _downloadTaskController.stream;

  Future<void> initialize() async {
    // await FlutterDownloader.initialize(debug: kDebugMode, ignoreSsl: true);
    init();
  }

  bind() {
    final result = IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "download_sendport");
    if (!result) {
      IsolateNameServer.removePortNameMapping("download_sendport");
      bind();
    }
  }

  unBind() {
    IsolateNameServer.removePortNameMapping("download_sendport");
  }

  init() async {
    final tasks = await FlutterDownloader.loadTasks();

    _downloadTaskController.add(tasks ?? []);

    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "download_sendport");

    _receivePort.pipe(_tasksStreamContrller);

    Logger logger = Logger();

    _tasksStreamContrller.listen(
      (dynamic data) async {
        final tasks = await FlutterDownloader.loadTasks();

        _downloadTaskController.add(tasks ?? []);

        logger.d("There is no no more progress ${data[0]}");
        // final taskId = data[0];
        // final DownloadTaskStatus status = DownloadTaskStatus.values[data[1]];
        // final int progress = data[2];

        // DownloadTask? task;
        // bool isinList = false;

        // try {
        //   task = _downloadTaskController.value
        //       .firstWhere((element) => element.taskId == taskId);
        //   isinList = true;
        // } on StateError catch (_) {
        //   final tasks = await FlutterDownloader.loadTasksWithRawQuery(
        //       query: "SELECT * FROM task WHERE task_id = '$taskId'");
        //   task = tasks?.first;
        // }

        // if (task != null) {
        //   task =
        //       task.copyWith(progress: progress, taskId: taskId, status: status);

        //   if (isinList) {
        //     final taskIndex = _downloadTaskController.value
        //         .indexWhere((element) => element.taskId == task!.taskId);
        //     _downloadTaskController.value[taskIndex] == task;
        //     _downloadTaskController.add(_downloadTaskController.value);
        //   } else {
        //     _downloadTaskController.value.add(task);
        //     _downloadTaskController.add(_downloadTaskController.value);
        //   }
        // }
      },
    );

    await FlutterDownloader.registerCallback(progressTracker);
  }

  dispose() {
    unBind();
  }

  @pragma('vm:entry-point')
  static void progressTracker(String id, int status, int progress) {
    final SendPort sendPort =
        IsolateNameServer.lookupPortByName("download_sendport")!;
    sendPort.send([id, status, progress]);
  }

  Stream<int> getProgress(String taskId) {
    return _tasksStreamContrller
        .where((event) => event[0] == taskId)
        .map((event) => event[2]);
    // return _tasksStreamContrller
    //     .where((event) => event[0] == taskId)
    //     .map((event) => event[2]);
  }

  Stream<DownloadTaskStatus> getStatus(String taskId) {
    return _downloadTaskController.map((event) =>
        event.firstWhere((element) => element.taskId == taskId).status);
  }

  Stream<DownloadTask> getTask(String taskId) {
    return _downloadTaskController.map(
        (event) => event.firstWhere((element) => element.taskId == taskId));
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
}
