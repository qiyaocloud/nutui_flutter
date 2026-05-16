import 'package:flutter/material.dart';

enum NutPopupPosition {
  top,
  bottom,
  left,
  right,
  center,
}

class NutPopup {
  // 显示弹出层
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    NutPopupPosition position = NutPopupPosition.bottom,
    bool round = true,
    bool closeOnClickOverlay = true,
    Color overlayColor = Colors.black54,
    double radius = 16,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: closeOnClickOverlay,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _PopupContent(
          position: position,
          round: round,
          animation: animation,
          overlayColor: overlayColor,
          radius: radius,
          child: child,
        );
      },
    );
  }

  // 关闭弹出层
  static void close<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }
}

// 弹出层视图与动画核心
class _PopupContent extends StatelessWidget {
  final NutPopupPosition position;
  final bool round;
  final Animation<double> animation;
  final Color overlayColor;
  final double radius;
  final Widget child;

  const _PopupContent({
    required this.position,
    required this.round,
    required this.animation,
    required this.overlayColor,
    required this.radius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 遮罩层 (跟随动画淡入淡出)
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: FadeTransition(
            opacity: animation,
            child: Container(color: overlayColor),
          ),
        ),
        // 弹出内容
        _buildAnimatedContent(),
      ],
    );
  }

  Widget _buildAnimatedContent() {
    Alignment alignment;
    Offset startOffset;

    // 根据位置决定对齐方式和初始偏移量
    switch (position) {
      case NutPopupPosition.bottom:
        alignment = Alignment.bottomCenter;
        startOffset = const Offset(0, 1);
        break;
      case NutPopupPosition.top:
        alignment = Alignment.topCenter;
        startOffset = const Offset(0, -1);
        break;
      case NutPopupPosition.left:
        alignment = Alignment.centerLeft;
        startOffset = const Offset(-1, 0);
        break;
      case NutPopupPosition.right:
        alignment = Alignment.centerRight;
        startOffset = const Offset(1, 0);
        break;
      case NutPopupPosition.center:
        alignment = Alignment.center;
        startOffset = Offset.zero; // 居中没有滑动，使用缩放
        break;
    }

    // 动画曲线
    final CurvedAnimation curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
    );

    Widget content = Material(
      color: Colors.white,
      child: child,
    );

    // 圆角裁切
    if (round) {
      BorderRadius borderRadius;
      switch (position) {
        case NutPopupPosition.bottom:
          borderRadius = BorderRadius.vertical(top: Radius.circular(radius));
          break;
        case NutPopupPosition.top:
          borderRadius = BorderRadius.vertical(bottom: Radius.circular(radius));
          break;
        case NutPopupPosition.left:
          borderRadius = BorderRadius.horizontal(right: Radius.circular(radius));
          break;
        case NutPopupPosition.right:
          borderRadius = BorderRadius.horizontal(left: Radius.circular(radius));
          break;
        case NutPopupPosition.center:
          borderRadius = BorderRadius.all(Radius.circular(radius));
          break;
      }
      content = ClipRRect(borderRadius: borderRadius, child: content);
    }

    // 组合对齐、滑动与缩放动画
    return Align(
      alignment: alignment,
      child: position == NutPopupPosition.center
        ? FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
            child: content,
          ),
        ) : SlideTransition(
          position: Tween<Offset>(begin: startOffset, end: Offset.zero).animate(curvedAnimation),
          child: content,
      ),
    );
  }
}