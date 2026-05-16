import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../icon/icon.dart';

class NutNavbar extends StatelessWidget {
  // 标题文字
  final String? title;

  // 自定义标题组件（优先级高于 title）
  final Widget? titleWidget;

  // 左侧文字
  final String? leftText;

  // 左侧图标（默认返回箭头）
  final IconData? leftIcon;

  // 自定义左侧区域
  final Widget? leftWidget;

  // 右侧文字
  final String? rightText;

  // 右侧图标
  final IconData? rightIcon;

  // 自定义右侧区域
  final Widget? rightWidget;

  // 左侧点击回调 (如果为 null，默认执行 Navigator.pop)
  final VoidCallback? onBack;

  // 右侧点击回调
  final VoidCallback? onRightClick;

  // 是否显示底部边框
  final bool border;

  // 背景色
  final Color backgroundColor;

  // 标题颜色
  final Color titleColor;

  // 是否占位顶部安全区 (如果放在 Scaffold.appBar 中应为 false，放在 body 中应为 true)
  final bool safeAreaTop;

  // 导航栏高度（不包含安全区）
  final double height;

  const NutNavbar({
    super.key,
    this.title,
    this.titleWidget,
    this.leftText,
    this.leftIcon = Icons.arrow_back_ios_new,
    this.leftWidget,
    this.rightIcon,
    this.rightText,
    this.rightWidget,
    this.onBack,
    this.onRightClick,
    this.border = true,
    this.backgroundColor = NutUIColors.white,
    this.titleColor = NutUIColors.text,
    this.safeAreaTop = false,
    this.height = 44,
  });

  @override
  Widget build(BuildContext context) {
    Widget navbar = Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border
          ? const Border(
            bottom: BorderSide(color: NutUIColors.border, width: 0.5),
          ) : null,
      ),
      child: Stack(
        children: [
          // 左右按钮区域 (不干扰中间标题居中)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLeft(context),
              _buildRight(),
            ],
          ),
          // 居中标题 (占满全宽，文字居中，左右留出边距防重叠)
          _buildTitle(),
        ],
      ),
    );

    // 处理顶部安全区
    if (safeAreaTop) {
      return SafeArea(
        top: true,
        bottom: false,
        child: navbar,
      );
    }

    return navbar;
  }

  // 构建左侧区域
  Widget _buildLeft(BuildContext context) {
    if (leftWidget != null) {
      return _buildClickArea(child: leftWidget!);
    }

    List<Widget> children = [];

    // 返回箭头
    if (leftIcon != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(left: 12),
        child: NutIcon(icon: leftIcon!, size: 20, color: titleColor),
      ));
    }

    // 左侧文字
    if (leftText != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          leftText!,
          style: TextStyle(fontSize: 14, color: titleColor),
        ),
      ));
    }

    if (children.isEmpty) {
      return const SizedBox(width: 16); // 没有左侧内容，给个最小间距
    }

    return _buildClickArea(
      onTap: onBack ?? () {
        // 默认返回逻辑
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  // 构建右侧区域
  Widget _buildRight() {
    if (rightWidget != null) {
      return _buildClickArea(child: rightWidget!);
    }

    List<Widget> children = [];

    // 右侧图标
    if (rightIcon != null) {
      children.add(NutIcon(icon: rightIcon!, size: 20, color: titleColor));
    }

    // 右侧文字
    if (rightText != null) {
      children.add(Text(
        rightText!,
        style: TextStyle(fontSize: 14, color: titleColor),
      ));
    }

    if (children.isEmpty) {
      return const SizedBox(width: 16); // 没有右侧内容，给个最小间距
    }

    return _buildClickArea(
      onTap: onRightClick,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  // 构建居中标题
  Widget _buildTitle() {
    Widget child;
    if (titleWidget != null) {
      child = titleWidget!;
    } else if (title != null) {
      child = Text(
        title!,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 60), // 关键：给左右留出足够空间，防止长标题与按钮重叠
      child: child,
    );
  }

  // 统一点击区域包装器 (扩大点击范围)
  Widget _buildClickArea({required Widget child, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minWidth: 44, minHeight: 44), // 至少 44x44 的点击热区
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}