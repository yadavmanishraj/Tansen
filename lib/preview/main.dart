import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tansen/src/widgets/basics.dart';
import 'animated.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "Inter", useMaterial3: true, brightness: Brightness.dark),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Animated Gradient Mesh'),
        ),
        body: const AnimatedGradientMesh(),
      ),
    );
  }
}

final images = [
  "0CCF6AFD-FD94-45DC-92A1-1646DA8A3CEC_sk1.jpeg",
  "56C73010-C813-465F-A580-5AA24B9D4E2A_sk1.jpeg",
  "52B52795-FAA5-4255-8CF9-A2E4EEC7A527_sk1.jpeg",
  "40A009F3-4945-4917-B5CC-61398D1FBD0F_sk1.jpeg",
  "37D797DD-A9F2-480D-904F-5F4619C52F62_sk1.jpeg",
  "31DE301C-08B2-4F35-ABD6-006905013AFF_sk1.jpeg",
  "9DDF7FA0-9FAD-44A7-A0CA-B9269F096DF7_sk1.jpeg",
  "9DFD7340-AC5F-4595-BDFE-2D7CC18A9846_sk1.jpeg",
  "21B6F7CC-C7A9-4FB1-9FD6-A85A62E153A3_sk1.jpeg",
  "29D899A1-F490-4EC3-8BD7-A044A92CC665_sk1.jpeg",
  "24DB5BA3-BAF2-416B-BB7B-985290AD0ED5_sk1.jpeg",
  "13A4FE4A-6C5A-4833-AB0D-4EE8312A5C87_sk1.jpeg",
  "7FA7B618-CD84-4E8B-8F40-39AE5F897F2E_sk1.jpeg"
];

extension RandomValue<T> on List<T> {
  T get random {
    final index = Random.secure().nextInt(length);
    return elementAt(index);
  }
}

const imagePath =
    "https://c.saavncdn.com/artists/Gursanj_001_20220311093521_500x500.jpg";

final image = AssetImage("assets/img/${images.random}");

class PreviewApp extends StatelessWidget {
  const PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Foxcon",
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: FutureBuilder<ColorScheme>(
          future: ColorScheme.fromImageProvider(
              brightness: Brightness.dark, provider: image),
          builder: (context, snapshot) {
            return Theme(
                data: Theme.of(context).copyWith(colorScheme: snapshot.data),
                child: const PlaylistDetailsPage());
          }),
    );
  }
}

class PlaylistDetailsPage extends StatelessWidget {
  const PlaylistDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 451,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
          flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Image(
                      image: image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                          // Theme.of(context)
                          //     .colorScheme
                          //     .onPrimary
                          //     .withOpacity(.1),
                          Theme.of(context).colorScheme.surface.withOpacity(.3),
                          // Theme.of(context).colorScheme.surface.withOpacity(.9),
                          // Colors.black.withOpacity(.9),
                          Theme.of(context).colorScheme.surface,
                        ]))),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const Text('Tansen Music'),
                        const Text("Radio"),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(image: image),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Nuevo Neuvo Romance Hits 2023",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Text(
                          "Endless Music Customized for you",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton.filledTonal(
                      style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(.1)),
                      onPressed: () {},
                      icon: const Icon(Icons.file_download_outlined)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton.filledTonal(
                      style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(0.1)),
                      onPressed: () {},
                      icon: const Icon(Icons.library_add_outlined)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.play_arrow,
                        size: 48,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton.filledTonal(
                      style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(.1)),
                      onPressed: () {},
                      icon: const Icon(Icons.ios_share_outlined)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton.filledTonal(
                      style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(.1)),
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert)),
                ),
              ],
            ),
          ),
        ),
        SliverList.builder(
          itemCount: images.length,
          itemBuilder: (context, index) => ListTile(
            leading:
                RoundedBox(child: Image.asset("assets/img/${images[index]}")),
            title: Text(images[index]),
          ),
        )
      ]),
    );
  }
}
