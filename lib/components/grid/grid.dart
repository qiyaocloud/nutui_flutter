import 'package:flutter/material.dart';
import 'package:nutui_flutter/theme/colors.dart';
import '../icon/icon.dart';

// 宫格内容排列方向
enum NutGridDirection {
  vertical,
  horizontal,
}

// 宫格项数据模型
class NutGridItem {
  final String? text;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final VoidCallback? onTap;
  final Widget? customContent; // 自定义整个内容区域
  final Widget? badge; // 角标

  const NutGridItem({
    this.text,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.onTap,
    this.customContent,
    this.badge,
  });
}

class NutGrid extends StatelessWidget {
  // 列数
  final int columnNum;

  // 是否显示边框
  final bool border;

  // 格子之间的间距(设置后边框失效)
  final double gutter;

  // 是否将格子内容居中
  final bool center;

  // 内容排列方向(图标和文字的排列)
  final NutGridDirection direction;

  // 格子宽高比
  final double aspectRatio;

  // 宫格项数据
  final List<NutGridItem> children;

  const NutGrid({
    super.key,
    this.columnNum = 4,
    this.border = true,
    this.gutter = 0,
    this.center = true,
    this.direction = NutGridDirection.vertical,
    this.aspectRatio = 1.0, // NutUI 默认正方形
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    // 使用 GridView 构建矩阵
    return Container(
      // 容器左侧和顶部加边框，配合子项的右侧和底部边框形成完整矩阵
      decoration: border && gutter <= 0
          ? BoxDecoration(
            border: Border(
              top: BorderSide(color: NutUIColors.border, width: 0.5),
              left: BorderSide(color: NutUIColors.border, width: 0.5),
            ),
          )
          : null,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // 禁用内部滚动，跟随外部页面滚动
        crossAxisCount: columnNum,
        mainAxisSpacing: gutter,
        crossAxisSpacing: gutter,
        childAspectRatio: aspectRatio,
        padding: EdgeInsets.zero,
        children: children.asMap().entries.map((entry) {
          return _buildGridItem(entry.value, entry.key);
        }).toList(),
      ),
    );
  }

  Widget _buildGridItem(NutGridItem item, int index) {
    // 子项右边和底部加边框
    BoxDecoration? itemDecoration;
    if (border && gutter <= 0) {
      itemDecoration = BoxDecoration(
        border: Border(
          right: BorderSide(color: NutUIColors.border, width: 0.5),
          bottom: BorderSide(color: NutUIColors.border, width: 0.5),
        ),
      );
    }

    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: itemDecoration,
        color: Colors.white,
        child: item.customContent ?? _buildDefaultContent(item),
      ),
    );
  }

  // 构建默认的 图标+文字 内容
  Widget _buildDefaultContent(NutGridItem item) {
    List<Widget> children = [];

    // 图标部分 (带角标支持)
    if (item.icon != null) {
      Widget iconWidget = NutIcon(icon: item.icon!, size: item.iconSize ?? 28, color: item.iconColor ?? NutUIColors.text);

      // 如果有角标，使用 Stack 包裹
      if (item.badge != null) {
        iconWidget = Stack(
          clipBehavior: Clip.none,
          children: [
            iconWidget,
            Positioned(
              top: -4,
              right: -12,
              child: item.badge!,
            ),
          ],
        );
      }

      children.add(iconWidget);
    }

    // 文字部分
    if (item.text != null) {
      children.add(Text(
        item.text!,
        style: const TextStyle(
          fontSize: 12,
          color: NutUIColors.textSecondary,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ));
    }

    // 根据方向排列
    final Widget content;
    if (direction == NutGridDirection.vertical) {
      content = Column(
        mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children.map((child) {
          // 图标与文字的间距
          if (child != children.last && item.icon != null) {
            return Padding(padding: const EdgeInsets.only(bottom: 8.0), child: child);
          }
          return child;
        }).toList(),
      );
    } else {
      content = Row(
        mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children.map((child) {
          if (child != children.last && item.icon != null) {
            return Padding(padding: const EdgeInsets.only(right: 6.0), child: child);
          }
          return child;
        }).toList(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: content,
    );
  }
}