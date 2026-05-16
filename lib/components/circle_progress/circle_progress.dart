import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class NutCircleProgress extends StatefulWidget {
  // 当前进度(0 ~ 100)
  final double percentage;

  // 圆环直径
  final double size;

  // 线条宽度
  final double strokeWidth;

  // 进度条颜色
  final Color color;

  // 轨道颜色
  final Color trackColor;

  // 线条端点样式
  final StrokeCap strokeLinecap;

  // 是否显示文字
  final bool showText;

  // 自定义文字 (如果不传，默认显示百分比)
  final String? text;

  // 文字样式
  final TextStyle? textStyle;

  // 动画时长 (毫秒)，0 表示无动画
  final int animationDuration;

  const NutCircleProgress({
    super.key,
    required this.percentage,
    this.size = 100,
    this.strokeWidth = 4,
    this.color = NutUIColors.primary,
    this.trackColor = NutUIColors.circleProgressTrack,
    this.strokeLinecap = StrokeCap.round,
    this.showText = true,
    this.text,
    this.textStyle,
    this.animationDuration = 500,
  });

  @override
  State<NutCircleProgress> createState() => _NutCircleProgressState();
}

class _NutCircleProgressState extends State<NutCircleProgress>
  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _oldPercentage = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration),
    );

    // 初始动画：从 0 到初始值
    _animation = Tween<double>(begin: 0, end: widget.percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    )..addListener(() => setState(() {}));

    if (widget.animationDuration > 0) {
      _controller.forward();
    }
    _oldPercentage = widget.percentage;
  }

  @override
  void didUpdateWidget(covariant NutCircleProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 当进度值发生改变时，启动过渡动画
    if (oldWidget.percentage != widget.percentage) {
      _animation = Tween<double>(
        begin: _oldPercentage,
        end: widget.percentage,
      ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
      ));

      if (widget.animationDuration > 0) {
        _controller.forward(from: 0.0);
      }
      _oldPercentage = widget.percentage;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 确保进度在 0-100 之间
    double currentProgress = _animation.value.clamp(0.0, 100.0);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 绘制圆环
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _CircleProgressPainter(
              progress: currentProgress,
              strokeWidth: widget.strokeWidth,
              color: widget.color,
              trackColor: widget.trackColor,
              strokeLinecap: widget.strokeLinecap,
            ),
          ),

          // 中间文字
          if (widget.showText)
            Text(
              widget.text ?? '${currentProgress.round()}%',
              style: widget.textStyle ??
                TextStyle(
                  fontSize: widget.size * 0.18, // 默认字体大小随圆环大小自适应
                  fontWeight: FontWeight.bold,
                  color: NutUIColors.text,
                ),
            ),
        ],
      ),
    );
  }
}

// 核心绘制器
class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color trackColor;
  final StrokeCap strokeLinecap;

  _CircleProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
    required this.strokeLinecap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // 计算半径时需要减去线条宽度的一半，防止线条绘制到边界外
    final radius = (size.width - strokeWidth) / 2;

    // 画笔配置
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeLinecap;

    // 绘制背景轨道
    paint.color = trackColor;
    canvas.drawCircle(center, radius, paint);

    // 绘制进度弧线
    if (progress > 0) {
      paint.color = color;

      // 计算扫过的角度
      double sweepAngle = 2 * math.pi * (progress / 100);
      // 从 12 点钟方向开始绘制 (默认 3 点钟方向，所以减去 90 度)
      double startAngle = -math.pi / 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false, // 不连接圆心
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter oldDelegate) {
    // 以下属性发生改变时需要重绘
    return oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.strokeWidth != strokeWidth;
  }
}