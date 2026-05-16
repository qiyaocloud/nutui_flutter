import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../badge/badge.dart';
import '../icon/icon.dart';

// 标签栏数据模型
class NutTabbarItem {
  // 未选中图标
  final IconData icon;

  // 选中图标（如果不传，未选中时使用 icon 变色）
  final IconData? activeIcon;

  // 文字
  final String title;

  // 徽标
  final Widget? badge;

  const NutTabbarItem({
    required this.icon,
    this.activeIcon,
    required this.title,
    this.badge,
  });
}

class NutTabbar extends StatelessWidget {
  // 标签项列表
  final List<NutTabbarItem> items;

  // 当前选中项索引
  final int currentIndex;

  // 切换回调
  final ValueChanged<int>? onTap;

  // 选中颜色
  final Color activeColor;

  // 未选中颜色
  final Color inactiveColor;

  // 背景色
  final Color backgroundColor;

  // 是否显示顶部细线
  final bool showTopBorder;

  const NutTabbar({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.activeColor = NutUIColors.textPrimary,
    this.inactiveColor = NutUIColors.textSecondary,
    this.backgroundColor = NutUIColors.white,
    this.showTopBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        // 顶部 0.5px 分割线
        border: showTopBorder
          ? const Border(
            top: BorderSide(color: NutUIColors.border, width: 0.5),
          ) : null,
      ),
      // 必须包裹 SafeArea 适配底部安全区
      child: SafeArea(
        top: false,
        bottom: true,
        child: Row(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Expanded(
              child: _buildItem(item, index),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(NutTabbarItem item, int index) {
    final isActive = currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap?.call(index),
      child: Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 2), // 视觉居中微调
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 图标区域 (带动画切换和徽标)
            _buildIconArea(item, isActive),
            const SizedBox(height: 2),
            // 文字区域 (带颜色过渡)
            _buildTitle(item, isActive),
          ],
        ),
      ),
    );
  }

  // 构建图标区域
  Widget _buildIconArea(NutTabbarItem item, bool isActive) {
    // 使用 AnimatedSwitcher 实现图标切换时的淡入淡出
    Widget iconWidget = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: NutIcon(
        key: ValueKey<IconData>(isActive ? (item.activeIcon ?? item.icon) : item.icon),
        icon: isActive ? (item.activeIcon ?? item.icon) : item.icon,
        size: 22,
        color: isActive ? activeColor : inactiveColor,
      ),
    );

    // 包裹缩放动画
    iconWidget = AnimatedScale(
      scale: isActive ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: iconWidget,
    );

    // 如果有徽标，使用 NutBadge 包裹
    if (item.badge != null) {
      return SizedBox(
        height: 28, // 限制高度，防止 Badge 撑开布局
        child: NutBadge(
          // 透传自定义 badge
          dot: item.badge is NutBadge && (item.badge as NutBadge).dot,
          value: item.badge is NutBadge ? (item.badge as NutBadge).value : null,
          content: item.badge is NutBadge ? (item.badge as NutBadge).content : item.badge,
          child: iconWidget,
        ),
      );
    }

    return SizedBox(
      height: 28,
      child: iconWidget,
    );
  }

  // 构建文字区域
  Widget _buildTitle(NutTabbarItem item, bool isActive) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: TextStyle(
        fontSize: 10,
        color: isActive ? activeColor : inactiveColor,
        // 选中时字体加粗 (NutUI 部分主题风格)
        fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
        height: 1.2,
      ),
      child: Text(
        item.title,
        textAlign: TextAlign.center,
      ),
    );
  }
}