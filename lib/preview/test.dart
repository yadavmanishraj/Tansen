import 'package:flutter/material.dart';

class ScrollStopPageView extends StatefulWidget {
  const ScrollStopPageView({super.key});

  @override
  _ScrollStopPageViewState createState() => _ScrollStopPageViewState();
}

class _ScrollStopPageViewState extends State<ScrollStopPageView> {
  final PageController _pageController = PageController();
  bool _isScrolling = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scroll Stop PageView'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            setState(() {
              _isScrolling = true;
            });
          } else if (notification is ScrollEndNotification) {
            setState(() {
              _isScrolling = false;
            });

            double currentPage = _pageController.page ?? 0;
            int nextPage = (currentPage + 0.5).toInt();
            _pageController.jumpToPage(
              nextPage,
            );
          }
          return true;
        },
        child: PageView(
          controller: _pageController,
          onPageChanged: (int page) {
            if (!_isScrolling) {
              // Handle page change only if not scrolling
              print('Page changed to: $page');
            }
          },
          children: <Widget>[
            Container(color: Colors.blue),
            Container(color: Colors.red),
            Container(color: Colors.green),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ScrollStopPageView(),
  ));
}
