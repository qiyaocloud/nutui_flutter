import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutui_flutter/nutui_flutter.dart';
import 'package:nutui_flutter/theme/colors.dart';

class NutInputNumber extends StatefulWidget {
  // 当前值
  final num value;

  // 值改变回调
  final ValueChanged<num>? onChanged;

  // 最小值
  final num min;

  // 最大值
  final num max;

  // 步长
  final num step;

  // 小数位精度
  final int deciamlLength;

  // 是否禁用整个组件
  final bool disabled;

  // 是否禁用输入框
  final bool disabledInput;

  // 输入框宽度
  final double inputWidth;

  // 按钮大小 (宽度与高度相等)
  final double buttonSize;

  const NutInputNumber({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 1,
    this.max = 9999,
    this.step = 1,
    this.deciamlLength = 0,
    this.disabled = false,
    this.disabledInput = false,
    this.inputWidth = 36,
    this.buttonSize = 28,
  });

  @override
  State<NutInputNumber> createState() => _NutInputNumberState();
}

class _NutInputNumberState extends State<NutInputNumber> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  // 长按相关
  Timer? _longPressTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatValue(widget.value));
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant NutInputNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 外部值变化时同步更新输入框 (仅在不聚焦时，防止输入卡顿)
    if (widget.value != oldWidget.value && !_focusNode.hasFocus) {
      _controller.text = _formatValue(widget.value);
    }
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  // 格式化数值 (保留小数位)
  String _formatValue(num val) {
    if (widget.deciamlLength > 0) {
      return val.toStringAsFixed(widget.deciamlLength);
    }
    return val.toInt().toString();
  }

  // 钳制数值在 min 和 max 之间，并发出变更
  void _clampAndEmit(num val) {
    num clampedVal = val.clamp(widget.min, widget.max);
    if (widget.deciamlLength > 0) {
      clampedVal = clampedVal.toDouble();
    } else {
      clampedVal = clampedVal.toInt();
    }

    if (clampedVal != widget.value) {
      widget.onChanged?.call(clampedVal);
    }
    // 即使值没变，失焦时也要强制刷新显示格式 (例如输入 1.10 -> 1.1)
    _controller.text = _formatValue(clampedVal);
  }

  // 输入框焦点改变处理 (失焦时校验)
  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      final num? parsed = num.tryParse(_controller.text);
      if (parsed != null) {
        _clampAndEmit(parsed);
      } else {
        // 输入了非法字符，恢复上一次的值
        _controller.text = _formatValue(widget.value);
      }
    }
  }
  
  // 增加
  void _increase() => _clampAndEmit(widget.value + widget.step);
  
  // 减少
  void _decrease() => _clampAndEmit(widget.value - widget.step);
  
  // 开始长按
  void _startLongPress(VoidCallback action) {
    // 立即执行一次
    action();
    
    // 延迟启动长按定时器
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _longPressTimer?.cancel();
      _longPressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        action();
      });
    });
  }

  // 结束长按
  void _stopLongPress() {
    _longPressTimer?.cancel();
    _longPressTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMinusDisabled = widget.disabled || widget.value <= widget.min;
    final bool isPlusDisabled = widget.disabled || widget.value >= widget.max;

    return Container(
      height: widget.buttonSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: widget.disabled ? Colors.transparent : NutUIColors.border),
        color: widget.disabled ? NutUIColors.disabled : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 减号按钮
          _buildButton(
            icon: NutIcons.minus,
            isDisabled: isMinusDisabled,
            onTap: isMinusDisabled ? null : _decrease,
            onLongPressStart: isMinusDisabled ? null : () => _startLongPress(_decrease),
            onLongPressEnd: isMinusDisabled ? null : (_) => _stopLongPress(),
          ),

          // 输入框
          _buildInput(isMinusDisabled, isPlusDisabled),

          // 加号按钮
          _buildButton(
            icon: NutIcons.add,
            isDisabled: isPlusDisabled,
            onTap: isPlusDisabled ? null : _increase,
            onLongPressStart: isPlusDisabled ? null : () => _startLongPress(_increase),
            onLongPressEnd: isPlusDisabled ? null : (_) => _stopLongPress(),
          ),
        ],
      ),
    );
  }

  // 构建左右按钮
  Widget _buildButton({
    required IconData icon,
    required bool isDisabled,
    required VoidCallback? onTap,
    required VoidCallback? onLongPressStart,
    required GestureLongPressEndCallback? onLongPressEnd,
  }) {
    Color iconColor = isDisabled ? NutUIColors.disabledText : NutUIColors.text;

    return GestureDetector(
      onTap: onTap,
      onLongPressStart: onLongPressStart != null ? (_) => onLongPressStart() : null,
      onLongPressEnd: onLongPressEnd,
      child: Container(
        width: widget.buttonSize,
        height: widget.buttonSize,
        alignment: Alignment.center,
        color: isDisabled ? NutUIColors.disabled : NutUIColors.white,
        child: NutIcon(icon: icon, size: 16, color: iconColor),
      ),
    );
  }

  // 构建输入框
  Widget _buildInput(bool isMinusDisabled, bool isPlusDisabled) {
    // 当减号或加号被禁用时，其边框颜色变灰
    final Color leftBorderColor = isMinusDisabled ? NutUIColors.disabled : NutUIColors.border;
    final Color rightBorderColor = isPlusDisabled ? NutUIColors.disabled : NutUIColors.border;

    return Container(
      width: widget.inputWidth,
      height: widget.buttonSize,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: leftBorderColor, width: 0.5),
          right: BorderSide(color: rightBorderColor, width: 0.5),
        ),
        color: widget.disabled ? NutUIColors.disabled : NutUIColors.white,
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: !widget.disabled && !widget.disabledInput,
        style: TextStyle(
          fontSize: 14,
          color: widget.disabled ? NutUIColors.disabledText : NutUIColors.text,
        ),
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
        // 限制只能输入数字和小数点
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        onSubmitted: (val) {
          final num? parsed = num.tryParse(val);
          if (parsed != null) {
            _clampAndEmit(parsed);
          } else {
            _controller.text = _formatValue(widget.value);
          }
        },
      ),
    );
  }
}