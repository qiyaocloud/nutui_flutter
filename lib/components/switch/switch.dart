import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class NutSwitch extends StatefulWidget {
  // 开关状态
  final bool value;

  // 状态改变回调
  final ValueChanged<bool>? onChanged;

  // 是否禁用
  final bool disabled;

  // 是否加载中
  final bool loading;

  // 打开时的背景色
  final Color activeColor;

  // 关闭时的背景色
  final Color inactiveColor;

  // 打开时滑块内的图标
  final Widget? activeIcon;

  // 关闭时滑块内的图标
  final Widget? inactiveIcon;

  const NutSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.loading = false,
    this.activeColor = NutUIColors.primary,
    this.inactiveColor = NutUIColors.white,
    this.activeIcon,
    this.inactiveIcon,
  });

  @override
  State<NutSwitch> createState() => _NutSwitchState();
}

class _NutSwitchState extends State<NutSwitch> {
  @override
  Widget build(BuildContext context) {
    // 是否不可交互
    final isEffectiveDisabled = widget.disabled || widget.loading;

    return GestureDetector(
      onTap: isEffectiveDisabled
          ? null
          : () => widget.onChanged?.call(!widget.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 51,
        height: 31,
        padding: const EdgeInsets.all(2), // 边框内边距
        decoration: BoxDecoration(
          color: _getTrackColor(),
          borderRadius: BorderRadius.circular(15.5),
          // 关闭状态加边框，打开状态不加
          border: widget.value
            ? null
            : Border.all(color: NutUIColors.border, width: 1),
        ),
        child: Stack(
          children: [
            // 滑块
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: NutUIColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                // 滑块内部内容（图标或加载动画）
                child: _buildThumbContent(),
              ),
            ),
            // 轨道内的加载指示器（当滑块移开时显示）
            if (widget.loading) _buildTrackLoading(),
          ],
        ),
      ),
    );
  }

  // 获取轨道背景色
  Color _getTrackColor() {
    if (widget.disabled) {
      return widget.value ? NutUIColors.primaryLight : NutUIColors.bgGray;
    }
    return widget.value ? widget.activeColor : widget.inactiveColor;
  }

  // 滑块内部内容
  Widget _buildThumbContent() {
    // 加载态：滑块内显示 loading
    if (widget.loading) {
      return Padding(
        padding: const EdgeInsets.all(7.0),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.value ? widget.activeColor : NutUIColors.textDisabled,
          ),
        ),
      );
    }

    // 自定义图标
    if (widget.value && widget.activeIcon != null) {
      return widget.activeIcon!;
    }
    if (!widget.value && widget.inactiveIcon != null) {
      return widget.inactiveIcon!;
    }

    return const SizedBox.shrink();
  }

  // 轨道内部的加载指示器 (NutUI 风格：轨道内也有旋转圈)
  Widget _buildTrackLoading() {
    // 计算轨道内 loading 的位置 (与滑块位置相反)
    final alignment =
        widget.value ? Alignment.centerLeft : Alignment.centerRight;

    return AnimatedAlign(
      duration: const Duration(milliseconds: 300),
      alignment: alignment,
      child: Container(
        width: 27,
        height: 27,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.value
                  ? NutUIColors.white.withValues(alpha: 0.5)
                  : NutUIColors.textDisabled.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}