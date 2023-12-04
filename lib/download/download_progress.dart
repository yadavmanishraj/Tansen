import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tansen/download/download_bloc.dart';

class DownloadProgressIndicator extends StatelessWidget {
  const DownloadProgressIndicator({super.key, required this.modelId});
  final String modelId;
  @override
  Widget build(BuildContext context) {
    final progressStream = context.read<DownloadBloc>().progress(modelId);

    return StreamBuilder(
      stream: progressStream,
      initialData: 0,
      builder: (context, snapshot) {
        return CircularProgressIndicator.adaptive(
          value: snapshot.data?.toDouble() ?? 0.0,
        );
      },
    );
  }
}
