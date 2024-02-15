import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/src/features/home/home.dart';
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
      body: Column(
        children: [
          const SearchCategoryBar(),
          Expanded(
            child: FutureBuilder(
              future: data,
              initialData: null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final drm = snapshot.data![index];

                        return ArtContainer(
                            models: drm.value.data, title: drm.key);
                      });
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView({required this.data});
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

class SearchCategoryBar extends StatelessWidget {
  const SearchCategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: ThemedIcon(
                avatar: Icons.music_note_outlined,
                label: "Songs",
                // selected: true,
              ),
            ),
            ThemedIcon(
              avatar: Icons.person_outline,
              label: "Artists",
            ),
            ThemedIcon(
              avatar: Icons.album_outlined,
              label: "Albums",
            ),
            ThemedIcon(
              avatar: Icons.featured_play_list_outlined,
              label: "Playlists",
            ),
            ThemedIcon(
              avatar: Icons.podcasts_sharp,
              label: "Podcasts",
            ),
            ThemedIcon(
              avatar: Icons.bolt_outlined,
              label: "Audiobooks",
            ),
            ThemedIcon(
              avatar: Icons.auto_awesome_motion,
              label: "Party",
            ),
            ThemedIcon(
              avatar: Icons.pie_chart_outline_rounded,
              label: "Romance",
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: ThemedIcon(
                  avatar: Icons.workspaces_outlined, label: "Workout"),
            )
          ],
        ),
      ),
    );
  }
}
