import 'package:flutter/material.dart';
import 'dart:async';

class ColorPickerHSV extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerHSV({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  State<ColorPickerHSV> createState() => _ColorPickerHSVState();
}

class _ColorPickerHSVState extends State<ColorPickerHSV> {
  late ValueNotifier<HSVColor> _hsvNotifier;
  final double _panelWidth = 280.0;
  final double _panelHeight = 180.0;
  final double _hueHeight = 30.0;

  @override
  void initState() {
    super.initState();
    Color startColor = widget.initialColor.withOpacity(1.0);
    HSVColor hsv = HSVColor.fromColor(startColor);

    if (hsv.value < 0.05 && hsv.saturation < 0.05) {
      hsv = HSVColor.fromAHSV(1.0, hsv.hue, 0.5, 0.5);
    }

    _hsvNotifier = ValueNotifier(hsv);
    _hsvNotifier.addListener(_notifyParent);
  }

  @override
  void dispose() {
    _hsvNotifier.removeListener(_notifyParent);
    _hsvNotifier.dispose();
    super.dispose();
  }

  void _notifyParent() {
    final color = _hsvNotifier.value.toColor();
    scheduleMicrotask(() {
      if (mounted) {
        widget.onColorChanged(color);
      }
    });
  }

  void _updateFromPanel(Offset localPosition) {
    double s = (localPosition.dx / _panelWidth).clamp(0.0, 1.0);
    double v = 1.0 - (localPosition.dy / _panelHeight).clamp(0.0, 1.0);
    _hsvNotifier.value = _hsvNotifier.value.withSaturation(s).withValue(v);
  }

  void _updateFromHue(Offset localPosition) {
    double h = (localPosition.dx / _panelWidth).clamp(0.0, 1.0) * 360.0;
    _hsvNotifier.value = _hsvNotifier.value.withHue(h);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Listener(
          onPointerDown: (e) => _updateFromPanel(e.localPosition),
          onPointerMove: (e) => _updateFromPanel(e.localPosition),
          child: SizedBox(
            width: _panelWidth,
            height: _panelHeight,
            child: ValueListenableBuilder<HSVColor>(
              valueListenable: _hsvNotifier,
              builder: (context, hsv, _) {
                return CustomPaint(painter: _SVPainter(hsv));
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Listener(
          onPointerDown: (e) => _updateFromHue(e.localPosition),
          onPointerMove: (e) => _updateFromHue(e.localPosition),
          child: SizedBox(
            width: _panelWidth,
            height: _hueHeight,
            child: ValueListenableBuilder<HSVColor>(
              valueListenable: _hsvNotifier,
              builder: (context, hsv, _) {
                return CustomPaint(painter: _HuePainter(hsv.hue));
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SVPainter extends CustomPainter {
  final HSVColor hsv;
  _SVPainter(this.hsv);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white,
          HSVColor.fromAHSV(1.0, hsv.hue, 1.0, 1.0).toColor(),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    final blackPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black],
      ).createShader(rect);
    canvas.drawRect(rect, blackPaint);

    final cursorOffset = Offset(
      hsv.saturation * size.width,
      (1.0 - hsv.value) * size.height,
    );
    canvas.drawCircle(
      cursorOffset,
      12.0,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );
    canvas.drawCircle(cursorOffset, 8.0, Paint()..color = hsv.toColor());
  }

  @override
  bool shouldRepaint(_SVPainter old) => hsv != old.hsv;
}

class _HuePainter extends CustomPainter {
  final double hue;
  _HuePainter(this.hue);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const List<Color> colors = [
      Color(0xFFFF0000),
      Color(0xFFFFFF00),
      Color(0xFF00FF00),
      Color(0xFF00FFFF),
      Color(0xFF0000FF),
      Color(0xFFFF00FF),
      Color(0xFFFF0000),
    ];

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      Paint()..shader = const LinearGradient(colors: colors).createShader(rect),
    );

    final x = (hue / 360.0) * size.width;
    canvas.drawCircle(
      Offset(x, size.height / 2),
      14.0,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );
  }

  @override
  bool shouldRepaint(_HuePainter old) => hue != old.hue;
}
