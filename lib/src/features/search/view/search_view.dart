import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/src/widgets/art_display.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  static const route = "/search";

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future? data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextField(
        onChanged: (value) {
          setState(() {
            data = GetIt.instance.get<MusicRepository>().search(value);
          });
        },
      )),
      body: FutureBuilder(
        future: data,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final drm = snapshot.data![index];

                  return ArtContainer(models: drm.value.data, title: drm.key);
                });
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView({super.key, required this.data});
  final List<BaseModel> data;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => ListTile(
        leading:
            CircleAvatar(foregroundImage: NetworkImage(data[index].image!)),
        title: Text(data[index].title!),
        subtitle: Text(data[index].subText),
      ),
    );
  }
}
