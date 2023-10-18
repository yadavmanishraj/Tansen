import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../home.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});
  static const route = "/";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(GetIt.instance.get()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.homeStatus == HomeStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                const Expanded(child: const Text("No connection")),
                TextButton(onPressed: () {}, child: Text("Refresh"))
              ],
            ),
          ));
        }
      },
      builder: (context, state) {
        if (state.homeStatus == HomeStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.homeStatus == HomeStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 100,
                  color: colorScheme.error,
                ),
                FilledButton.icon(
                    style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.error),
                    onPressed: () {},
                    icon: Icon(Icons.refresh),
                    label: Text("Refresh"))
              ],
            ),
          );
        } else {
          final data = state.data?.entries.elementAt(0).value;
          return ListView.builder(
            itemCount: data?.length ?? 0,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  child: CachedNetworkImage(
                    imageUrl: data
                            ?.elementAt(index)
                            .image
                            ?.replaceAll("150x150", "500x500") ??
                        "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
