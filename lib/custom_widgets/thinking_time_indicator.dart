import 'package:flutter/material.dart';

class ThinkingTimeIndicator extends StatefulWidget {
  final int totalAnimationDuration;
  final double? width;
  final double? height;
  final Function() onEnd;

  const ThinkingTimeIndicator({
    Key? key,
    required this.totalAnimationDuration,
    required this.onEnd,
    this.width = 0,
    this.height,
  }) : super(key: key);

  @override
  State<ThinkingTimeIndicator> createState() => _ThinkingTimeIndicatorState();
}

class _ThinkingTimeIndicatorState extends State<ThinkingTimeIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: widget.totalAnimationDuration),
      width: widget.width,
      color: Theme.of(context).colorScheme.primaryContainer,
      height: widget.height,
      onEnd: widget.onEnd,
    );
  }
}
