import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tansen/download/download_bloc.dart';
import 'package:tansen/src/widgets/art_display.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DownloadView(),
        ElevatedButton(
            onPressed: () {
              Logger logger = Logger();
              logger.t("error stack");
            },
            child: Text("Log Me"))
      ],
    );
  }
}

class DownloadView extends StatelessWidget {
  const DownloadView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<DownloadBloc, DownloadState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ArtContainer(models: state.baseModels, title: "Downloads");
          }
        },
      ),
    );
  }
}
