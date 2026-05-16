import 'package:flutter/material.dart';

import '../../theme/colors.dart';

// 文本位置
enum NutRadioLabelPosition {
  left,
  right
}

// 排列方向
enum NutRadioDirection {
  vertical,
  horizontal
}

// 单选项数据模型（泛型 T 支持String/int/Enum）
class NutRadioItem<T> {
  final T value;
  final String label;
  final bool disabled;

  const NutRadioItem({
    required this.value,
    required this.label,
    this.disabled = false,
  });
}

// 单个单选框组件
class NutRadio<T> extends StatelessWidget {
  // 当前项的值
  final T value;

  // 组的当前选中值
  final T? groupValue;

  // 选中改变回调
  final ValueChanged<T>? onChanged;

  // 是否禁用
  final bool disabled;

  // 选中颜色
  final Color activeColor;

  // 图标大小
  final double iconSize;

  // 文本位置
  final NutRadioLabelPosition labelPosition;

  // 文本
  final String? text;

  // 自定义子组件（优先级高于 text）
  final Widget? child;

  const NutRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.disabled = false,
    this.activeColor = NutUIColors.primary,
    this.iconSize = 20,
    this.labelPosition = NutRadioLabelPosition.right,
    this.text,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: disabled ? null : () => onChanged?.call(value),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 文本在左侧
            if (labelPosition == NutRadioLabelPosition.left) _buildLabel(),
            if (labelPosition == NutRadioLabelPosition.left)
              const SizedBox(width: 8),

            // 图标
            _buildIcon(isSelected),

            // 文本在右侧
            if (labelPosition == NutRadioLabelPosition.right)
              const SizedBox(width: 8),
            if (labelPosition == NutRadioLabelPosition.right) _buildLabel(),
          ],
        ),
      ),
    );
  }

  // 构建图标
  Widget _buildIcon(bool isSelected) {
    // 边框颜色
    final Color borderColor =
        disabled ? NutUIColors.border : (isSelected ? activeColor : NutUIColors.border);
    // 内部圆点颜色
    final Color dotColor =
        disabled ? NutUIColors.disabledText : activeColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      alignment: Alignment.center,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: isSelected ? 1.0 : 0.0, // 选中时缩放到1，未选中缩放到0隐藏
        child: Container(
          width: iconSize / 2,
          height: iconSize / 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        ),
      ),
    );
  }

  // 构建文本
  Widget _buildLabel() {
    if (child != null) {
      return DefaultTextStyle(
        style: TextStyle(
          fontSize: 14,
          color: disabled ? NutUIColors.disabledText : NutUIColors.text,
        ),
        child: child!,
      );
    }

    if (text != null) {
      return Text(
        text!,
        style: TextStyle(
          fontSize: 14,
          color: disabled ? NutUIColors.disabledText : NutUIColors.text,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// 单选框组
class NutRadioGroup<T> extends StatelessWidget {
  // 所有选项
  final List<NutRadioItem<T>> items;

  // 当前选中的值
  final T? value;

  // 选中状态变化回调
  final ValueChanged<T?>? onChanged;

  // 排列方向
  final NutRadioDirection direction;

  // 选中颜色
  final Color activeColor;

  // 文本位置
  final NutRadioLabelPosition labelPosition;

  // 间距
  final double spacing;

  const NutRadioGroup({
    super.key,
    required this.items,
    required this.value,
    this.onChanged,
    this.direction = NutRadioDirection.vertical,
    this.activeColor = NutUIColors.primary,
    this.labelPosition = NutRadioLabelPosition.right,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction == NutRadioDirection.horizontal
          ? Axis.horizontal
          : Axis.vertical,
      spacing: direction == NutRadioDirection.horizontal ? spacing : 0,
      runSpacing: direction == NutRadioDirection.vertical ? spacing : 0,
      children: items.map((item) {
        return NutRadio<T>(
          value: item.value,
          groupValue: value,
          text: item.label,
          disabled: item.disabled,
          activeColor: activeColor,
          labelPosition: labelPosition,
          onChanged: onChanged,
        );
      }).toList(),
    );
  }
}