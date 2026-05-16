import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../icon/icon.dart';

class NutMenuItem {
  // 菜单标题
  final String title;

  // 下拉面板内容
  final Widget child;

  const NutMenuItem({
    required this.title,
    required this.child,
  });
}

class NutMenu extends StatefulWidget {
  // 菜单项列表
  final List<NutMenuItem> items;

  // 底层页面内容
  final Widget body;

  // 选中颜色
  final Color activeColor;

  // 遮罩层颜色
  final Color overlayColor;

  const NutMenu({
    super.key,
    required this.items,
    required this.body,
    this.activeColor = NutUIColors.primary,
    this.overlayColor = NutUIColors.overlayMenu,
  });

  @override
  State<NutMenu> createState() => _NutMenuState();
}

class _NutMenuState extends State<NutMenu> {
  // 当前展开的菜单索引 (-1 表示全部收起)
  int _activeIndex = -1;

  // 切换菜单展开/收起
  void _toggleMenu(int index) {
    setState(() {
      if (_activeIndex == index) {
        _activeIndex = -1; // 再次点击关闭
      } else {
        _activeIndex = index; // 点击其他项切换
      }
    });
  }

  // 关闭菜单
  void _closeMenu() {
    if (_activeIndex != -1) {
      setState(() => _activeIndex = -1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 顶部菜单导航栏
        _buildMenuBar(),

        // 内容区域（包含底层页面和浮层面板）
        Expanded(
          child: Stack(
            children: [
              // 底层页面内容
              widget.body,

              // 遮罩层和下拉面板 (需要忽略不可见时的触摸事件)
              IgnorePointer(
                ignoring: _activeIndex == -1,
                child: _buildOverlayAndPanel(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 构建顶部菜单栏
  Widget _buildMenuBar() {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: NutUIColors.white,
        border: Border(bottom: BorderSide(color: NutUIColors.border, width: 0.5)),
      ),
      child: Row(
        children: widget.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isActive = _activeIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => _toggleMenu(index),
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: isActive ? widget.activeColor : NutUIColors.text,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // 箭头图标，展开时旋转
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 250),
                    turns: isActive ? 0.5 : 0.0, // 0.5 圈即 180 度
                    child: NutIcon(icon: NutIcons.downArrow, size: 20, color: isActive ? widget.activeColor : NutUIColors.textSecondary),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 构建遮罩层和下拉面板
  Widget _buildOverlayAndPanel() {
    return AnimatedOpacity(
      opacity: _activeIndex == -1 ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: Column(
        children: [
          // 遮罩层（点击关闭）
          Expanded(
            child: GestureDetector(
              onTap: _closeMenu,
              child: Container(color: widget.overlayColor),
            ),
          ),

          // 下拉面板（带高度动画）
          _activeIndex != -1
            ? _buildPanel(widget.items[_activeIndex].child)
            : const SizedBox.shrink(),
        ],
      ),
    );
  }

  // 构建下拉面板内容 (使用 AnimatedSize 实现高度自适应动画)
  Widget _buildPanel(Widget child) {
    return ClipRect(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        alignment: Alignment.topCenter, // 从顶部向下展开
        child: Container(
          width: double.infinity,
          color: NutUIColors.white,
          child: child,
        ),
      ),
    );
  }
}