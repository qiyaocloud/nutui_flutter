import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../icon/icon.dart';

// 搜索框形状
enum NutSearchBarShape {
  round,
  square
}

class NutSearchBar extends StatefulWidget {
  // 控制器（用于外部获取/设置输入内容）
  final TextEditingController? controller;

  // 占位提示文字
  final String? placeholder;

  // 搜索框形状
  final NutSearchBarShape shape;

  // 搜索框背景色
  final Color backgroundColor;

  // 输入文字颜色
  final Color textColor;

  // 提示文字颜色
  final Color placeholderColor;

  // 最大行数
  final int maxLines;

  // 最大长度
  final int? maxLength;

  // 右侧搜索按钮文字 (为 null 则不显示按钮)
  final String? actionText;

  // 搜索按钮颜色
  final Color actionColor;

  // 输入改变回调
  final ValueChanged<String>? onChanged;

  // 点击搜索/键盘回车回调
  final ValueChanged<String>? onSearch;

  // 点击清除回调
  final VoidCallback? onClear;

  // 点击输入框回调 (常用于跳转搜索页，设置此属性会禁用输入)
  final VoidCallback? onTap;

  const NutSearchBar({
    super.key,
    this.controller,
    this.placeholder = '请输入搜索内容',
    this.shape = NutSearchBarShape.round,
    this.backgroundColor = NutUIColors.bgGray,
    this.textColor = NutUIColors.text,
    this.placeholderColor = NutUIColors.textSecondary,
    this.maxLines = 1,
    this.maxLength,
    this.actionText,
    this.actionColor = NutUIColors.primary,
    this.onChanged,
    this.onSearch,
    this.onClear,
    this.onTap,
  });

  @override
  State<NutSearchBar> createState() => _NutSearchBarState();
}

class _NutSearchBarState extends State<NutSearchBar> {
  TextEditingController? _internalController;
  bool _hasText = false;
  FocusNode? _focusNode;

  TextEditingController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    // 如果没有传入控制器，创建内部控制器
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChange);

    // 如果设置了 onTap，通常需要自动失去焦点，防止弹出键盘
    if (widget.onTap != null) {
      _focusNode = FocusNode(canRequestFocus: false);
    }
  }

  @override
  void didUpdateWidget(covariant NutSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleTextChange);
      if (widget.controller != null) {
        _internalController?.dispose();
        _internalController = null;
      } else {
        _internalController = TextEditingController();
        _handleTextChange(); // 初始化同步状态
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _internalController?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  // 监听文本变化，控制清除按钮的显隐
  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  // 触发搜索
  void _handleSearch() {
    // 收起键盘
    FocusScope.of(context).unfocus();
    widget.onSearch?.call(_controller.text);
  }

  // 清除内容
  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
    // 自动获取焦点方便重新输入
    if (widget.onTap == null) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          // 输入框区域
          Expanded(child: _buildInputField()),
          // 右侧搜索按钮（可选）
          if (widget.actionText != null) _buildActionButton(),
        ],
      ),
    );
  }

  // 构建输入框
  Widget _buildInputField() {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(
          widget.shape == NutSearchBarShape.round ? 18 : 4,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // 搜索图标
          NutIcon(icon: NutIcons.search, size: 18, color: widget.placeholderColor),
          const SizedBox(width: 6),
          // 输入框
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: TextStyle(fontSize: 14, color: widget.textColor),
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              // 隐藏原生字符计数
              decoration: InputDecoration(
                counterText: '',
                isDense: true,
                contentPadding: const EdgeInsets.only(bottom: 4), // 视觉居中微调
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: widget.placeholder,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: widget.placeholderColor,
                ),
              ),
              // 键盘回车触发搜索
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _handleSearch(),
              // 设置了 onTap 后，禁用输入，只响应点击
              onTap: widget.onTap,
              readOnly: widget.onTap != null,
            ),
          ),
          // 清除按钮（带动画）
          _buildClearButton(),
        ],
      ),
    );
  }

  // 构建清除按钮
  Widget _buildClearButton() {
    return GestureDetector(
      onTap: _handleClear,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        alignment: Alignment.centerRight,
        child: SizedBox(
          // 有文字时宽度24，无文字时宽度0，实现平滑缩放
          width: _hasText ? 24 : 0,
          height: 24,
          child: Center(
            child: NutIcon(icon: NutIcons.close, size: 16, color: widget.placeholderColor),
          ),
        ),
      ),
    );
  }

  // 构建右侧搜索按钮
  Widget _buildActionButton() {
    return GestureDetector(
      onTap: _handleSearch,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Center(
          child: Text(
            widget.actionText!,
            style: TextStyle(
              fontSize: 14,
              color: widget.actionColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}