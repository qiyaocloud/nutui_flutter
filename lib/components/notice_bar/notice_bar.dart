import 'package:flutter/material.dart';
import 'package:nutui_flutter/components/icon/icon.dart';

import '../../theme/colors.dart';

class NutNoticeBar extends StatefulWidget {
  // 公告文本
  final String text;

  // 左侧图标
  final Widget? leftIcon;

  // 右侧图标 (优先级高于 closeable 和 link)
  final Widget? rightIcon;

  // 是否可关闭
  final bool closeable;

  // 是否开启文本滚动 (文本超出时自动生效)
  final bool scrollable;

  // 是否开启文本换行 (开启后 scrollable 失效)
  final bool wrapable;

  // 文字颜色
  final Color color;

  // 背景颜色
  final Color background;

  // 滚动速度（px/s）
  final double speed;

  // 滚动时的间距 (首尾相接的空白距离)
  final double scrollGap;

  // 点击整个公告栏的回调
  final VoidCallback? onClick;

  // 点击关闭图标的回调
  final VoidCallback? onClose;

  const NutNoticeBar({
    super.key,
    required this.text,
    this.leftIcon,
    this.rightIcon,
    this.closeable = false,
    this.scrollable = false,
    this.wrapable = false,
    this.color = NutUIColors.noticeDefaultColor,
    this.background = NutUIColors.noticeDefaultBg,
    this.speed = 50.0,
    this.scrollGap = 40.0,
    this.onClick,
    this.onClose,
  });

  @override
  State<NutNoticeBar> createState() => _NutNoticeBarState();
}

class _NutNoticeBarState extends State<NutNoticeBar>
  with SingleTickerProviderStateMixin {
  bool _closed = false;

  // 滚动相关
  late AnimationController _controller;
  double _textWidth = 0;
  double _containerWidth = 0;
  bool _shouldScroll = false;
  bool _isScrollInit = false;

  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant NutNoticeBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.scrollable != widget.scrollable) {
      _isScrollInit = false; // 需要重新测量和初始化动画
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 测量并初始化滚动动画
  void _initScrollIfNeeded() {
    if (_isScrollInit || !widget.scrollable || widget.wrapable) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // 获取文本实际渲染宽度
      final RenderBox? textBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
      if (textBox == null) return;
      _textWidth = textBox.size.width;

      // 判断是否需要滚动
      if (_textWidth > _containerWidth) {
        _shouldScroll = true;

        // 计算动画时长 (距离 / 速度)
        double distance = _textWidth + widget.scrollGap;
        int durationMs = (distance / widget.speed * 1000).round();

        _controller.duration = Duration(milliseconds: durationMs);

        // 配置动画并开始
        _controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            // 循环结束后停顿 1 秒，然后重新开始
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) _controller.forward(from: 0.0);
            });
          }
        });

        // 初始延迟 1 秒后开始滚动
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) _controller.forward();
        });
      } else {
        _shouldScroll = false;
      }

      _isScrollInit = true;
      setState(() {}); // 刷新UI以显示滚动
    });
  }

  void _handleClose() {
    widget.onClose?.call();
    setState(() => _closed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_closed) return const SizedBox.shrink();

    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        height: widget.wrapable ? null : 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: widget.background,
        child: Row(
          children: [
            // 左侧图标
            if (widget.leftIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconTheme(
                  data: IconThemeData(color: widget.color, size: 16),
                  child: widget.leftIcon!,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: NutIcon(icon: NutIcons.notice, color: widget.color, size: 16),
              ),

            // 中间内容区
            Expanded(
              child: _buildContent(),
            ),

            // 右侧图标
            if (widget.rightIcon != null)
              _buildRightIcon(widget.rightIcon!)
            else if (widget.closeable)
              _buildRightIcon(GestureDetector(
                onTap: _handleClose,
                child: NutIcon(icon: NutIcons.close, color: widget.color, size: 16),
              ))
            else if (widget.onClick != null)
              _buildRightIcon(NutIcon(icon: NutIcons.arrowRight, color: widget.color, size: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildRightIcon(Widget child) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: child,
    );
  }

  // 构建中间文本内容
  Widget _buildContent() {
    TextStyle textStyle = TextStyle(color: widget.color, fontSize: 14, height: 1.2);

    // 模式 1：多行换行
    if (widget.wrapable) {
      return Text(widget.text, style: textStyle);
    }

    // 模式 2：单行截断 (非滚动 或 还未测量出宽度)
    if (!widget.scrollable || !_shouldScroll) {
      return LayoutBuilder(
        builder: (context, constraints) {
          _containerWidth = constraints.maxWidth;
          _initScrollIfNeeded();

          return Text(
            widget.text,
            key: _textKey,
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      );
    }

    // 模式 3：滚动跑马灯
    return ClipRect(
      child: OverflowBox(
        maxWidth: double.infinity,
        alignment: Alignment.centerLeft,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(-_controller.value * (_textWidth + widget.scrollGap), 0),
              child: child,
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.text, key: _textKey, style: textStyle),
              SizedBox(width: widget.scrollGap), // 首尾间距
              Text(widget.text, style: textStyle), // 拼接的第二份文本，用于无缝衔接
            ],
          ),
        ),
      ),
    );
  }
}