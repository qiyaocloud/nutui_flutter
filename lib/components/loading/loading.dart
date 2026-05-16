import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/colors.dart';

// 排序方向
enum NutLoadingDirection {
  vertical,
  horizontal,
}

class NutLoadingView extends StatefulWidget {
  // 提示文字
  final String? text;

  // 颜色
  final Color color;

  // 图标大小
  final double size;

  // 文字大小
  final double textSize;

  // 排序方向
  final NutLoadingDirection direction;

  // 自定义图标（替换默认菊花）
  final Widget? icon;

  const NutLoadingView({
    super.key,
    this.text,
    this.color = NutUIColors.textSecondary,
    this.size = 30,
    this.textSize = 14,
    this.direction = NutLoadingDirection.vertical,
    this.icon,
  });

  @override
  State<NutLoadingView> createState() => _NutLoadingViewState();
}

class _NutLoadingViewState extends State<NutLoadingView>
  with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentIcon = widget.icon ??
      RotationTransition(
        turns: _controller,
        child: CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _SpinningPainter(color: widget.color),
        ),
      );

    List<Widget> children = [
      currentIcon,
      if (widget.text != null && widget.text!.isNotEmpty)
        Padding(
          padding: EdgeInsets.only(
            top: widget.direction == NutLoadingDirection.vertical ? 12 : 0,
            left: widget.direction == NutLoadingDirection.horizontal ? 12 : 0,
          ),
          child: Text(
            widget.text!,
            style: TextStyle(
              fontSize: widget.textSize,
              color: widget.color,
            ),
          ),
        ),
    ];

    return widget.direction == NutLoadingDirection.vertical
        ? Column(mainAxisSize: MainAxisSize.min, children: children)
        : Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}

// 默认菊花圆点绘制器
class _SpinningPainter extends CustomPainter {
  final Color color;

  _SpinningPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2 * 0.8; // 圆点轨迹半径
    final double dotRadius = size.width / 12; // 每个圆点的半径

    // 画 12 个点，透明度递增
    for (int i = 0; i < 12; i++) {
      final double angle = (i * 30.0) * 3.14159265 / 180.0;
      final double x = centerX + radius * math.sin(angle);
      final double y = centerY - radius * math.cos(angle);

      // 透明度从 0.1 到 1.0 递增，形成拖尾效果
      final double opacity = (i + 1) / 12.0;
      paint.color = color.withValues(alpha: opacity.clamp(0.0, 1.0));

      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 局部加载包裹组件
class NutLoadingOverlay extends StatelessWidget {
  final bool loading;
  final Widget child;
  final String? text;
  final Color color;
  final Color overlayColor;

  const NutLoadingOverlay({
    super.key,
    required this.loading,
    required this.child,
    this.text,
    this.color = NutUIColors.white,
    this.overlayColor = NutUIColors.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading)
          Positioned.fill(
            child: Container(
              color: overlayColor,
              alignment: Alignment.center,
              child: NutLoadingView(
                text: text,
                color: color,
                icon: const SizedBox(),
              ),
            ),
          ),
      ],
    );
  }
}

// 全局 Loading 管理器
class NutLoading {
  static final _LoadingManager _manager = _LoadingManager();

  // 显示全局 Loading
  static void show(
      BuildContext context, {
        String text = '加载中...',
        Color color = NutUIColors.white,
        bool forbidClick = true,
  }) {
    _manager.show(context, text: text, color: color, forbidClick: forbidClick);
  }

  // 关闭全局 Loading
  static void close() {
    _manager.close();
  }
}

class _LoadingManager {
  OverlayEntry? _overlayEntry;

  void show(
      BuildContext context, {
      required String text,
      required Color color,
      required bool forbidClick,
  }) {
    _closeImmediately();

    final overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return IgnorePointer(
          ignoring: !forbidClick,
          child: Container(
            alignment: Alignment.center,
            color: forbidClick ? Colors.black26 : Colors.transparent,
            child: NutLoadingView(text: text, color: color),
          ),
        );
      }
    );

    overlayState.insert(_overlayEntry!);
  }

  void close() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  void _closeImmediately() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry!.remove();
      } catch (_) {
        // Already removed — safe to ignore.
      }
      _overlayEntry = null;
    }
  }
}