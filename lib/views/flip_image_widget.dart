import 'package:assentify_demo_app/views/network_image_with_headers.dart';
import 'package:flutter/material.dart';

class FlipImageWidget extends StatefulWidget {
  final List<String> images;

  const FlipImageWidget({
    super.key,
    required this.images,
  });

  @override
  State<FlipImageWidget> createState() => _FlipImageWidgetState();
}

class _FlipImageWidgetState extends State<FlipImageWidget>
    with SingleTickerProviderStateMixin {
  bool _isFront = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final isUnder = _animation.value > 0.5;
              final value = isUnder ? 1 - _animation.value : _animation.value;
              final double transformValue = isUnder ? 3.1415927 : 0;

              return ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(value * 3.1415927)
                    ..rotateY(transformValue),
                  child: widget.images.length > 1
                      ? isUnder
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(3.1415927),
                              child: ImageWithHeaders(
                                  imageUrl: widget.images.last),
                            )
                          : ImageWithHeaders(imageUrl: widget.images.first)
                      : ImageWithHeaders(
                          imageUrl: widget.images.first,
                          fit: BoxFit.cover,
                        ),
                ),
              );
            },
          ),
        ),
        if (widget.images.length > 1)
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: _flipCard,
              child: Container(
                height: 43,
                width: 43,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11)),
                child: const Icon(Icons.flip),
              ),
            ),
          )
      ],
    );
  }
}
