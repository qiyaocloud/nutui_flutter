
// 分割线方向
import 'package:flutter/material.dart';
import 'package:nutui_flutter/theme/colors.dart';

enum NutDividerDirection {
  horizontal,
  vertical,
}

// 文字位置
enum NutDividerContentPosition {
  left,
  center,
  right,
}

class NutDivider extends StatelessWidget {
  // 分割线方向，默认水平
  final NutDividerDirection direction;

  // 文字位置，默认居中
  final NutDividerContentPosition contentPosition;

  // 是否使用虚线
  final bool dashed;

  // 是否使用 0.5px 极细线
  final bool hairline;

  // 文字内容
  final String? text;

  // 自定义子组件(优先级高于 text)
  final Widget? child;

  // 分割线颜色
  final Color? color;

  // 线条粗细 (默认 1.0，hairline 为 true 时为 0.5)
  final double thickness;

  // 文字样式
  final TextStyle? textStyle;

  // 外边距
  final EdgeInsetsGeometry margin;

  // 文字与线条的间距
  final double contentSpacing;

  const NutDivider({
    super.key,
    this.direction = NutDividerDirection.horizontal,
    this.contentPosition = NutDividerContentPosition.center,
    this.dashed = false,
    this.hairline = true, // NutUI 默认极细线
    this.text,
    this.child,
    this.color,
    this.thickness = 1.0,
    this.textStyle,
    this.margin = EdgeInsets.zero,
    this.contentSpacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final isHorizontal = direction == NutDividerDirection.horizontal;
    final lineColor = color ?? NutUIColors.border;
    final actualThickness = hairline ? 0.5 : thickness;

    final defaultTextStyle = TextStyle(
      fontSize: 24,
      color: NutUIColors.textTertiary,
    );
    final effectiveTextStyle = textStyle ?? defaultTextStyle;

    // 构建内容区域（文字或自定义 Widget）
    Widget? contentWidget;
    if (child != null) {
      contentWidget = child;
    } else if (text != null) {
      contentWidget = Text(text!, style: effectiveTextStyle);
    }

    // 无内容时，直接渲染单条线
    if (contentWidget == null) {
      return Container(
        margin: margin,
        child: _buildLine(isHorizontal, lineColor, actualThickness),
      );
    }

    // 有内容时的布局
    return Container(
      margin: margin,
      child: isHorizontal ? _buildHorizontal(contentWidget, lineColor, actualThickness) : _buildVertical(contentWidget, lineColor, actualThickness),
    );
  }
  
  // 构建单条线段（支持虚线）
  Widget _buildLine(bool isHorizontal, Color color, double thickness) {
    if (dashed) {
      return SizedBox(
        width: isHorizontal ? double.infinity : thickness,
        height: isHorizontal ? thickness : double.infinity,
        child: CustomPaint(
          painter: _DashedLinePainter(
            color: color,
            strokeWidth: thickness,
            dashWidth: 4,
            dashGap: 4,
            isHorizontal: isHorizontal,
          ),
        ),
      );
    }

    return Container(
      color: color,
      height: isHorizontal ? thickness : double.infinity,
      width: isHorizontal ? double.infinity : thickness,
    );
  }

  // 水平带内容布局
  Widget _buildHorizontal(Widget content, Color lineColor, double thickness) {
    List<Widget> children = [];

    switch (contentPosition) {
      case NutDividerContentPosition.left:
        children.add(SizedBox(width: contentSpacing));
        children.add(content);
        children.add(SizedBox(width: contentSpacing));
        children.add(Expanded(child: _buildLine(true, lineColor, thickness)));
        break;
      case NutDividerContentPosition.right:
        children.add(Expanded(child: _buildLine(true, lineColor, thickness)));
        children.add(SizedBox(width: contentSpacing));
        children.add(content);
        children.add(SizedBox(width: contentSpacing));
        break;
      case NutDividerContentPosition.center:
        children.add(Expanded(child: _buildLine(true, lineColor, thickness)));
        children.add(SizedBox(width: contentSpacing));
        children.add(content);
        children.add(SizedBox(width: contentSpacing));
        children.add(Expanded(child: _buildLine(true, lineColor, thickness)));
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  // 垂直带内容布局
  Widget _buildVertical(Widget content, Color lineColor, double thickness) {
    List<Widget> children = [];

    switch (contentPosition) {
      case NutDividerContentPosition.left: // 垂直时 left 对应 top
        children.add(SizedBox(height: contentSpacing));
        children.add(content);
        children.add(SizedBox(height: contentSpacing));
        children.add(Expanded(child: _buildLine(false, lineColor, thickness)));
        break;
      case NutDividerContentPosition.right: //垂直时 right 对应 bottom
        children.add(Expanded(child: _buildLine(false, lineColor, thickness)));
        children.add(SizedBox(height: contentSpacing));
        children.add(content);
        children.add(SizedBox(height: contentSpacing));
        break;
      case NutDividerContentPosition.center:
        children.add(Expanded(child: _buildLine(false, lineColor, thickness)));
        children.add(SizedBox(height: contentSpacing));
        children.add(content);
        children.add(SizedBox(height: contentSpacing));
        children.add(Expanded(child: _buildLine(false, lineColor, thickness)));
        break;
    }

    // 保证垂直分割线宽度包裹内容
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}

// 虚线线条绘制（专用于单条线）
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;
  final bool isHorizontal;

  _DashedLinePainter({
    required this.color,
    required this.strokeWidth,
    this.dashWidth = 4.0,
    this.dashGap = 4.0,
    this.isHorizontal = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square;

    if (isHorizontal) {
      double startX = 0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, 0),
          Offset(startX + dashWidth, 0),
          paint,
        );
        startX += dashWidth + dashGap;
      }
    } else {
      double startY = 0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(0, startY),
          Offset(0, startY + dashWidth),
          paint,
        );
        startY += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}