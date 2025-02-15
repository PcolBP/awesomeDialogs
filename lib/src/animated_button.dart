import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Function pressEvent;
  final String? text;
  final IconData? icon;
  final double width;
  final bool isFixedHeight;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? buttonTextStyle;

  const AnimatedButton({
    required this.pressEvent,
    this.text,
    this.icon,
    this.color,
    this.isFixedHeight = true,
    this.width = double.infinity,
    this.borderRadius,
    this.buttonTextStyle,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  static const int _forwardDurationNumber = 150;
  late AnimationController _animationController;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _forwardDurationNumber),
      reverseDuration: const Duration(milliseconds: 100),
    )..addStatusListener(
        _animationStatusListener,
      );
    _scale = Tween<double>(
      begin: 1,
      end: 0.9,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() async {
    _animationController.forward();
    //Delayed added in purpose to keep same animation behavior as previous version when dialog was closed while animation was still playing
    await Future.delayed(
      const Duration(milliseconds: _forwardDurationNumber ~/ 2),
    );
    widget.pressEvent();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scale,
        child: _animatedButtonUI,
      ),
    );
  }

  Widget get _animatedButtonUI => Container(
        height: widget.isFixedHeight ? 50.0 : null,
        width: widget.width,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: widget.borderRadius ??
                const BorderRadius.all(
                  Radius.circular(100),
                ),
            color: widget.color ?? Theme.of(context).primaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.icon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                '${widget.text}',
                // maxLines: 1,
                textAlign: TextAlign.center,
                style: widget.buttonTextStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
              ),
            ),
          ],
        ),
      );
}
