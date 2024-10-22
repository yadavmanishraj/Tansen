
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:muisc_repository/muisc_repository.dart';
import 'package:tansen/src/features/home/view/context_dialog.dart';
import 'package:tansen/src/widgets/basics.dart';

class ArtDisplay extends StatefulWidget {
  const ArtDisplay({super.key, required this.baseModel});
  final BaseModel baseModel;

  @override
  State<ArtDisplay> createState() => _ArtDisplayState();
}

class _ArtDisplayState extends State<ArtDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  var size = 167.33;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => {
        setState(() {
          size = 150;
        })
      },
      onExit: (event) => {
        setState(() {
          size = 167.33;
        })
      },
      child: AnimatedContainer(
        width: size,
        height: size,
        duration: const Duration(milliseconds: 200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            RoundedBox(
              radius: calculateRadius(),
              child: CachedNetworkImage(
                imageUrl: widget.baseModel.veryHigh!,
                fit: BoxFit.cover,
                placeholder: (context, url) => ColoredBox(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                errorWidget: (context, url, error) => ColoredBox(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: const Center(
                    child: Icon(Icons.error_outline),
                  ),
                ),
              ),
            ),
            // const CircularProgressIndicator(
            //   strokeWidth: 2,
            //   value: .5,
            // ),
            // Icon(
            //   Icons.file_download_outlined,
            //   color: Theme.of(context).colorScheme.primary,
            // ),
          ],
        ),
      ),
    );
  }

  double calculateRadius() {
    if (widget.baseModel.type == "radio_station" ||
        widget.baseModel.type == "artist") {
      return 100;
    }
    return 4;
  }
}

class ArtContainer extends StatelessWidget {
  const ArtContainer({super.key, required this.models, required this.title});
  final List<BaseModel> models;
  final String title;

  bool get isDoubleLaned =>
      models.length > 15 && !models.first.type.contains("radio_station");

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: isDoubleLaned ? 215 * 2 + 16 : 215,
          child: GridView.builder(
            itemCount: models.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDoubleLaned ? 2 : 1,
                childAspectRatio: 215 / 167.33,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16),
            itemBuilder: (context, index) => InkWell(
              onLongPress: () {
                showContextDialog(context, models[index]);
              },
              onTap: () {
                // context.read<MusicPlayerBloc>().add(
                //     MusicPlayerAddEvent(baseModel: models.elementAt(index)));
                context.push("/details",
                    extra: GetIt.instance.get<MusicRepository>().getDetails(
                          models.elementAt(index).type,
                          models.elementAt(index).id!,
                          models.elementAt(index).permaUrl,
                        ));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 167.33,
                    width: 167.33,
                    child: Center(
                      child: ArtDisplay(
                        baseModel: models.elementAt(index),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      models.elementAt(index).title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          height: 1, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      // const Icon(Icons.check_circle,
                      //     size: 16, color: Colors.grey),
                      // SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          models.elementAt(index).subText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(.5)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ViewMoreButton extends StatelessWidget {
  const ViewMoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: () {}, child: const Text("More"));
  }
}
