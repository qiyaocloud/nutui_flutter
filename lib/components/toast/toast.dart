import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nutui_flutter/components/icon/icon.dart';

enum NutToastType {
  text,
  success,
  fail,
  loading
}

class NutToast {
  static final _ToastManager _manager = _ToastManager();

  // 纯文字提示
  static void text(
      BuildContext context,
      String message, {
        Duration duration = const Duration(seconds: 2),
        bool forbidClick = false,
  }) {
    _manager.show(
      context,
      message: message,
      type: NutToastType.text,
      duration: duration,
      forbidClick: forbidClick,
    );
  }

  // 成功提示
  static void success(
      BuildContext context,
      String message, {
        Duration duration = const Duration(seconds: 2),
        bool forbidClick = false,
  }) {
    _manager.show(
      context,
      message: message,
      type: NutToastType.success,
      duration: duration,
      forbidClick: forbidClick,
    );
  }

  // 失败提示
  static void fail(
      BuildContext context,
      String message, {
        Duration duration = const Duration(seconds: 2),
        bool forbidClick = false
  }) {
    _manager.show(
      context,
      message: message,
      type: NutToastType.fail,
      duration: duration,
      forbidClick: forbidClick,
    );
  }

  // 加载中提示 (默认不自动关闭，需手动调用 NutToast.close())
  static void loading(
      BuildContext context, {
        String message = '加载中...',
        bool forbidClick = true,
  }) {
    _manager.show(
      context,
      message: message,
      type: NutToastType.loading,
      duration: const Duration(days: 1), // 永不自动关闭
      forbidClick: forbidClick,
    );
  }

  // 手动关闭 Toast (常用于关闭 Loading)
  static void close() {
    _manager.close();
  }
}

// 全局管理器：确保单例，处理 Overlay 插入与移除
class _ToastManager {
  OverlayEntry? _overlayEntry;
  Timer? _timer;
  _ToastStateHolder? _stateHolder;

  void show(
      BuildContext context, {
      required String message,
      required NutToastType type,
      required Duration duration,
      required bool forbidClick,
  }) {
    // 核心逻辑：如果有正在显示的 Toast，直接销毁（单例互斥）
    _closeImmediately();

    final overlayState = Overlay.of(context);
    _stateHolder = _ToastStateHolder();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return _ToastWidget(
          key: _stateHolder!.key,
          message: message,
          type: type,
          forbidClick: forbidClick,
        );
      },
    );

    overlayState.insert(_overlayEntry!);

    // 设置自动关闭定时器
    _timer = Timer(duration, () {
      close();
    });
  }

  void close() {
    _timer?.cancel();
    _timer = null;

    final holder = _stateHolder;
    final entry = _overlayEntry;

    // 清空引用，防止重复关闭
    _stateHolder = null;
    _overlayEntry = null;

    if (holder != null && entry != null) {
      // 触发内部动画
      holder.dismiss();
      // 等待动画播放完毕后，真正移除 OverlayEntry
      Future.delayed(const Duration(milliseconds: 300), () {
        try {
          entry.remove();
        } catch (_) {
          // ignore: empty_catches
        }
      });
    }
  }

  // 立即移除（无退出动画，用于新 Toast 顶掉旧 Toast）
  void _closeImmediately() {
    _timer?.cancel();
    _timer = null;
    _stateHolder = null;
    if (_overlayEntry != null) {
      try {
        _overlayEntry!.remove();
      } catch (_) {/* ignore */}
      _overlayEntry = null;
    }
  }
}

// 用于跨组件获取 State 的辅助类
class _ToastStateHolder {
  final GlobalKey<_ToastWidgetState> key = GlobalKey();
  void dismiss() {
    if (key.currentState != null) {
      key.currentState!.dismiss();
    }
  }
}

// Toast 视图与动画组件
class _ToastWidget extends StatefulWidget {
  final String message;
  final NutToastType type;
  final bool forbidClick;

  const _ToastWidget({
    super.key,
    required this.message,
    required this.type,
    required this.forbidClick,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    // 淡入动画
    _controller.forward();
  }

  // 触发淡出动画
  void dismiss() {
    if (mounted) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 如果不需要拦截点击，使用 IgnorePointer 让事件穿透
    return IgnorePointer(
      ignoring: !widget.forbidClick,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          // 如果需要拦截点击，在最外层 Container 拦截手势
          child: widget.forbidClick
            ? GestureDetector(onTap: () {}, child: _buildContent())
            : _buildContent(),  
        ),
      ),
    );
  }
  
  Widget _buildContent() {
    bool hasIcon = widget.type != NutToastType.text;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: hasIcon ? 20 : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasIcon) _buildIcon(),
          if (hasIcon) const SizedBox(height: 8),
          Text(
            widget.message,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildIcon() {
    const double size = 36;
    switch (widget.type) {
      case NutToastType.success:
        return const NutIcon(icon: NutIcons.success, color: Colors.white, size: size);
      case NutToastType.fail:
        return const NutIcon(icon: NutIcons.failure, color: Colors.white, size: size);
      case NutToastType.loading:
        return const SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}