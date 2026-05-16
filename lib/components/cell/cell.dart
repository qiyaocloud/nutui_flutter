import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../icon/icon.dart';

// 单元格尺寸
enum NutCellSize {
  normal,
  large
}

class NutCellGroup extends StatelessWidget {
  final String? title;
  final String? desc;
  final List<Widget> children;
  final bool inset; // 是否展示为圆角卡片

  const NutCellGroup({
    super.key,
    this.title,
    this.desc,
    this.inset = false,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsetsGeometry.fromLTRB(16, 16, 16, 8),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 14,
                color: NutUIColors.textSecondary,
              ),
            ),
          ),
        if (inset)
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(12),
            child: Column(children: children),
          )
        else
          Column(children: children),
        if (desc != null)
          Padding(
            padding: const EdgeInsetsGeometry.fromLTRB(16, 8, 16, 16),
            child: Text(
              desc!,
              style: const TextStyle(
                fontSize: 12,
                color: NutUIColors.textSecondary,
              ),
            ),
          ),
      ],
    );

    // 如果是 inset，整个 Group 需要左右留出边距
    if (inset) {
      return Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
        child: body,
      );
    }

    return body;
  }
}

class NutCell extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final String? value;
  final String? lable;
  final IconData? icon;
  final IconData? rightIcon;
  final bool isLink;
  final bool required;
  final bool center;
  final NutCellSize size;
  final bool clickable;
  final VoidCallback? onTap;
  final Widget? titleWidget;
  final Widget? valueWidget;

  const NutCell({
    super.key,
    this.title,
    this.subTitle,
    this.value,
    this.lable,
    this.icon,
    this.rightIcon,
    this.isLink = false,
    this.required = false,
    this.center = false,
    this.size = NutCellSize.normal,
    this.clickable = false,
    this.onTap,
    this.titleWidget,
    this.valueWidget,
  });

  @override
  State<NutCell> createState() => _NutCellState();
}

class _NutCellState extends State<NutCell> {
  bool _isPressed = false;

  bool get _isEffectiveClickable =>
      widget.onTap != null || widget.isLink || widget.clickable;

  void _handleTapDown(TapDownDetails details) {
    if (_isEffectiveClickable) setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isEffectiveClickable) setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (_isEffectiveClickable) setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final isLarge = widget.size == NutCellSize.large;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: _isPressed ? NutUIColors.pressed : NutUIColors.white,
        padding: EdgeInsetsGeometry.symmetric(
          vertical: isLarge ? 16 : 13,
          horizontal: 16,
        ),
        child: Row(
          crossAxisAlignment: widget.center
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            // 左侧自定义 Icon
            if (widget.icon != null)
              Padding(
                padding: const EdgeInsetsGeometry.only(right: 12),
                child: NutIcon(icon: widget.icon!, size: 20, color: NutUIColors.text),
              ),
            // 标题区域
            _buildTitleArea(),
            const SizedBox(width: 12),
            // 右侧内容区域
            _buildValueArea(),
            // 右侧箭头/自定义图标
            if (widget.isLink || widget.rightIcon != null)
              _buildRightIcon(),
          ],
        ),
      ),
    );
  }

  // 构建左侧标题区域
  Widget _buildTitleArea() {
    if (widget.titleWidget != null) {
      return widget.titleWidget!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.required)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Text('*', style: TextStyle(color: NutUIColors.required, fontSize: 14)),
              ),
            if (widget.title != null)
              Text(
                widget.title!,
                style: const TextStyle(fontSize: 14, color: NutUIColors.text),
              ),
          ],
        ),
        if (widget.subTitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.subTitle!,
              style: const TextStyle(fontSize: 10, color: NutUIColors.textSecondary),
            ),
          ),
      ],
    );
  }

  // 构建右侧内容区域
  Widget _buildValueArea() {
    if (widget.valueWidget != null) {
      return Expanded(child: widget.valueWidget!);
    }

    if (widget.value == null && widget.lable == null) {
      return const Expanded(child: SizedBox.shrink());
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.value != null)
            Text(
              widget.value!,
              style: const TextStyle(fontSize: 14, color: NutUIColors.textSecondary),
            ),
          if (widget.lable != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.lable!,
                style: const TextStyle(fontSize: 10, color: NutUIColors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }

  // 构建最右侧图标
  Widget _buildRightIcon() {
    IconData? iconData = widget.rightIcon ?? (widget.isLink ? Icons.arrow_forward_ios : null);

    if (iconData == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: NutIcon(icon: iconData, size: 14, color: NutUIColors.textSecondary),
    );
  }
}

// 辅助组件：带有分割线的 Cell
class NutCellWithBorder extends StatelessWidget {
  final NutCell cell;
  final bool isLast;

  const NutCellWithBorder({
    super.key,
    required this.cell,
    this.isLast = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        cell,
        if (!isLast)
          const Padding(
            padding: EdgeInsets.only(left: 16), // NutUI 标准的左侧留白分割线
            child: Divider(height: 0.5, thickness: 0.5, color: NutUIColors.border),
          ),
      ],
    );
  }
}