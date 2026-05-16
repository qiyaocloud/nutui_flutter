import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class NutDialog extends StatefulWidget {
  // 标题
  final String? title;

  // 内容文字
  final String? content;

  // 自定义内容组件（优先级高于 content）
  final Widget? contentWidget;

  // 确认按钮
  final String confirmText;

  // 取消按钮文字 (为 null 则不显示取消按钮)
  final String? cancelText;

  // 确认按钮颜色
  final Color confirmColor;

  // 标题对齐方式
  final TextAlign titleAlign;

  // 内容对齐方式
  final TextAlign contentAlign;

  // 点击确认回调
  final VoidCallback? onConfirm;

  // 点击取消回调
  final VoidCallback? onCancel;

  // 点击遮罩层关闭
  final bool closeOnClickOverlay;

  const NutDialog({
    super.key,
    this.title,
    this.content,
    this.contentWidget,
    this.confirmText = '确认',
    this.cancelText,
    this.confirmColor = NutUIColors.primary,
    this.titleAlign = TextAlign.center,
    this.contentAlign = TextAlign.center,
    this.onConfirm,
    this.onCancel,
    this.closeOnClickOverlay = false,
  });

  // 显示确认对话框 (只有确认按钮)
  static Future<void> alert(
    BuildContext context, {
      String? title,
      String? content,
      Widget? contentWidget,
      String confirmText = '确认',
      Color confirmColor = NutUIColors.primary,
      TextAlign titleAlign = TextAlign.center,
      TextAlign contentAlign = TextAlign.center,
      bool closeOnClickOverlay = false,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: closeOnClickOverlay,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return NutDialog(
          title: title,
          content: content,
          contentWidget: contentWidget,
          confirmText: confirmText,
          confirmColor: confirmColor,
          titleAlign: titleAlign,
          contentAlign: contentAlign,
          closeOnClickOverlay: closeOnClickOverlay,
          onConfirm: () => Navigator.of(context).pop(),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return _DialogAnimation(animation: animation, child: child);
      },
    );
  }

  // 显示确认取消对话框
  static Future<bool?> confirm(
      BuildContext context, {
        String? title,
        String? content,
        Widget? contentWidget,
        String confirmText = '确认',
        String cancelText = '取消',
        Color confirmColor = NutUIColors.primary,
        TextAlign titleAlign = TextAlign.center,
        TextAlign contentAlign = TextAlign.center,
        bool closeOnClickOverlay = false,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: closeOnClickOverlay,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return NutDialog(
          title: title,
          content: content,
          contentWidget: contentWidget,
          confirmText: confirmText,
          cancelText: cancelText,
          confirmColor: confirmColor,
          titleAlign: titleAlign,
          contentAlign: contentAlign,
          closeOnClickOverlay: closeOnClickOverlay,
          onConfirm: () => Navigator.of(context).pop(true),
          onCancel: () => Navigator.of(context).pop(false),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return _DialogAnimation(animation: animation, child: child);
      },
    );
  }

  @override
  State<NutDialog> createState() => _NutDialogState();
}

class _NutDialogState extends State<NutDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: NutUIColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 内容区域
            _buildContent(),
            // 分割线
            Divider(height: 0.5, thickness: 0.5, color: NutUIColors.border),
            // 按钮区域
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  // 构建内容
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(24, 24, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.title!,
                textAlign: widget.titleAlign,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: NutUIColors.text,
                ),
              ),
            ),
          if (widget.contentWidget != null)
            widget.contentWidget!
          else if (widget.content != null)
            Text(
              widget.content!,
              textAlign: widget.contentAlign,
              style: const TextStyle(
                fontSize: 14,
                color: NutUIColors.textSecondary,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }

  // 构建按钮
  Widget _buildButtons() {
    final bool hasCancel = widget.cancelText != null;

    return IntrinsicHeight(
      child: Row(
        children: [
          // 取消按钮
          if (hasCancel)
            Expanded(
              child: GestureDetector(
                onTap: widget.onCancel,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  child: Text(
                    widget.cancelText!,
                    style: const TextStyle(fontSize: 16, color: NutUIColors.textSecondary),
                  ),
                ),
              ),
            ),
          // 取消与确认之间的竖线
          if (hasCancel)
            SizedBox(
              width: 0.5,
              height: double.infinity,
              child: DecoratedBox(decoration: BoxDecoration(color: NutUIColors.border)),
            ),
          // 确认按钮
          Expanded(
            child: GestureDetector(
              onTap: widget.onConfirm,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                child: Text(
                  widget.confirmText,
                  style: TextStyle(fontSize: 16, color: widget.confirmColor, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// 弹出动画：缩放 + 淡入
class _DialogAnimation extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _DialogAnimation({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    // 使用 CurvedAnimation 实现 EaseOutBack 回弹效果
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutBack,
    );

    return FadeTransition(
      opacity: animation, // 透明度用线性
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation), // 缩放用回弹
        child: child,
      ),
    );
  }
}

