import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../icon/icon.dart';

// 复选框形状
enum NutCheckboxShape {
  square,
  round,
}

// 文本位置
enum NutCheckboxLabelPosition {
  left,
  right,
}

class NutCheckbox extends StatefulWidget {
  // 是否选中
  final bool value;

  // 状态改变回调
  final ValueChanged<bool>? onChanged;

  // 是否半选
  final bool indeterminate;

  // 是否禁用
  final bool disabled;

  // 形状
  final NutCheckboxShape shape;

  // 文本位置
  final NutCheckboxLabelPosition labelPosition;

  // 选中颜色
  final Color activeColor;

  // 图标大小
  final double iconSize;

  // 文本
  final String? text;

  // 自定义子组件(优先级高于 text)
  final Widget? child;

  const NutCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.indeterminate = false,
    this.disabled = false,
    this.shape = NutCheckboxShape.square,
    this.labelPosition = NutCheckboxLabelPosition.right,
    this.activeColor = NutUIColors.primary,
    this.iconSize = 20,
    this.text,
    this.child,
  });

  @override
  State<NutCheckbox> createState() => _NutCheckboxState();
}

class _NutCheckboxState extends State<NutCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.disabled ? null : () => widget.onChanged?.call(!widget.value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 文本在左侧
          if (widget.labelPosition == NutCheckboxLabelPosition.left)
            _buildLabel(),
          if (widget.labelPosition == NutCheckboxLabelPosition.left)
            const SizedBox(width: 8),
          
          // 图标
          _buildIcon(),
          
          // 文本在右侧
          if (widget.labelPosition == NutCheckboxLabelPosition.right)
            const SizedBox(width: 8),
          if (widget.labelPosition == NutCheckboxLabelPosition.right)
            _buildLabel(),
        ],
      ),
    );
  }
  
  // 构建图标
  Widget _buildIcon() {
    // 判断状态
    final isActive = widget.value;
    final isIndeterminate = widget.indeterminate;
    final isDisabled = widget.disabled;
    
    // 背景色与边框色逻辑
    Color bgColor;
    Color borderColor;
    if (isDisabled) {
      bgColor = isActive || isIndeterminate ? NutUIColors.disabledBg : Colors.transparent;
      borderColor = NutUIColors.border;
    } else if (isActive || isIndeterminate) {
      bgColor = widget.activeColor;
      borderColor = widget.activeColor;
    } else {
      bgColor = Colors.transparent;
      borderColor = NutUIColors.border;
    }
    
    // 图标颜色
    Color iconColor = isDisabled ? NutUIColors.disabledText : Colors.white;
    
    // 图标内容
    Widget iconChild;
    if (isIndeterminate) {
      // 半选：横线
      iconChild = NutIcon(icon: NutIcons.minus, size: widget.iconSize * 0.7, color: iconColor);
    } else if (isActive) {
      // 全选：勾
      iconChild = NutIcon(icon: NutIcons.checkChecked, size: widget.iconSize * 0.7, color: iconColor);
    } else {
      iconChild = const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: widget.iconSize,
      height: widget.iconSize,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(
          widget.shape == NutCheckboxShape.round ? widget.iconSize / 2 : 4,
        ),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Center(child: iconChild),
    );
  }

  // 构建文本
  Widget _buildLabel() {
    if (widget.child != null) {
      return DefaultTextStyle(
        style: TextStyle(
          fontSize: 14,
          color: widget.disabled ? NutUIColors.disabledText : NutUIColors.text,
        ),
        child: widget.child!,
      );
    }

    if (widget.text != null) {
      return Text(
        widget.text!,
        style: TextStyle(
          fontSize: 14,
          color: widget.disabled ? NutUIColors.disabledText : NutUIColors.text,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// 复选框组
class NutCheckboxGroup extends StatelessWidget {
  // 所有选项
  final List<String> options;

  // 当前选中的值列表
  final List<String> value;

  // 选中状态变化回调
  final ValueChanged<List<String>>? onChanged;

  // 最大可选数
  final int? max;

  // 形状
  final NutCheckboxShape shape;

  // 是否禁用所有
  final bool disabled;

  // 排列方向
  final Axis direction;

  // 间距
  final double spacing;

  const NutCheckboxGroup({
    super.key,
    required this.options,
    required this.value,
    this.onChanged,
    this.max,
    this.shape = NutCheckboxShape.square,
    this.disabled = false,
    this.direction = Axis.vertical,
    this.spacing = 12,
  });

  void _handleChange(String option, bool isChecked) {
    final newValue = List<String>.from(value);
    if (isChecked) {
      if (max != null && newValue.length >= max!) return; // 达到上限
      newValue.add(option);
    } else {
      newValue.remove(option);
    }
    onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      spacing: direction == Axis.horizontal ? spacing : 0,
      runSpacing: direction == Axis.vertical ? spacing : 0,
      children: options.map((option) {
        final isChecked = value.contains(option);
        // 达到最大限制，且当前项未被选中时，禁用该项
        final isMaxLimited = max != null && value.length >= max! && !isChecked;

        return NutCheckbox(
          text: option,
          value: isChecked,
          disabled: disabled || isMaxLimited,
          shape: shape,
          onChanged: (val) => _handleChange(option, val),
        );
      }).toList(),
    );
  }
}