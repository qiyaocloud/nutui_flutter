import 'package:flutter/material.dart';

class NutOverlay extends StatelessWidget {
  // 是否显示遮罩
  final bool visible;

  // 点击遮罩时的回调
  final VoidCallback? onTap;

  // 遮罩颜色
  final Color color;

  // 遮罩透明度 （0.0 - 1.0）
  final double opacity;

  // 动画时长
  final Duration duration;

  // 子组件 (通常是将要弹出的内容，放在遮罩之上)
  final Widget? child;

  const NutOverlay({
    super.key,
    this.visible = true,
    this.onTap,
    this.color = Colors.black,
    this.opacity = 0.7,
    this.duration = const Duration(milliseconds: 300),
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible, // 不可见时，不拦截点击事件，让事件穿透到下层
      child: AnimatedOpacity(
        opacity: visible ? opacity : 0.0,
        duration: duration,
        curve: Curves.easeInOut,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque, // 确保空白区域也能响应点击
          child: Container(
            color: color,
            // 使用 Stack 将子组件（弹窗内容）叠加在遮罩之上
            child: child != null
              ? Stack(
                children: [
                  // 为了让子组件能正常接收点击事件，遮罩层本身不能拦截子组件区域的事件
                  // 因此我们让遮罩层只作为背景，子组件放在最上层
                  Positioned.fill(child: Container(color: color)),
                  child!,
                ],
              ) : null,
          ),
        ),
      ),
    );
  }
}

// 命令式调用：全局遮罩层管理 (基于 OverlayEntry)
class NutOverlayController {
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;

  // 是否正在显示
  bool get isVisible => _isVisible;

  // 显示全局遮罩
  void show(
      BuildContext context, {
      Color color = Colors.black,
      double opacity = 0.7,
      VoidCallback? onTap,
      Widget? child,
  }) {
    if (_isVisible) return; // 防止重复显示

    final overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return NutOverlay(
          visible: true,
          color: color,
          opacity: opacity,
          onTap: onTap,
          child: child,
        );
      },
    );

    overlayState.insert(_overlayEntry!);
    _isVisible = true;
  }

  // 隐藏全局遮罩（带动画）
  void hide({Duration delay = const Duration(milliseconds: 300)}) {
    if (!_isVisible || _overlayEntry == null) return;

    // 先触发动画 (通过重建 Widget)
    // 注意：这里简单处理直接移除，如果需要淡出动画，需要更复杂的状态管理
    // 为了保证平滑淡出，我们使用一个包装了动画的 StatefulWidget Entry

    // 简单移除方案 (立刻消失)：
    // _overlayEntry!.remove();
    // _overlayEntry = null;
    // _isVisible = false;

    // 带淡出动画的方案：
    _overlayEntry!.markNeedsBuild(); // 触发重建
    Future.delayed(delay, () {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
        _isVisible = false;
      }
    });
  }
}