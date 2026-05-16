import 'package:flutter/material.dart';
import 'package:nutui_flutter/theme/colors.dart';

class NutEmpty extends StatelessWidget {
  // 自定义图片 Widget (优先级高于 imageSize 和默认图)
  final Widget? image;

  // 图片大小（仅在使用默认图时生效）
  final double imageSize;

  // 描述文字
  final String? description;

  // 描述文字样式
  final TextStyle? descriptionStyle;

  // 底部操作区（通常放置按钮）
  final Widget? child;

  const NutEmpty({
    super.key,
    this.image,
    this.imageSize = 160,
    this.description,
    this.descriptionStyle,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 图片区域
          _buildImage(),
          const SizedBox(height: 16),

          // 描述文字
          _buildDescription(),
          const SizedBox(height: 16),

          // 底部插槽
          ?child,
        ],
      ),
    );
  }

  // 构建图片区域
  Widget _buildImage() {
    if (image != null) {
      // 传入了自定义 Widget,直接使用
      return image!;
    }

    // 没有传入自定义图片，使用极简 Icon 模拟默认空状态插画
    return SizedBox(
      width: imageSize,
      height: imageSize,
      child: CustomPaint(
        painter: _DefaultEmptyPainter(
          color: NutUIColors.disabledText.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  // 构建描述文字
  Widget _buildDescription() {
    if (description == null || description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      description!,
      style: descriptionStyle ??
        const TextStyle(
          fontSize: 14,
          color: NutUIColors.textSecondary,
          height: 1.5,
        ),
      textAlign: TextAlign.center,
    );
  }
}

// 默认空状态绘图 (模拟 NutUI 的简约缺省图)
class _DefaultEmptyPainter extends CustomPainter {
  final Color color;

  _DefaultEmptyPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(center: center, width: size.width * 0.5, height: size.height * 0.45);

    // 绘制盒子外框
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), paint);

    // 绘制把手
    final handleRect = Rect.fromCenter(center: Offset(center.dx, rect.top), width: size.width * 0.15, height: 10);
    canvas.drawRRect(RRect.fromRectAndRadius(handleRect, const Radius.circular(4)), paint);

    // 绘制装饰线 (模拟文件/内容)
    final lineStart = rect.left + rect.width * 0.25;
    final lineEnd = rect.right - rect.width * 0.25;
    final lineY1 = rect.top + rect.height * 0.35;
    final lineY2 = rect.top + rect.height * 0.55;
    final lineY3 = rect.top + rect.height * 0.75;

    canvas.drawLine(Offset(lineStart, lineY1), Offset(lineEnd, lineY1), paint..strokeWidth = 1.5);
    canvas.drawLine(Offset(lineStart, lineY2), Offset(lineEnd * 0.9, lineY2), paint);
    canvas.drawLine(Offset(lineStart, lineY3), Offset(lineEnd * 0.8, lineY3), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}