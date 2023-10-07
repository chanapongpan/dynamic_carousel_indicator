<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

The Dynamic Carousel Indicator provides an interactive indicator for dynamic carousels.

![example gif](carousel_dots.gif)


## Author

Chanapongpan Najaikong (Pick) pick.chanapongpan@gmail.com

## Features

- Dynamic dot indicator that adapts to the number of items in the carousel.
- Customizable dot size, spacing, and colors.
- Smooth animations when navigating between carousel items.
- Scalable active and adjacent dot sizes for visual feedback.
- Easy integration into your Flutter app.

## Getting started

To get started, simply install the package, customize the indicator's appearance, and incorporate it into your Flutter app's carousel widget.

## Usage

```dart
 DynamicCarouselIndicator(
    pageIndex: _currentPageIndex,
    count: _totalPages
 )
```

## Example

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Carousel Indicator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Map<int, int> pageIndex = {
    1: 0,
    3: 0,
    5: 0,
    6: 0,
    10: 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildCarousel(1),
            const SizedBox(height: 16),
            _buildCarousel(3),
            const SizedBox(height: 16),
            _buildCarousel(5),
            const SizedBox(height: 16),
            _buildCarousel(6),
            const SizedBox(height: 16),
            _buildCarousel(10),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(int totalPage) {
    var pages = List<Widget>.generate(
      totalPage,
      (i) => Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), 
          color: Colors.grey.withOpacity(0.4),
        ),
        child: Center(
          child: Text('Page ${i + 1}/$totalPage'),
        ),
      ),
    );

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: PageView.builder(
            itemCount: pages.length,
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (context, i) => pages[i],
            onPageChanged: (value) {
              setState(() {
                pageIndex[totalPage] = value;
              });
            },
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        DynamicCarouselIndicator(
          pageIndex: pageIndex[totalPage]!,
          count: pages.length,
        ),
      ],
    );
  }
}

```