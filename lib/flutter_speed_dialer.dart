library flutter_speed_dialer;


import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Button tailored to using with [SpeedDialer].
class SpeedDialerButton extends StatelessWidget {
  IconData icon;
  String text;
  Color foregroundColor;
  Color backgroundColor;
  Function onPressed;
  Object heroTag;

  SpeedDialerButton({this.icon, this.text, this.foregroundColor, this.backgroundColor,
    this.onPressed, this.heroTag});

  @override
  build(BuildContext context) {
    return new FloatingActionButton(
      backgroundColor: backgroundColor,
      mini: true,
      child: new Icon(icon, color: foregroundColor),
      onPressed: onPressed,
      heroTag: heroTag,
    );
  }

}

/// A FAB Speed Dialer that pops out buttons of your choice.
///
/// Consider using [SpeedDialerButton]s for ease of use.
class SpeedDialer extends StatefulWidget {
  /// Buttons that pop out upon tapping the FAB.
  List<Widget> children;
  Object heroTag;
  IconData iconData;

  SpeedDialer({this.heroTag, this.children, this.iconData});

  @override
  State createState() => new SpeedDialerState();
}

class SpeedDialerState extends State<SpeedDialer> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    var children = widget.children ?? [];
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(children.length, (int index) {
        Widget child = new Container(
          padding: EdgeInsets.only(right: 8.0),
          height: 70.0,
          alignment: FractionalOffset.bottomRight,
          child: new ScaleTransition(
            alignment: Alignment.bottomRight,
            scale: new CurvedAnimation(
              parent: _controller,
              curve: new Interval(
                  0.0,
                  1.0 - index / children.length / 2.0,
                  curve: Curves.easeIn
              ),
            ),
            child: children[index],
          ),
        );
        return child;
      }).toList()
      ..add(new Padding(padding: EdgeInsets.only(top: 16.0),))
      ..add(
        // TODO: Support customization of this button.
        new FloatingActionButton(
          heroTag: widget.heroTag,
          child: new AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return new Transform(
                transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.PI),
                alignment: FractionalOffset.center,
                child: new Icon(_controller.isDismissed ? widget.iconData : Icons.close),
              );
            },
          ),
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
        ),
      ),
    );
  }
}
