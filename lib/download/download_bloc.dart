// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:muisc_repository/muisc_repository.dart';

import 'package:tansen/download/download_model.dart';
import 'package:tansen/download/song_downloader.dart';
import 'package:tansen/download/task_manager.dart';

abstract class DownloadEvent {}

class DownloadInitialEvent extends DownloadEvent {}

class DownloadProgressEvent extends DownloadEvent {}

class SongDownloadEvent extends DownloadEvent {
  BaseModel baseModel;
  SongDownloadEvent({
    required this.baseModel,
  });
}

class DownloadState {
  bool isLoading = false;
  List<BaseModel> baseModels;

  DownloadState({
    required this.isLoading,
    this.baseModels = const [],
  });

  DownloadState copyWith({
    bool? isLoading,
    List<BaseModel>? baseModels,
  }) {
    return DownloadState(
      isLoading: isLoading ?? this.isLoading,
      baseModels: baseModels ?? this.baseModels,
    );
  }
}

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final Isar _isar;
  late final SongDownloader songDownloader;
  late final DownloadManager downloadManager;

  DownloadBloc(this._isar, this.downloadManager)
      : songDownloader = SongDownloader(_isar, downloadManager),
        super(DownloadState(isLoading: true)) {
    on<DownloadProgressEvent>(onDataChnages);
    on<DownloadInitialEvent>(_onDownloadEvent);
    on<SongDownloadEvent>(_onSongDownloadEvent);

    add(DownloadInitialEvent());
  }

  Stream<double> progress(String modelId) => songDownloader.progress(modelId);

  FutureOr<void> _onDownloadEvent(
      DownloadEvent event, Emitter<DownloadState> emit) {
    add(DownloadProgressEvent());
    _isar.downloadModels.watchLazy(fireImmediately: true).listen((event) {
      add(DownloadProgressEvent());
    });
  }

  FutureOr<void> onDataChnages(
      DownloadEvent event, Emitter<DownloadState> emit) async {
    await _isar.txn(() async {
      final downloadModels =
          await _isar.downloadModels.filter().taskIdIsNotNull().findAll();

      emit(DownloadState(
          isLoading: false,
          baseModels: downloadModels.map((e) => e.toBaseModel()).toList()));
    });
  }

  FutureOr<void> _onSongDownloadEvent(
      SongDownloadEvent event, Emitter<DownloadState> emit) {
    songDownloader.downloadSong(event.baseModel);
  }
}
