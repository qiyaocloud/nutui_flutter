import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class NutBadge extends StatelessWidget {
  // 子元素（被标记的组件）
  final Widget? child;

  // 徽标内容(优先级：dot > content > text > value)
  final bool dot; // 是否显示圆点
  final Widget? content; // 自定义徽标内容
  final String? text; // 文字内容
  final int? value; // 数字内容

  // 最大数字，超过显示 {maxValue}+
  final int maxValue;

  // 背景色
  final Color color;

  // 文字颜色
  final Color textColor;

  // 是否当 value为0 时隐藏
  final bool hideZero;

  // 徽标偏移量，默认向右上角偏移
  final Offset offset;

  const NutBadge({
    super.key,
    this.child,
    this.dot = false,
    this.content,
    this.text,
    this.value,
    this.maxValue = 99,
    this.color = NutUIColors.white,
    this.textColor = NutUIColors.danger,
    this.hideZero = true,
    this.offset = const Offset(4, -4), // 默认稍微往右上偏移，贴合图标边缘
  });

  @override
  Widget build(BuildContext context) {
    final badgeContent = _buildBadgeContent();

    // 独立使用模式：没有子元素时，只渲染徽标本身
    if (child == null) {
      return badgeContent ?? const SizedBox.shrink();
    }

    // 包裹模式：将徽标定位在子元素右上角
    return Stack(
      clipBehavior: Clip.none, // 允许徽标溢出父容器
      children: [
        child!,
        if (badgeContent != null)
          Positioned(
            top: offset.dy,
            right: offset.dx,
            child: badgeContent,
          ),
      ],
    );
  }

  // 构建徽标内容
  Widget? _buildBadgeContent() {
    // 逻辑判断：是否需要隐藏
    if (value != null && value == 0 && hideZero) return null;
    if (value == null && text == null && content == null && !dot) return null;

    // 圆点模式
    if (dot) {
      return _buildDot();
    }

    // 自定义内容模式
    if (content != null) {
      return content;
    }

    // 文字/数字模式
    return _buildTextOrValue();
  }

  // 构建圆点
  Widget _buildDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  // 构建文字或数字
  Widget _buildTextOrValue() {
    String displayText = '';
    final v = value;

    if (v != null) {
      if (v > maxValue) {
        displayText = '$maxValue+';
      } else {
        displayText = v.toString();
      }
    } else if (text != null) {
      displayText = text!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0), // 药丸状圆角
      ),
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      alignment: Alignment.center,
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}