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

The Dynamic Carousel Indicator is a Flutter widget package that provides an interactive indicator for dynamic carousels. It offers customization options for dot size, spacing, color, and animation, enhancing the user experience when navigating through a carousel of items.


![example gif](carousel_dots.gif)

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

