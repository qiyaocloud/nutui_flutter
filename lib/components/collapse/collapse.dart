import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nutui_flutter/components/icon/icon.dart';

import '../../theme/colors.dart';

// 折叠面板父组件
class NutCollapse extends StatefulWidget {
  // 当前展开面板的name列表
  final List<String> value;

  // 值改变回调
  final ValueChanged<List<String>>? onChanged;

  // 是否开启手风琴模式 (一次只能展开一个)
  final bool accordion;

  // 子项列表
  final List<NutCollapseItem> children;

  const NutCollapse({
    super.key,
    required this.value,
    this.onChanged,
    this.accordion = false,
    required this.children,
  });

  @override
  State<NutCollapse> createState() => _NutCollapseState();
}

class _NutCollapseState extends State<NutCollapse> {
  // 处理子项点击切换逻辑
  void _handleToggle(String name, bool isDisabled) {
    if (isDisabled) return;

    List<String> newValue = List.from(widget.value);

    if (widget.accordion) {
      // 手风琴模式：如果点击的已经展开，则收起；否则只保留当前点击的
      if (newValue.contains(name)) {
        newValue.remove(name);
      } else {
        newValue = [name];
      }
    } else {
      // 普通模式：切换当前项的展开/收起状态
      if (newValue.contains(name)) {
        newValue.remove(name);
      } else {
        newValue.add(name);
      }
    }

    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: NutUIColors.white,
        border: Border(top: BorderSide(color: NutUIColors.border, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.children.map((item) {
          // 判断当前项是否处于展开状态
          bool isExpanded = widget.value.contains(item.name);

          // 重新构建子组件，注入状态和回调
          return NutCollapseItem(
            key: item.key,
            name: item.name,
            title: item.title,
            label: item.label,
            disabled: item.disabled,
            isExpanded: isExpanded,
            onToggle: () => _handleToggle(item.name, item.disabled),
            child: item.child,
          );
        }).toList(),
      ),
    );
  }
}

// 折叠面板子项
class NutCollapseItem extends StatelessWidget {
  // 唯一标识
  final String name;

  // 标题
  final String? title;

  // 标题右侧描述
  final String? label;

  // 是否禁用
  final bool disabled;

  // 是否展开(由父组件注入)
  final bool isExpanded;

  // 切换回调 (由父组件注入)
  final VoidCallback? onToggle;

  // 内容区
  final Widget child;

  const NutCollapseItem({
    super.key,
    required this.name,
    required this.title,
    this.label,
    this.disabled = false,
    this.isExpanded = false,
    this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题栏
        GestureDetector(
          onTap: onToggle,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: NutUIColors.border, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: TextStyle(
                      fontSize: 14,
                      color: disabled ? NutUIColors.disabled : NutUIColors.collapseTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (label != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      label!,
                      style: const TextStyle(fontSize: 12, color: NutUIColors.collapseLabel),
                    ),
                  ),
                // 箭头动画
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: isExpanded ? math.pi / 2 : 0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  builder: (context, angle, child) {
                    return Transform.rotate(angle: angle, child: child);
                  },
                  child: NutIcon(
                    icon: NutIcons.arrowRight,
                    size: 14,
                    color: disabled ? NutUIColors.disabled : NutUIColors.collapseLabel,
                  ),
                ),
              ],
            ),
          ),
        ),

        // 内容区（带动画）
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Container(
              // 核心：收起时高度为0，展开时交给子组件自适应
              width: double.infinity,
              constraints: isExpanded
                ? const BoxConstraints() // 展开无约束
                : const BoxConstraints(maxHeight: 0), // 收起强制高度为0
              padding: const EdgeInsets.all(16),
              color: isExpanded ? const Color(0xFFF7F8FA) : null,
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 14, color: NutUIColors.collapseContent, height: 1.5),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}