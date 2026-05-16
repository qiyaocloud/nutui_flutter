import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutui_flutter/theme/colors.dart';

class NutTextArea extends StatefulWidget {
  // 当前输入的值
  final String? value;

  // 控制器 (与 value 互斥，优先使用 controller)
  final TextEditingController? controller;

  // 占位提示文字
  final String? placeholder;

  // 最大字符数 (-1 表示不限制)
  final int maxLength;

  // 是否显示字数统计
  final bool showWordLimit;

  // 是否禁用
  final bool disabled;

  // 是否只读
  final bool readOnly;

  // 自动聚焦
  final bool autofocus;

  // 最小高度
  final double minHeight;

  // 最大高度（超过此高度内部滚动）
  final double maxHeight;

  // 文字改变回调
  final ValueChanged<String>? onChanged;

  const NutTextArea({
    super.key,
    this.value,
    this.controller,
    this.placeholder,
    this.maxLength = -1,
    this.showWordLimit = false,
    this.disabled = false,
    this.readOnly = false,
    this.autofocus = false,
    this.minHeight = 80,
    this.maxHeight = 150,
    this.onChanged,
  });

  @override
  State<NutTextArea> createState() => _NutTextAreaState();
}

class _NutTextAreaState extends State<NutTextArea> {
  late TextEditingController _controller;
  bool _isInternalController = false;
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _initController();
    _currentLength = _controller.text.length;
    _controller.addListener(_handleTextChange);
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _isInternalController = false;
    } else {
      _controller = TextEditingController(text: widget.value ?? '');
      _isInternalController = true;
    }
  }

  @override
  void didUpdateWidget(covariant NutTextArea oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 同步外部 value 变化 (仅限内部控制器时)
    if (_isInternalController && widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }

    // 外部控制器更换
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_handleTextChange);
      if (_isInternalController) _controller.dispose();

      _initController();
      _currentLength = _controller.text.length;
      _controller.addListener(_handleTextChange);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    if (_isInternalController) _controller.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    if (!mounted) return;
    setState(() {
      _currentLength = _controller.text.length;
    });
    widget.onChanged?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: widget.minHeight,
        maxHeight: widget.maxHeight + (widget.showWordLimit ? 20 : 0), // 统计栏高度预留
      ),
      decoration: BoxDecoration(
        color: widget.disabled ? NutUIColors.disabledBg : NutUIColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: NutUIColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 输入区域
          Flexible(child: _buildTextField()),

          // 字数统计
          if (widget.showWordLimit) _buildWordLimit(),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    // 字数限制拦截器
    List<TextInputFormatter> formatters = [];
    if (widget.maxLength > 0) {
      formatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
    }

    return TextField(
      controller: _controller,
      enabled: !widget.disabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      maxLines: null, // 允许无限行，自适应高度
      minLines: 1,
      scrollPhysics: const ClampingScrollPhysics(), // 超出最大高度时滚动
      style: TextStyle(
        fontSize: 14,
        color: widget.disabled ? NutUIColors.disabledText : NutUIColors.text,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        hintText: widget.placeholder,
        hintStyle: const TextStyle(fontSize: 14, color: NutUIColors.textSecondary),
      ),
      inputFormatters: formatters,
    );
  }

  Widget _buildWordLimit() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        '$_currentLength/${widget.maxLength}',
        style: TextStyle(
          fontSize: 12,
          // 超出字数变红提示 (如果没使用 LengthLimitingTextInputFormatter)
          color: (_currentLength > widget.maxLength && widget.maxLength > 0)
            ? const Color(0xFFFA2C19)
            : NutUIColors.textSecondary,
        ),
      ),
    );
  }
}