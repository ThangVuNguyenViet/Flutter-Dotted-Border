library dotted_border;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

part 'dash_painter.dart';

/// Add a dotted border around any [child] widget. The [strokeWidth] property
/// defines the width of the dashed border and [color] determines the stroke
/// paint color. [CircularIntervalList] is populated with the [dashPattern] to
/// render the appropriate pattern. The [radius] property is taken into account
/// only if the [borderType] is [BorderType.RRect]. A [customPath] can be passed in
/// as a parameter if you want to draw a custom shaped border.
class DottedBorder extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets borderPadding;
  final double strokeWidth;
  final Color color;
  final List<double> dashPattern;
  final BorderType borderType;
  final Radius radius;
  final StrokeCap strokeCap;
  final PathBuilder? customPath;

  DottedBorder({
    super.key,
    required this.child,
    this.color = Colors.black,
    this.strokeWidth = 1,
    this.borderType = BorderType.Rect,
    this.dashPattern = const <double>[3, 1],
    this.padding = const EdgeInsets.all(2),
    this.borderPadding = EdgeInsets.zero,
    this.radius = const Radius.circular(0),
    this.strokeCap = StrokeCap.butt,
    this.customPath,
  }) {
    assert(_isValidDashPattern(dashPattern), 'Invalid dash pattern');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: CustomPaint(
            painter: _DashPainter(
              padding: borderPadding,
              strokeWidth: strokeWidth,
              radius: radius,
              color: color,
              borderType: borderType,
              dashPattern: dashPattern,
              customPath: customPath,
              strokeCap: strokeCap,
            ),
          ),
        ),
        Padding(
          padding: padding,
          child: child,
        ),
      ],
    );
  }
}

/// Refer to [DottedBorder] for usage
class AnimatedDottedBorder extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets borderPadding;
  final double strokeWidth;
  final Color color;
  final List<double> dashPattern;
  final BorderType borderType;
  final Radius radius;
  final StrokeCap strokeCap;
  final PathBuilder? customPath;
  final Animation<double> animation;

  AnimatedDottedBorder({
    super.key,
    required this.child,
    this.color = Colors.black,
    this.strokeWidth = 1,
    this.borderType = BorderType.Rect,
    this.dashPattern = const <double>[3, 1],
    this.padding = const EdgeInsets.all(2),
    this.borderPadding = EdgeInsets.zero,
    this.radius = const Radius.circular(0),
    this.strokeCap = StrokeCap.butt,
    this.customPath,
    required this.animation,
  }) {
    assert(_isValidDashPattern(dashPattern), 'Invalid dash pattern');
  }

  @override
  State<AnimatedDottedBorder> createState() => _AnimatedDottedBorderState();
}

class _AnimatedDottedBorderState extends State<AnimatedDottedBorder> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) => CustomPaint(
              painter: _DashPainter(
                padding: widget.borderPadding,
                strokeWidth: widget.strokeWidth,
                radius: widget.radius,
                color: widget.color,
                borderType: widget.borderType,
                dashPattern: widget.dashPattern,
                customPath: widget.customPath,
                strokeCap: widget.strokeCap,
                animationPercent: widget.animation.value,
              ),
            ),
          ),
        ),
        Padding(
          padding: widget.padding,
          child: widget.child,
        ),
      ],
    );
  }
}

/// Compute if [dashPattern] is valid. The following conditions need to be met
/// * Cannot be null or empty
/// * If [dashPattern] has only 1 element, it cannot be 0
bool _isValidDashPattern(List<double>? dashPattern) {
  Set<double>? _dashSet = dashPattern?.toSet();
  if (_dashSet == null) return false;
  // if (_dashSet.length == 1 && _dashSet.elementAt(0) == 0.0) return false;
  // if (_dashSet.length == 0) return false;
  return true;
}

/// The different supported BorderTypes
enum BorderType { Circle, RRect, Rect, Oval }
