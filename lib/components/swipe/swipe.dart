import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class NutSwipeAction {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  NutSwipeAction({
    required this.text,
    this.color = NutUIColors.primary,
    this.textColor = NutUIColors.white,
    required this.onTap,
  });
}

// 滑动单元格
class NutSwipe extends StatefulWidget {
  final Widget child;
  final List<NutSwipeAction> leftActions;
  final List<NutSwipeAction> rightActions;

  // 滑动阈值，滑动超过此距离松手才会自动打开，否则回弹
  final double threshold;

  const NutSwipe({
    super.key,
    required this.child,
    this.leftActions = const [],
    this.rightActions = const [],
    this.threshold = 0.4, // 占操作区总宽度的比例
  });

  @override
  State<NutSwipe> createState() => NutSwipeState();
}

class NutSwipeState extends State<NutSwipe> with SingleTickerProviderStateMixin {
  double _offsetX = 0.0;
  double _leftWidth = 0.0;
  double _rightWidth = 0.0;

  late AnimationController _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300)
    );
    _controller.addListener(() {
      if (_animation != null) {
        setState(() {
          _offsetX = _animation!.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 关闭（回弹到中心）
  void close() {
    _animationTo(0.0);
  }

  void _animationTo(double targetOffset) {
    _animation = Tween<double>(begin: _offsetX, end: targetOffset).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward(from: 0.0);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offsetX += details.delta.dx;

      // 滑动阈值，滑动超过此距离松手才会自动打开，否则回弹
      if (_offsetX > 0 && _leftWidth > 0) {
        if (_offsetX > _leftWidth) {
          _offsetX = _leftWidth + ((_offsetX - _leftWidth) * 0.2); // 阻尼系数
        }
      } else if (_offsetX < 0 && _rightWidth > 0) {
        if (-_offsetX > _rightWidth) {
          _offsetX = -(_rightWidth + ((-_offsetX - _rightWidth) * 0.2));
        }
      }

      // 没有对应方向的操作按钮时，直接归零并阻断
      if (_offsetX > 0 && _leftWidth == 0) _offsetX = 0;
      if (_offsetX < 0 && _rightWidth == 0) _offsetX = 0;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    double targetOffset = 0.0;

    if (_offsetX > 0 && _leftWidth > 0) {
      // 向右滑 （打开左侧）
      targetOffset = (_offsetX > _leftWidth * widget.threshold) ? _leftWidth : 0.0;
    } else if (_offsetX < 0 && _rightWidth > 0) {
      // 向左滑（打开右侧）
      targetOffset = (-_offsetX > _rightWidth * widget.threshold) ? -_rightWidth : 0.0;
    }
    
    // 快速滑动判定
    double velocity = details.primaryVelocity ?? 0.0;
    if (velocity <-300 && _rightWidth > 0) {
      targetOffset = -_rightWidth;
    } else if (velocity > 300 && _leftWidth > 0) {
      targetOffset = _leftWidth;
    }
    
    _animationTo(targetOffset);
  }
  
  void _handleActionTap(NutSwipeAction action) {
    action.onTap();
    close(); // 点击按钮后自动收回
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 底层：左右操作区
        Row(
          children: [
            // 左侧操作区
            if (widget.leftActions.isNotEmpty)
              LayoutBuilder(
                builder: (context, constraints) {
                  return _buildActions(
                    actions: widget.leftActions,
                    onLayout: (width) => _leftWidth = width,
                  );
                },
              ),
            const Spacer(),
            // 右侧操作区
            if (widget.rightActions.isNotEmpty)
              LayoutBuilder(
                builder: (context, constraints) {
                  return _buildActions(
                    actions: widget.rightActions,
                    onLayout: (width) => _rightWidth = width,
                  );
                },
              ),
          ],
        ),
        
        // 顶层：主内容（跟随滑动偏移）
        GestureDetector(
          onHorizontalDragUpdate: _handleDragUpdate,
          onHorizontalDragEnd: _handleDragEnd,
          child: Transform.translate(
            offset: Offset(_offsetX, 0),
            child: Row(
              children: [
                Expanded(child: widget.child),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  // 构建操作按钮组
  Widget _buildActions({
    required List<NutSwipeAction> actions,
    required ValueChanged<double> onLayout,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 通过 postFrameCallback 获取实际渲染宽度
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null && renderBox.hasSize) {
            onLayout(renderBox.size.width);
          }
        });
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: Row(
              children: actions.map((action) {
                return GestureDetector(
                  onTap: () => _handleActionTap(action),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: action.color,
                    child: Text(action.text, style: TextStyle(color: action.textColor, fontSize: 14)),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}