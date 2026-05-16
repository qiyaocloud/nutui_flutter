import 'package:flutter/material.dart';
import 'package:nutui_flutter/components/icon/icon.dart';
import 'package:nutui_flutter/theme/colors.dart';

enum NutTagType {
  primary,
  success,
  danger,
  warning
}

enum NutTagSize {
  large,
  normal,
  small
}

class NutTag extends StatelessWidget {
  // 文本内容 (如果设置了 child，则 text 失效)
  final String? text;

  // 自定义子组件
  final Widget? child;

  // 标签类型
  final NutTagType type;

  // 是否为空心样式
  final bool plain;

  // 是否为圆角样式
  final bool round;

  // 是否为标记样式 (左侧圆角，右侧水滴尖角)
  final bool mark;

  // 尺寸
  final NutTagSize size;

  // 是否可关闭
  final bool closeable;

  // 关闭图标的点击回调
  final VoidCallback? onClose;

  // 自定义标签颜色 (覆盖 type 的颜色)
  final Color? color;

  // 自定义文字颜色
  final Color? textColor;

  const NutTag({
    super.key,
    this.text,
    this.child,
    this.type = NutTagType.primary,
    this.plain = false,
    this.round = false,
    this.mark = false,
    this.size = NutTagSize.normal,
    this.closeable = false,
    this.onClose,
    this.color,
    this.textColor,
  });

  // 获取类型对应的默认颜色
  Color get _typeColor {
    if (color != null) return color!;
    switch (type) {
      case NutTagType.primary: return NutUIColors.primary;
      case NutTagType.success: return NutUIColors.success;
      case NutTagType.danger: return NutUIColors.danger;
      case NutTagType.warning: return NutUIColors.warning;
    }
  }

  // 获取背景色
  Color get _backgroundColor => plain ? NutUIColors.white : _typeColor;

  // 获取边框色
  Color get _borderColor => plain ? _typeColor : Colors.transparent;

  // 获取文字颜色
  Color get _contentColor {
    if (textColor != null) return textColor!;
    return plain ? _typeColor : NutUIColors.white;
  }

  // 获取圆角
  BorderRadius get _borderRadius {
    if (mark) {
      // Mark 样式：左侧全圆角，右侧无圆角
      return const BorderRadius.only(
        topLeft: Radius.circular(100),
        bottomLeft: Radius.circular(100),
      );
    }
    if (round) {
      // Round 样式：全圆角 (胶囊型)
      return BorderRadius.circular(100);
    }
    // 默认微小圆角
    return BorderRadius.circular(2);
  }

  // 获取内边距
  EdgeInsetsGeometry get _padding {
    switch (size) {
      case NutTagSize.large: return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case NutTagSize.normal: return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case NutTagSize.small: return const EdgeInsets.symmetric(horizontal: 4, vertical: 1);
    }
  }

  // 获取字体大小
  double get _fontSize {
    switch (size) {
      case NutTagSize.large: return 12;
      case NutTagSize.normal: return 11;
      case NutTagSize.small: return 10;
    }
  }

  // 获取图标大小
  double get _iconSize {
    switch (size) {
      case NutTagSize.large: return 14;
      case NutTagSize.normal: return 12;
      case NutTagSize.small: return 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mark 样式需要右侧留出尖角的空间
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: _buildContent()),
        if (closeable) _buildCloseIcon(),
      ],
    );

    // 如果是 mark 样式，右侧需要留出空白模拟尖角
    if (mark) {
      content = Padding(
        padding: const EdgeInsets.only(right: 6), // 尖角占据的宽度
        child: content,
      );
    }

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: _borderRadius,
        border: Border.all(color: _borderColor, width: 0.5),
      ),
      child: content,
    );
  }

  // 构建文字内容
  Widget _buildContent() {
    if (child != null) {
      return DefaultTextStyle(
        style: TextStyle(color: _contentColor, fontSize: _fontSize, height: 1.2),
        child: child!,
      );
    }
    return Text(
      text ?? '',
      style: TextStyle(color: _contentColor, fontSize: _fontSize, height: 1.2),
    );
  }

  // 构建关闭图标
  Widget _buildCloseIcon() {
    return GestureDetector(
      onTap: onClose,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(left: 4),
        child: NutIcon(
          icon: NutIcons.close,
          size: _iconSize,
          color: _contentColor,
        ),
      ),
    );
  }
}