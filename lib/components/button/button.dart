import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/colors.dart';
import '../icon/icon.dart';

// 按钮类型
enum NutButtonType {
  primary, // 主要
  success, // 成功
  warning, // 警告
  danger, // 危险
  info, // 信息
  defaultType, // 默认
}

// 按钮尺寸
enum NutButtonSize {
  large, // 大号 48px
  medium, // 中号 36px
  small, // 小号 28px
  mini, // 迷你 24px
}

// 按钮外观
enum NutButtonAppearance {
  solid, // 实心(默认)
  outlined, // 描边
  dashed, // 虚线
  text, // 纯文字
}

// 按钮形状
enum NutButtonShape {
  rect, // 直角 (默认)
  round, // 圆角
  circle, // 圆形(搭配图标使用)
}

class NutButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? text;

  final NutButtonType type;
  final NutButtonSize size;
  final NutButtonAppearance appearance;
  final NutButtonShape shape;

  final bool loading;
  final bool disabled;
  final bool block;

  final IconData? icon;
  final Color? iconColor; // 自定义图标颜色

  // 是否开启按压缩放动画（默认开启）
  final bool enableScaleAnimation;
  // 是否开启触觉反馈 (轻微震动, 默认关闭)
  final bool enableHapticFeedback;

  const NutButton({
    super.key,
    this.onPressed,
    this.child,
    this.text,
    this.type = NutButtonType.defaultType,
    this.size = NutButtonSize.medium,
    this.appearance = NutButtonAppearance.solid,
    this.shape = NutButtonShape.rect,
    this.loading = false,
    this.disabled = false,
    this.block = false,
    this.icon,
    this.iconColor,
    this.enableScaleAnimation = true,
    this.enableHapticFeedback = false,
  });

  @override
  State<NutButton> createState() => _NutButtonState();
}

class _NutButtonState extends State<NutButton> {
  bool _isPressed = false;

  // 是否处于不可交互状态
  bool get _isEffectiveDisabled => widget.disabled || widget.loading;

  void _handleTapDown(TapDownDetails details) {
    if (_isEffectiveDisabled) return;
    setState(() => _isPressed = true);
    // 触觉反馈
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isEffectiveDisabled) return;
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (_isEffectiveDisabled) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    // 获取样式配置
    final styles = _NutButtonStyleResolver.resolve(
      type: widget.type,
      size: widget.size,
      appearance: widget.appearance,
      shape: widget.shape,
      disabled: _isEffectiveDisabled,
      pressed: _isPressed,
    );

    // 构建内容 (图标 + 文字 + 加载动画)
    Widget content = _buildContent(styles);

    // 构建容器和装饰
    Widget button = _buildContainer(styles, content);

    // 处理 block 全宽
    if (widget.block) {
      button = SizedBox(width: double.infinity, child: button);
    }

    // 按压缩放动画包裹
    if (widget.enableScaleAnimation && !_isEffectiveDisabled) {
      button = AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0, // 按下时缩小至 96%
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: button,
      );
    }

    // 交互与点击
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _isEffectiveDisabled ? null : widget.onPressed,
      child: button,
    );
  }

  // 构建按钮内容区域
  Widget _buildContent(_NutButtonStyles styles) {
    List<Widget> children = [];

    // 加载指示器
    final hasTextOrChild = widget.text != null || widget.child != null;
    if (widget.loading) {
      children.add(Padding(
        padding: EdgeInsets.only(right: hasTextOrChild ? 4.0 : 0),
        child: SizedBox(
          width: styles.fontSize + 2,
          height: styles.fontSize + 2,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(styles.textColor),
          ),
        ),
      ));
    }

    // 左侧图标
    if (widget.icon != null && !widget.loading) {
      children.add(Padding(
        padding: EdgeInsets.only(right: hasTextOrChild ? 4.0 : 0),
        child: NutIcon(icon: widget.icon!, size: styles.fontSize + 4, color: widget.iconColor ?? styles.textColor),
      ));
    }

    // 文字
    final btnText = widget.text;
    if (btnText != null) {
      children.add(Text(
        btnText,
        style: TextStyle(
          fontSize: styles.fontSize,
          fontWeight: FontWeight.w500,
          color: styles.textColor,
          height: 1.2,
        ),
      ));
    } else {
      final btnChild = widget.child;
      if (btnChild != null) {
        children.add(DefaultTextStyle(
          style: TextStyle(
            fontSize: styles.fontSize,
            fontWeight: FontWeight.w500,
            color: styles.textColor,
            height: 1.2,
          ),
          child: btnChild,
        ));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  // 构建外层容器
  Widget _buildContainer(_NutButtonStyles styles, Widget content) {
    // 增加按压态的颜色过渡动画
    final animatedContainer = AnimatedContainer(
      duration: const Duration(milliseconds: 150), // 颜色变化过渡时长
      padding: styles.padding,
      decoration: BoxDecoration(
        color: styles.backgroundColor,
        borderRadius: BorderRadius.circular(styles.borderRadius),
        border: styles.borderColor != null
          ? Border.all(color: styles.borderColor!, width: 1.0)
          : null,  
      ),
      child: content,
    );
    
    // 虚线边框特殊处理
    if (widget.appearance == NutButtonAppearance.dashed) {
      Widget dashedButton = CustomPaint(
        painter: _DashedPainter(
          color: styles.borderColor ?? styles.textColor,
          radius: styles.borderRadius,
          strokeWidth: 1.0,
          dashGap: 3.0,
          dashWidth: 5.0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: styles.padding,
          decoration: BoxDecoration(
            color: styles.backgroundColor,
            borderRadius: BorderRadius.circular(styles.borderRadius),
          ),
          child: content,
        ),
      );
      return dashedButton;
    }

    return animatedContainer;
  }

}

class _NutButtonStyles {
  final Color backgroundColor;
  final Color textColor;
  Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  _NutButtonStyles({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.borderRadius,
    required this.padding,
    required this.fontSize,
  });
}

class _NutButtonStyleResolver {
  static _NutButtonStyles resolve({
    required NutButtonType type,
    required NutButtonSize size,
    required NutButtonAppearance appearance,
    required NutButtonShape shape,
    required bool disabled,
    required bool pressed,
  }) {
    // 获取颜色映射
    final colors = _getTypeColors(type, appearance, disabled, pressed);

    // 获取尺寸映射
    final sizeData = _getSizeData(size);

    // 获取圆角
    final radius = _getBorderRadius(size, shape);

    return _NutButtonStyles(
      backgroundColor: colors['bg']!,
      textColor: colors['text']!,
      borderColor: colors['border'],
      borderRadius: radius,
      padding: shape == NutButtonShape.circle
          ? EdgeInsets.all(sizeData['circlePadding']!.toDouble())
          : EdgeInsets.symmetric(
        vertical: sizeData['vPadding']!.toDouble(),
        horizontal: sizeData['hPadding']!.toDouble(),
      ),
      fontSize: sizeData['fontSize']!.toDouble(),
    );
  }

  static Map<String, Color?> _getTypeColors(NutButtonType type, NutButtonAppearance appearance, bool disabled, bool pressed) {
    // 禁用状态
    if (disabled) {
      if (appearance == NutButtonAppearance.solid) {
        return {'bg': NutUIColors.primaryLight, 'text': NutUIColors.white};
      } else {
        return {'bg': Colors.transparent, 'text': NutUIColors.textDisabled};
      }
    }

    // 获取主色和浅色
    Color primaryColor;
    Color lightColor;
    Color pressedColor;
    switch (type) {
      case NutButtonType.primary:
        primaryColor = NutUIColors.primary;
        lightColor = NutUIColors.primaryLight;
        pressedColor = NutUIColors.primaryPressed;
        break;
      case NutButtonType.success:
        primaryColor = NutUIColors.success;
        lightColor = NutUIColors.successLight;
        pressedColor = NutUIColors.primaryPressed;
        break;
      case NutButtonType.warning:
        primaryColor = NutUIColors.warning;
        lightColor = NutUIColors.warningLight;
        pressedColor = NutUIColors.primaryPressed;
        break;
      case NutButtonType.danger:
        primaryColor = NutUIColors.danger;
        lightColor = NutUIColors.dangerLight;
        pressedColor = NutUIColors.primaryPressed;
        break;
      case NutButtonType.info:
        primaryColor = NutUIColors.info;
        lightColor = NutUIColors.infoLight;
        pressedColor = NutUIColors.primaryPressed;
        break;
      case NutButtonType.defaultType:
        primaryColor = NutUIColors.textPrimary;
        lightColor = const Color(0xFFF5F5F5); // 默认按钮的浅色背景
        break;
    }

    // 根据外观返回颜色组合
    switch (appearance) {
      case NutButtonAppearance.solid:
        if (type == NutButtonType.defaultType) {
          return {'bg': lightColor, 'text': primaryColor, 'border': null};
        }
        return {'bg': primaryColor, 'text': NutUIColors.white, 'border': null};
      case NutButtonAppearance.outlined:
      case NutButtonAppearance.dashed:
        return {'bg': Colors.transparent, 'text': primaryColor, 'border': primaryColor};
      case NutButtonAppearance.text:
        return {'bg': Colors.transparent, 'text': primaryColor, 'border': null};
    }
  }

  static Map<String, num> _getSizeData(NutButtonSize size) {
    switch (size) {
      case NutButtonSize.large:
        return {'vPadding': 13, 'hPadding': 20, 'fontSize': 16, 'circlePadding': 12};
      case NutButtonSize.medium:
        return {'vPadding': 9, 'hPadding': 16, 'fontSize': 14, 'circlePadding': 10};
      case NutButtonSize.small:
        return {'vPadding': 5, 'hPadding': 12, 'fontSize': 12, 'circlePadding': 7};
      case NutButtonSize.mini:
        return {'vPadding': 3, 'hPadding': 8, 'fontSize': 10, 'circlePadding': 5};
    }
  }

  static double _getBorderRadius(NutButtonSize size, NutButtonShape shape) {
    if (shape == NutButtonShape.circle) return 999.0;
    if (shape == NutButtonShape.round) {
      return 999.0; // Flutter 会自动根据高度计算最大圆角
    }
    // 直角 (rect) 根据 NutUI 规范，大号是 8px, 其他是 4px
    switch (size) {
      case NutButtonSize.large: return 8.0;
      case NutButtonSize.medium: return 4.0;
      case NutButtonSize.small: return 4.0;
      case NutButtonSize.mini: return 2.0;
    }
  }
}

// 虚线绘制(支持圆角)
class _DashedPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  _DashedPainter({
    required this.color,
    required this.radius,
    this.strokeWidth = 1.0,
    this.dashWidth = 5.0,
    this.dashGap = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final dashedPath = Path();
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = dashWidth;
        if (distance + length > metric.length) {
          dashedPath.addPath(metric.extractPath(distance, metric.length), Offset.zero);
        } else {
          dashedPath.addPath(metric.extractPath(distance, distance + length), Offset.zero);
        }
        distance += dashWidth + dashGap;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}