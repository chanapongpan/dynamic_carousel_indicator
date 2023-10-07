import 'package:dynamic_carousel_indicator/dynamic_carousel_indicator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

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
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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
          borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
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
