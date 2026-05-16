import 'package:flutter/material.dart';
import '../icon/icon.dart';

class NutBackTop extends StatefulWidget {
  // 滚动控制器 (必须与被监听的 ListView/ScrollView 使用同一个)
  final ScrollController scrollController;

  // 滚动多少距离后显示按钮 (默认 200)
  final double visibilityHeight;

  // 距离右边的距离
  final double right;

  // 距离底部的距离
  final double bottom;

  // 按钮宽度
  final double width;

  // 按钮高度
  final double height;

  // 点击回调 (一般不需要覆盖，默认会滚动到顶部)
  final VoidCallback? onClick;

  // 自定义图标
  final Widget? icon;

  // 自定义文字（优先级低于 child）
  final String? text;

  // 完全自定义按钮内容
  final Widget? child;

  const NutBackTop({
    super.key,
    required this.scrollController,
    this.visibilityHeight = 200,
    this.right = 20,
    this.bottom = 40,
    this.width = 44,
    this.height = 44,
    this.onClick,
    this.icon,
    this.text,
    this.child,
  });

  @override
  State<NutBackTop> createState() => _NutBackTopState();
}

class _NutBackTopState extends State<NutBackTop> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
    // 初始化时检查一次位置 (防止初始化时已经在页面中间)
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollListener());
  }

  @override
  void didUpdateWidget(covariant NutBackTop oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果控制器发生了改变，需要重新绑定监听
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_scrollListener);
      widget.scrollController.addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  // 监听滚动位置
  void _scrollListener() {
    if (!widget.scrollController.hasClients) return;

    final shouldShow = widget.scrollController.offset >= widget.visibilityHeight;
    if (shouldShow != _isVisible) {
      setState(() {
        _isVisible = shouldShow;
      });
    }
  }

  // 点击滚动到顶部
  void _handleTap() {
    if (widget.onClick != null) {
      widget.onClick!();
      return;
    }
    // 平滑滚动到顶部，时长 300ms
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      // 占满全屏，但不阻挡下层手势
      child: IgnorePointer(
        ignoring: !_isVisible, // 隐藏时忽略点击，显示时接收点击
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(
              right: widget.right,
              bottom: widget.bottom,
            ),
            // 淡入淡出 + 缩放动画
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: AnimatedScale(
                scale: _isVisible ? 1.0 : 0.6,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: GestureDetector(
                  onTap: _handleTap,
                  child: _buildContent(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 构建按钮内容
  Widget _buildContent() {
    // 完全自定义
    if (widget.child != null) {
      return widget.child!;
    }

    // 默认样式：圆形白底阴影
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.icon ??
            const NutIcon(icon: NutIcons.top, size: 18, color: Color(0xFF1A1A1A)),
          if (widget.text != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                widget.text!,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF1A1A1A),
                  height: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}