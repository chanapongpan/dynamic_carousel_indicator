import 'dart:math';

import 'package:flutter/material.dart';

enum ScrollDirection { initial, left, right }

enum ScrollRangeDirection { initial, left, right }

class DynamicCarouselIndicator extends StatefulWidget {
  /// The current index of the page in the dynamic carousel.
  final int pageIndex;

  /// The total number of pages in the carousel.
  final int count;

  /// The width of each indicator dot. Default is 8.0.
  final double dotWidth;

  /// The height of each indicator dot. Default is 8.0.
  final double dotHeight;

  /// The radius of each indicator dot. Default is 8.0.
  final double dotRadius;

  /// The spacing between indicator dots. Default is 6.0.
  final double spacing;

  /// The scale factor applied to the active dot. Default is 1.0.
  final double activeDotScale;

  /// The scale factor applied to the first visible dot. Default is 0.375.
  final double firstVisibleDotScale;

  /// The scale factor applied to the second visible dot. Default is 0.75.
  final double secondVisibleDotScale;

  /// The style used for painting the indicator dots (fill or stroke). Default is PaintingStyle.fill.
  final PaintingStyle paintStyle;

  /// The color of the inactive indicator dots. Default is Colors.grey.
  final Color dotColor;

  /// The color of the active indicator dot. Default is Colors.blue.
  final Color activeDotColor;

  /// Creates a DynamicCarouselIndicator widget.
  ///
  /// [pageIndex] is the current index of the page.
  /// [count] is the total number of pages.
  /// The other parameters have default values for customization.
  const DynamicCarouselIndicator({
    super.key,
    required this.pageIndex,
    required this.count,
    this.dotWidth = 8.0,
    this.dotHeight = 8.0,
    this.dotRadius = 8.0,
    this.spacing = 6,
    this.activeDotScale = 1.0,
    this.firstVisibleDotScale = 0.375,
    this.secondVisibleDotScale = 0.75,
    this.paintStyle = PaintingStyle.fill,
    this.dotColor = Colors.grey,
    this.activeDotColor = Colors.blue,
  });

  @override
  State<DynamicCarouselIndicator> createState() =>
      _DynamicCarouselIndicatorState();
}

class _DynamicCarouselIndicatorState extends State<DynamicCarouselIndicator>
    with SingleTickerProviderStateMixin {
  late final PageController pageController;
  late final AnimationController animationController;
  late Animation<double> animation;
  late ScrollRangeDirection scrollRangeDirection = ScrollRangeDirection.initial;
  late ScrollDirection scrollDirection = ScrollDirection.initial;
  final Duration animateDuration = const Duration(milliseconds: 100);

  int currentPage = 0;
  int previousePage = 0;
  int dotRangeIndex = 0;
  int previousDotRangeIndex = 0;

  @override
  void initState() {
    animationController =
        AnimationController(duration: animateDuration, vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DynamicCarouselIndicator oldWidget) {
    onPageChaned(widget.pageIndex);
    super.didUpdateWidget(oldWidget);
  }

  void onPageChaned(int value) {
    scrollRangeDirection = ScrollRangeDirection.initial;
    scrollDirection = ScrollDirection.initial;

    if (value > currentPage) {
      scrollDirection = ScrollDirection.right;
    } else if ((value < currentPage)) {
      scrollDirection = ScrollDirection.left;
    }

    double begin = 0;
    double end = 0;
    animationController.reset();
    if (value > currentPage) {
      begin = currentPage.toDouble();
      end = value.toDouble();
    } else if (value < currentPage) {
      begin = currentPage.toDouble();
      end = value.toDouble();
    }

    animation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(animationController);
    animationController.forward();

    previousePage = currentPage;
    currentPage = value;
    previousDotRangeIndex = dotRangeIndex;
    dotRangeIndex = dotRangeIndex + currentPage - previousePage;

    if (dotRangeIndex > 2) {
      dotRangeIndex = 2;
    } else if (dotRangeIndex < 0) {
      dotRangeIndex = 0;
    }

    if (dotRangeIndex == previousDotRangeIndex && currentPage > previousePage) {
      scrollRangeDirection = ScrollRangeDirection.right;
    } else if (dotRangeIndex == previousDotRangeIndex &&
        currentPage < previousePage) {
      scrollRangeDirection = ScrollRangeDirection.left;
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.count <= 1) {
      return const SizedBox.shrink();
    }
    return CarouselIndicator(
      count: widget.count,
      currentPage: currentPage,
      previousePage: previousePage,
      dotRangeIndex: dotRangeIndex,
      scrollRangeDirection: scrollRangeDirection,
      scrollDirection: scrollDirection,
      animation: animation,
      effect: ScrollingDotsEffect(
        dotWidth: widget.dotWidth,
        dotHeight: widget.dotHeight,
        spacing: widget.spacing,
        dotRadius: widget.dotRadius,
        activeDotScale: widget.activeDotScale,
        firstVisibleDotScale: widget.firstVisibleDotScale,
        secondVisibleDotScale: widget.secondVisibleDotScale,
        paintStyle: widget.paintStyle,
        dotColor: widget.dotColor,
        activeDotColor: widget.activeDotColor,
      ),
    );
  }
}

class CarouselIndicator extends StatelessWidget {
  final int count;
  final int currentPage;
  final int previousePage;
  final int dotRangeIndex;

  final ScrollRangeDirection scrollRangeDirection;
  final ScrollDirection scrollDirection;
  final Animation<double> animation;
  final ScrollingDotsEffect effect;

  static int fixedSize = 5;
  static int visibleDots = 3;
  static int maxVisibleDots = 7;

  const CarouselIndicator({
    super.key,
    required this.count,
    required this.currentPage,
    required this.previousePage,
    required this.dotRangeIndex,
    required this.scrollRangeDirection,
    required this.scrollDirection,
    required this.animation,
    required this.effect,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 1) {
      return const SizedBox.shrink();
    }
    var size = caculateSize();
    return AnimatedContainer(
      duration: const Duration(seconds: 300),
      width: size.width,
      height: size.height,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return CustomPaint(
            painter: ScrollingDotsPainter(
              currentPage: currentPage,
              previousePage: previousePage,
              dotRangeIndex: dotRangeIndex,
              count: count,
              offset: animation.value,
              scrollRangeDirection: scrollRangeDirection,
              scrollDirection: scrollDirection,
              effect: effect,
            ),
          );
        },
      ),
    );
  }

  Size caculateSize() {
    int visibleDots = count <= fixedSize ? count : maxVisibleDots;
    final width = (effect.dotWidth + effect.spacing) * visibleDots;
    final height = effect.dotHeight;
    return Size(width, height);
  }
}

class ScrollingDotsEffect {
  final double dotWidth;
  final double dotHeight;
  final double dotRadius;
  final double spacing;
  final double activeDotScale;
  final double firstVisibleDotScale;
  final double secondVisibleDotScale;
  final PaintingStyle paintStyle;
  final Color dotColor;
  final Color activeDotColor;

  const ScrollingDotsEffect({
    required this.dotWidth,
    required this.dotHeight,
    required this.spacing,
    required this.dotRadius,
    required this.activeDotScale,
    required this.firstVisibleDotScale,
    required this.secondVisibleDotScale,
    required this.paintStyle,
    required this.dotColor,
    required this.activeDotColor,
  });

  double distance() {
    return dotWidth + spacing;
  }
}

class ScrollingDotsPainter extends CustomPainter {
  final int currentPage;
  final int previousePage;
  final int dotRangeIndex;
  final int count;
  final double offset;
  final ScrollRangeDirection scrollRangeDirection;
  final ScrollDirection scrollDirection;
  final ScrollingDotsEffect effect;

  ScrollingDotsPainter({
    required this.currentPage,
    required this.previousePage,
    required this.dotRangeIndex,
    required this.count,
    required this.offset,
    required this.scrollDirection,
    required this.scrollRangeDirection,
    required this.effect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()..style = effect.paintStyle;
    final dotOffset = offset - offset.toInt();
    final reverseDotOffset = (1 - dotOffset) - (1 - dotOffset).floor();
    final dotDistance = effect.distance();

    if (count <= CarouselIndicator.fixedSize) {
      paintDotsWithinFixedSize(
          canvas, dotPaint, size, dotDistance, dotOffset, reverseDotOffset);
    } else {
      paintDotsWithScrollingEffect(
          canvas, dotPaint, size, dotDistance, dotOffset, reverseDotOffset);
    }
  }

  void draw(
    Canvas canvas,
    Paint dotPaint,
    Size size,
    Color color,
    int index,
    double dotDistance,
    double drawingAnchor,
    double scale,
  ) {
    final scaledWidth = (effect.dotWidth * scale);
    final scaledHeight = effect.dotHeight * scale;
    final yPos = size.height / 2;
    double xPos = effect.dotWidth / 2 + drawingAnchor + (index * dotDistance);

    final rRect = RRect.fromLTRBR(
      xPos - scaledWidth / 2 + effect.spacing / 2,
      yPos - scaledHeight / 2,
      xPos + scaledWidth / 2 + effect.spacing / 2,
      yPos + scaledHeight / 2,
      Radius.circular(effect.dotRadius * scale),
    );

    canvas.drawRRect(rRect, dotPaint..color = color);
  }

  void paintDotsWithinFixedSize(
    Canvas canvas,
    Paint dotPaint,
    Size size,
    double dotDistance,
    double dotOffset,
    double reverseDotOffset,
  ) {
    for (var index = 0; index < count; index++) {
      var color = effect.dotColor;
      if (index == currentPage) {
        color = effect.activeDotColor;
      }
      var scale = 1.0;
      if (index == currentPage) {
        scale = 1 + (effect.activeDotScale - 1);
      }
      draw(canvas, dotPaint, size, color, index, dotDistance, 0, scale);
    }
  }

  void paintDotsWithScrollingEffect(
    Canvas canvas,
    Paint dotPaint,
    Size size,
    double dotDistance,
    double dotOffset,
    double reverseDotOffset,
  ) {
    bool scrollRangeRight = scrollRangeDirection == ScrollRangeDirection.right;
    bool scrollRangeLeft = scrollRangeDirection == ScrollRangeDirection.left;
    bool inPreRange = currentPage < CarouselIndicator.visibleDots;
    bool inAfterRange = currentPage > count - 1 - CarouselIndicator.visibleDots;
    bool animateRight = false;
    bool animateLeft = false;

    int firstIndex = max(currentPage - dotRangeIndex, 0);
    int lastIndex =
        firstIndex + (min(count, CarouselIndicator.visibleDots) - 1);
    int midIndex = ((lastIndex + firstIndex) ~/ 2).toInt();

    double firstVisibleDotScale = effect.firstVisibleDotScale;
    double secondVisibleDotScale = effect.secondVisibleDotScale;
    double distanceOffset =
        (dotDistance * CarouselIndicator.maxVisibleDots - dotDistance) / 2 -
            midIndex * dotDistance;
    double drawingAnchor = 0;

    if (scrollRangeRight && !inPreRange) {
      drawingAnchor = distanceOffset - (dotDistance * dotOffset);
      animateRight = true;
    } else if (scrollRangeLeft && !inAfterRange) {
      drawingAnchor = distanceOffset + (dotDistance * reverseDotOffset);
      animateLeft = true;
    } else {
      drawingAnchor = distanceOffset;
    }

    for (var index = 0; index < count; index++) {
      var scale = 0.0;
      var color = effect.dotColor;
      if (index == currentPage) {
        color = effect.activeDotColor;
      }

      if (index == currentPage) {
        scale = 1 + (effect.activeDotScale - 1);
      } else if (index > firstIndex && index < lastIndex) {
        scale = 1;
      } else if (index == firstIndex) {
        scale = 1;

        if (animateRight) {
          scale = 1 - ((1 - effect.secondVisibleDotScale) * dotOffset);
        }
      } else if (index == lastIndex) {
        scale = 1;

        if (animateLeft) {
          scale = 1 - ((1 - secondVisibleDotScale) * reverseDotOffset);
        }
      } else if (index == firstIndex - 1) {
        scale = secondVisibleDotScale;

        if (animateRight) {
          if (firstIndex == 1 && dotOffset > 0) {
            scale = 0;
          } else {
            scale = secondVisibleDotScale -
                (dotOffset * (secondVisibleDotScale - firstVisibleDotScale));
          }
        } else if (animateLeft) {
          scale = secondVisibleDotScale +
              ((1 - secondVisibleDotScale) * reverseDotOffset);
        }
      } else if (index == firstIndex - 2) {
        scale = firstVisibleDotScale;

        if (animateRight) {
          if (firstIndex == 1 && dotOffset > 0) {
            scale = 0;
          } else {
            scale = firstVisibleDotScale * (1 - dotOffset);
          }
        } else if (animateLeft) {
          scale = firstVisibleDotScale +
              ((secondVisibleDotScale - firstVisibleDotScale) *
                  reverseDotOffset);
        }
      } else if (index == firstIndex - 3) {
        if (animateLeft) {
          scale = firstVisibleDotScale * reverseDotOffset;
        }
      } else if (index == lastIndex + 1) {
        scale = secondVisibleDotScale;

        if (animateRight) {
          scale =
              secondVisibleDotScale + ((1 - secondVisibleDotScale) * dotOffset);
        } else if (animateLeft) {
          if (lastIndex == count - 2 && reverseDotOffset > 0) {
            scale = 0;
          } else {
            scale = secondVisibleDotScale -
                (reverseDotOffset *
                    (secondVisibleDotScale - firstVisibleDotScale));
          }
        }
      } else if (index == lastIndex + 2) {
        scale = firstVisibleDotScale;

        if (animateRight) {
          scale = firstVisibleDotScale +
              ((secondVisibleDotScale - firstVisibleDotScale) * dotOffset);
        } else if (animateLeft) {
          if (lastIndex == count - 2 && reverseDotOffset > 0) {
            scale = 0;
          } else {
            scale = firstVisibleDotScale * (1 - reverseDotOffset);
          }
        }
      } else if (index == lastIndex + 3) {
        if (animateRight) {
          scale = firstVisibleDotScale * dotOffset;
        }
      } else if (index < firstIndex - 2 || index > lastIndex + 2) {
        scale = 0;
      }

      draw(canvas, dotPaint, size, color, index, dotDistance, drawingAnchor,
          scale);
    }
  }

  @override
  bool shouldRepaint(covariant ScrollingDotsPainter oldDelegate) {
    return offset != oldDelegate.offset;
  }
}
