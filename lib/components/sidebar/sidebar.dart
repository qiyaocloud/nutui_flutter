import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class NutSidebar extends StatefulWidget {
  // 侧边栏菜单项文字列表
  final List<String> items;

  // 右侧对应的页面列表
  final List<Widget> children;

  // 初始选中的索引
  final int initialIndex;

  // 左侧侧边栏宽度
  final double sidebarWidth;

  // 侧边栏单项高度
  final double itemHeight;

  // 指示条宽度
  final double indicatorWidth;

  // 提示条高度
  final double indicatorHeight;

  // 提示条圆角
  final double indicatorRadius;

  // 选中颜色
  final Color activeColor;

  // 切换回调
  final ValueChanged<int>? onChanged;

  const NutSidebar({
    super.key,
    required this.items,
    required this.children,
    this.initialIndex = 0,
    this.sidebarWidth = 100,
    this.itemHeight = 50,
    this.indicatorWidth = 3,
    this.indicatorHeight = 16,
    this.indicatorRadius = 1.5,
    this.activeColor = NutUIColors.primary,
    this.onChanged,
  });

  @override
  State<NutSidebar> createState() => _NutSidebarState();
}

class _NutSidebarState extends State<NutSidebar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTap(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 左侧侧边栏
        _buildSidebar(),
        // 右侧内容区
        Expanded(child: _buildContent()),
      ],
    );
  }

  // 构建左侧侧边栏
  Widget _buildSidebar() {
    return Container(
      width: widget.sidebarWidth,
      color: NutUIColors.navBg,
      child: Stack(
        children: [
          // 列表项
          ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: widget.items.length,
            itemExtent: widget.itemHeight, // 强制固定高度，保证指示条计算精准
            itemBuilder: (context, index) {
              final isActive = _currentIndex == index;
              return _buildItem(index, isActive);
            },
          ),
          // 滑动指示条
          _buildIndicator(),
        ],
      ),
    );
  }

  // 构建单个菜单项
  Widget _buildItem(int index, bool isActive) {
    return GestureDetector(
      onTap: () => _onItemTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: widget.itemHeight,
        alignment: Alignment.center,
        color: isActive ? NutUIColors.contentBg : Colors.transparent, // 选中项背景变白，与右侧融为一体
        child: Padding(
          padding: const EdgeInsets.only(left: 8), // 给指示条留出空间
          child: Text(
            widget.items[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isActive ? NutUIColors.text : NutUIColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  // 构建左侧指示条（带动画）
  Widget _buildIndicator() {
    // 计算指示条垂直偏移量
    final double topOffset = (_currentIndex * widget.itemHeight) + (widget.itemHeight - widget.indicatorHeight) / 2;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      left: 0,
      top: topOffset,
      width: widget.indicatorWidth,
      height: widget.indicatorHeight,
      child: Container(
        decoration: BoxDecoration(
          color: widget.activeColor,
          borderRadius: BorderRadius.circular(widget.indicatorRadius),
        ),
      ),
    );
  }

  // 构建右侧内容区
  Widget _buildContent() {
    // 使用 IndexedStack 保持页面状态
    return IndexedStack(
      index: _currentIndex,
      sizing: StackFit.expand,
      children: widget.children,
    );
  }
}