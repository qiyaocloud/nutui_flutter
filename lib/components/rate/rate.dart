import 'package:flutter/material.dart';
import 'package:nutui_flutter/components/icon/icon.dart';

import '../../theme/colors.dart';

class NutRate extends StatefulWidget {
  // 当前分值
  final double value;

  // 分值改变回调
  final ValueChanged<double>? onChanged;

  // 图标总数
  final int count;

  // 是否允许半星
  final bool allowHalf;

  // 是否只读
  final bool readonly;

  // 是否禁用
  final bool disabled;

  // 图标大小
  final double size;

  // 图标间距
  final double gutter;

  // 选中颜色
  final Color activeColor;

  // 未选中颜色
  final Color voidColor;

  // 禁用颜色
  final Color disabledColor;

  // 自定义选中图标
  final IconData? activeIcon;

  // 自定义未选中图标
  final IconData? voidIcon;

  const NutRate({
    super.key,
    required this.value,
    this.onChanged,
    this.count = 5,
    this.allowHalf = false,
    this.readonly = false,
    this.disabled = false,
    this.size = 20,
    this.gutter = 4,
    this.activeColor = NutUIColors.primary,
    this.voidColor = NutUIColors.rateVoidColor,
    this.disabledColor = NutUIColors.disabled,
    this.activeIcon,
    this.voidIcon,
  });

  @override
  State<NutRate> createState() => _NutRateState();
}

class _NutRateState extends State<NutRate> {
  @override
  Widget build(BuildContext context) {
    // 如果禁用或只读，忽略点击和滑动
    bool isInteractive = !widget.disabled && !widget.readonly;

    return GestureDetector(
      onHorizontalDragUpdate: isInteractive ? _handleDrag : null,
      onHorizontalDragEnd: isInteractive ? _handleDragEnd : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.count, (index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < widget.count - 1 ? widget.gutter : 0,
            ),
            child: _buildStar(index),
          );
        }),
      ),
    );
  }

  // 构建单个星星
  Widget _buildStar(int index) {
    // 当前星星代表的分值起始量 (如第2颗星代表 2.0)
    double starValue = index + 1.0;

    // 判断当前星星的填充比例 (0.0 ~ 1.0)
    double fillRatio = 0.0;
    if (widget.value >= starValue) {
      fillRatio = 1.0; // 满星
    } else if (widget.value > starValue - 1.0 && widget.value < starValue) {
      fillRatio = widget.value - (starValue - 1.0); // 半星比例
    }

    Color currentActiveColor = widget.disabled ? widget.disabledColor : widget.activeColor;
    Object currentActiveIcon = widget.activeIcon ?? NutIcons.starFill;
    Object currentVoidIcon = widget.voidIcon ?? NutIcons.starFill;

    return GestureDetector(
      onTap: (!widget.disabled && !widget.readonly) ? () => _handleTap(index) : null,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          children: [
            // 底层：空心星星
            Icon(
              currentVoidIcon as IconData?,
              size: widget.size,
              color: widget.disabled ? widget.disabledColor : widget.voidColor,
            ),
            // 顶层：实心星星（根据比例裁剪）
            if (fillRatio > 0)
              ClipRect(
                clipper: _StarClipper(fillRatio), // 核心裁剪器
                child: Icon(
                  currentActiveIcon as IconData?,
                  size: widget.size,
                  color: currentActiveColor,
                ),
              ),
          ],
        ),
      )
    );
  }

  // 处理点击事件
  void _handleTap(int index) {
    double newValue = index + 1.0;

    // NutUI 逻辑：如果允许半星，点击同一颗星的左半边/右半边可以切换 0.5 和 1.0
    // 这里简化处理：点击直接设为满星，若当前已经是满星且允许半星，则降为半星（为了能选0.5）
    if (widget.allowHalf && widget.value == newValue) {
      newValue -= 0.5;
    }

    if (newValue != widget.value) {
      widget.onChanged?.call(newValue);
    }
  }

  // 处理滑动事件 (核心难点：精准映射坐标)
  void _handleDrag(DragUpdateDetails details) {
    // 获取 Row 的 RenderBox 信息来做坐标转换
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    // 将全局坐标转换为组件内局部坐标
    final Offset localPosition = box.globalToLocal(details.globalPosition);

    // 计算单个图标加间距的宽度
    double itemWidth = widget.size + widget.gutter;

    // 计算当前滑动到了第几颗星
    int index = (localPosition.dx / itemWidth).floor();
    if (index < 0) index = 0;
    if (index >= widget.count) index = widget.count - 1;

    double newValue = index + 1.0;

    // 处理半星逻辑
    if (widget.allowHalf) {
      // 计算在当前星星内部的 X 坐标
      double withinItemX = localPosition.dx - index * itemWidth;
      // 如果在星星左半边，算作半星
      if (withinItemX < widget.size / 2) {
        newValue = index + 0.5;
      }
    }

    // 更新状态 (滑动时不防抖，实时更新)
    if (newValue != widget.value) {
      widget.onChanged?.call(newValue);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    // 滑动结束，无需额外处理，值已经在 drag 中更新
  }
}

// 自定义裁剪器：用于裁剪实心星星实现半星效果
class _StarClipper extends CustomClipper<Rect> {
  final double fillRatio;

  _StarClipper(this.fillRatio);

  @override
  Rect getClip(Size size) {
    // 按照比例裁剪出左侧的矩形区域
    return Rect.fromLTRB(0, 0, size.width * fillRatio, size.height);
  }

  @override
  bool shouldReclip(covariant _StarClipper oldClipper) {
    return oldClipper.fillRatio != fillRatio;
  }
}