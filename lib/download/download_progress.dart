import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:tansen/download/download_bloc.dart';

class DownloadProgressIndicator extends StatelessWidget {
  const DownloadProgressIndicator({super.key, required this.modelId});
  final String modelId;
  @override
  Widget build(BuildContext context) {
    final progressStream = context.read<DownloadBloc>().progress(modelId);

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface.withOpacity(.5),
        child: StreamBuilder(
          stream: progressStream,
          initialData: 0,
          builder: (context, snapshot) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
                value: snapshot.data?.toDouble() ?? 0.0,
              ),
            );
          },
        ),
      ),
    );
  }
}

extension on DownloadTaskStatus {
  Widget get icon {
    switch (this) {
      case DownloadTaskStatus.undefined:
        return const SizedBox.shrink();
      case DownloadTaskStatus.enqueued:
        return const Icon(Icons.downloading);
      case DownloadTaskStatus.running:
        return const Icon(Icons.downloading_outlined);
      case DownloadTaskStatus.complete:
        return const Icon(Icons.download_done);
      case DownloadTaskStatus.failed:
        return const Icon(Icons.refresh);
      case DownloadTaskStatus.canceled:
        return const Icon(Icons.cancel);
      case DownloadTaskStatus.paused:
        return const Icon(Icons.play_arrow);
    }
  }
}

class DownloadStatusIndicator extends StatelessWidget {
  const DownloadStatusIndicator({super.key, required this.modelId});
  final String modelId;
  @override
  Widget build(BuildContext context) {
    final progressStream = context.read<DownloadBloc>().status(modelId);

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface.withOpacity(.5),
        child: StreamBuilder(
          stream: progressStream,
          initialData: DownloadTaskStatus.undefined,
          builder: (context, snapshot) {
            return Center(child: snapshot.data?.icon);
          },
        ),
      ),
    );
  }
}

extension on DownloadTaskStatus {
  Widget statWidget(String text) {
    switch (this) {
      case DownloadTaskStatus.undefined:
        return Text(text, overflow: TextOverflow.ellipsis, maxLines: 1);
      case DownloadTaskStatus.enqueued:
        return const Text("Waiting...");
      case DownloadTaskStatus.running:
        return const Text("Downloading...");
      case DownloadTaskStatus.complete:
        return Row(children: [
          const Icon(
            Icons.check_circle,
            size: 16,
          ),
          const SizedBox(width: 4),
          Expanded(
              child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ))
        ]);
      case DownloadTaskStatus.failed:
        return Row(children: [
          const Icon(
            Icons.dangerous,
            size: 16,
          ),
          const SizedBox(width: 4),
          Expanded(
              child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ))
        ]);
      case DownloadTaskStatus.canceled:
        return Row(children: [
          const Icon(
            Icons.cancel,
            size: 16,
          ),
          const SizedBox(width: 4),
          Expanded(
              child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ))
        ]);
      case DownloadTaskStatus.paused:
        return Row(children: [
          const Icon(
            Icons.pause_rounded,
            size: 16,
          ),
          const SizedBox(width: 4),
          Expanded(
              child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ))
        ]);
    }
  }
}

class SubTitleAndStatus extends StatelessWidget {
  const SubTitleAndStatus(
      {super.key, required this.modelId, required this.text});
  final String modelId;
  final String text;
  @override
  Widget build(BuildContext context) {
    final progressStream = context.read<DownloadBloc>().status(modelId);

    return StreamBuilder(
      stream: progressStream,
      initialData: DownloadTaskStatus.undefined,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return snapshot.data!.statWidget(text);
        }
        return Text(text, overflow: TextOverflow.ellipsis, maxLines: 1);
      },
    );
  }
}

class DownloadTaskIndicator extends StatelessWidget {
  const DownloadTaskIndicator({super.key, required this.modelId});
  final String modelId;
  @override
  Widget build(BuildContext context) {
    final taskStream = context.read<DownloadBloc>().task(modelId);

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface.withOpacity(.5),
        child: StreamBuilder(
          stream: taskStream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  snapshot.data!.status.icon,
                  CircularProgressIndicator(
                    value: snapshot.data!.status == DownloadTaskStatus.running
                        ? snapshot.data!.progress / 100
                        : 0,
                    strokeWidth: 2,
                  )
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
