import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/src/widgets/basics.dart';

showContextDialog(BuildContext context, BaseModel model) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
    // backgroundColor: Colors.transparent,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(left: 16, right: 8),
          leading: SizedBox(
            height: 48,
            child: RoundedBox(
              child: CachedNetworkImage(
                imageUrl: model.veryHigh!,
              ),
            ),
          ),
          title: Text(
            model.title ?? "Not Avialable",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            model.subText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.pink,
            ),
            onPressed: () {},
          ),
        ),
        const Divider(
          indent: 0,
          height: 0,
          endIndent: 0,
        ),
        // Material(
        //   color: Colors.transparent,
        //   shadowColor: Colors.transparent,
        //   surfaceTintColor: Colors.transparent,
        //   child: ListTile(
        //     onTap: () {},
        //     leading: Icon(Icons.shuffle),
        //     title: Text("Shuffle Play"),
        //   ),
        // ),
        Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: ListTile(
            onTap: () {},
            leading: Icon(Icons.playlist_play),
            title: Text("Play next"),
          ),
        ),
        Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: ListTile(
            onTap: () {},
            leading: Icon(Icons.queue_music),
            title: Text("Add to queue"),
          ),
        ),
        Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: ListTile(
            onTap: () {},
            leading: Icon(Icons.library_add_outlined),
            title: Text("Save to library"),
          ),
        ),
        Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: ListTile(
            onTap: () {},
            leading: Icon(Icons.file_download_outlined),
            title: Text(
              "Download",
            ),
            trailing: PremiumChip(),
          ),
        ),
        Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: ListTile(
            onTap: () {},
            leading: Icon(Icons.playlist_add),
            title: Text("Save to playlist"),
          ),
        ),
        Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: ListTile(
            onTap: () {},
            leading: Icon(Icons.album_outlined),
            title: Text("Go to album"),
          ),
        ),
        Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: ListTile(
            onTap: () {},
            leading: Icon(Icons.person_outline),
            title: Text("Go to artist"),
          ),
        ),
        // Material(
        //   color: Colors.transparent,
        //   shadowColor: Colors.transparent,
        //   surfaceTintColor: Colors.transparent,
        //   child: ListTile(
        //     onTap: () {},
        //     leading: Icon(Icons.bookmark_outline),
        //     title: Text("Save episode for later"),
        //   ),
        // ),
        // Material(
        //   color: Colors.transparent,
        //   shadowColor: Colors.transparent,
        //   surfaceTintColor: Colors.transparent,
        //   child: ListTile(
        //     onTap: () {},
        //     leading: Icon(Icons.info_outline),
        //     title: Text("Go to episode"),
        //   ),
        // ),
        Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: ListTile(
            onTap: () {},
            leading: Icon(Icons.groups_3_outlined),
            title: Text("View song credits"),
          ),
        ),
        Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: ListTile(
            onTap: () {},
            leading: Icon(Icons.share),
            title: Text("Share"),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).viewPadding.bottom,
        )
      ],
    ),
  );
}

class PremiumChip extends StatelessWidget {
  const PremiumChip({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: const LinearGradient(
            colors: [
              Colors.purpleAccent,
              Colors.pink,
              Color.fromRGBO(255, 136, 0, 0.566),
            ],
          )),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SizedBox(height: 16, child: Image.asset("assets/icons/app.png")),
            Icon(
              Icons.workspace_premium_outlined,
              size: 18,
            ),
            SizedBox(width: 2),
            Text(
              "PREMIUM",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.workspace_premium);
  }
}
