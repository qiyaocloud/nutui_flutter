import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class NutSkeleton extends StatefulWidget {
  final bool loading;
  final Widget child;
  final bool animate;
  final Color baseColor;
  final Color highlightColor;

  // 默认布局快捷属性
  final bool avatar;
  final double avatarSize;
  final bool title;
  final double titleWidth;
  final int row;
  final double lastRowWidth;

  // 自定义骨架布局 (设置后默认布局失效)
  final Widget? skeleton;

  const NutSkeleton({
    super.key,
    this.loading = true,
    required this.child,
    this.animate = true,
    this.baseColor = NutUIColors.shimmerBase,
    this.highlightColor = NutUIColors.shimmerHeighLight,
    this.avatar = false,
    this.avatarSize = 32,
    this.title = true,
    this.titleWidth = 0.4,
    this.row = 2,
    this.lastRowWidth = 0.6,
    this.skeleton,
  });

  @override
  State<NutSkeleton> createState() => _NutSkeletonState();
}

class _NutSkeletonState extends State<NutSkeleton>
  with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.loading && widget.animate) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant NutSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loading && widget.animate) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.loading) return widget.child;

    Widget skeletonContent = widget.skeleton ?? _buildDefaultSkeleton();

    if (widget.animate) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [
                  widget.baseColor,
                  widget.highlightColor,
                  widget.baseColor,
                ],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment(-1.0 + _controller.value * 3.0, 0.0),
                end: Alignment(0.0 + _controller.value * 3.0, 0.0),
              ).createShader(bounds);
            },
            child: child,
          );
        },
        child: skeletonContent,
      );
    }

    return skeletonContent;
  }

  Widget _buildDefaultSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NutSkeletonRect(width: widget.titleWidth, height: 16),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.avatar)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: NutSkeletonAvatar(size: widget.avatarSize),
              ),
            Expanded(
              child: Column(
                children: List.generate(widget.row, (index) {
                  bool isLast = index == widget.row - 1 && widget.row > 1;
                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
                    child: NutSkeletonRect(
                      width: isLast ? widget.lastRowWidth : 1.0,
                      height: 14,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// 矩形占位 (width 0.0~1.0 为比例，>1 为固定像素)
class NutSkeletonRect extends StatelessWidget {
  final double width;
  final double height;
  final Radius borderRadius;

  const NutSkeletonRect({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const Radius.circular(2),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double actualWidth = width > 1 ? width : constraints.maxWidth * width;
      return Container(
        width: actualWidth,
        height: height,
        decoration: BoxDecoration(
          color: NutUIColors.bgGray,
          borderRadius: BorderRadius.all(borderRadius),
        ),
      );
    });
  }
}

// 圆形占位（头像）
class NutSkeletonAvatar extends StatelessWidget {
  final double size;
  const NutSkeletonAvatar({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: NutUIColors.bgGray, shape: BoxShape.circle),
    );
  }
}