import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class NutTabs extends StatefulWidget {
  // 标签列表
  final List<String> tabs;

  // 对应的内容页面列表
  final List<Widget> children;

  // 初始选中的索引
  final int initialIndex;

  // 选中颜色
  final Color activeColor;

  // 是否可以滑动切换（开启后 Tabbar 可滚动）
  final bool scrollable;

  // 指示器宽度 (默认 40，传 null 则撑满标签宽度)
  final double? lineWidth;

  // 指示器高度
  final double lineHeight;

  // 指示器圆角
  final double lineRadius;

  // 标签改变回调
  final ValueChanged<int>? onChanged;

  const NutTabs({
    super.key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.activeColor = NutUIColors.primary,
    this.scrollable = false,
    this.lineWidth = 40,
    this.lineHeight = 3,
    this.lineRadius = 1.5,
    this.onChanged,
  });

  @override
  State<NutTabs> createState() => _NutTabsState();
}

class _NutTabsState extends State<NutTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    _tabController.addListener(_handleTabChanged);
  }

  void _handleTabChanged() {
    // 过滤掉滑动过程中产生的动画回调，只在真正切换时触发
    if (_tabController.indexIsChanging) {
      widget.onChanged?.call(_tabController.index);
    }
  }

  @override
  void didUpdateWidget(covariant NutTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果标签数量发生变化，需要重建 Controller
    if (widget.tabs.length != oldWidget.tabs.length) {
      _tabController.removeListener(_handleTabChanged);
      _tabController.dispose();
      _tabController = TabController(
        length: widget.tabs.length,
        initialIndex: _tabController.index.clamp(0, widget.tabs.length - 1),
        vsync: this,
      );
      _tabController.addListener(_handleTabChanged);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 头部标签区域
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: NutUIColors.border, width: 0.5)),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: widget.scrollable,
            labelColor: NutUIColors.text,
            unselectedLabelColor: NutUIColors.textSecondary,
            labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            indicatorSize: TabBarIndicatorSize.label, // 指示器跟文字同宽，便于居中
            indicatorPadding: const EdgeInsets.only(top: 6), // 指示器距离底部一点距离
            indicator: _NutUnderlineIndicator(
              width: widget.lineWidth,
              height: widget.lineHeight,
              radius: widget.lineRadius,
              color: widget.activeColor,
            ),
            // 将 String 转为 Tab
            tabs: widget.tabs.map((e) => Tab(text: e)).toList(),
            // 取消原生默认的水波纹点击效果
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) => states.contains(WidgetState.focused) ? null : Colors.transparent,
            ),
          ),
        ),
        // 内容区域
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.children,
          ),
        )
      ],
    );
  }
}

// 自定义指示器 (圆角胶囊状)
class _NutUnderlineIndicator extends Decoration {
  final double? width;
  final double height;
  final double radius;
  final Color color;

  const _NutUnderlineIndicator({
    required this.width,
    required this.height,
    required this.radius,
    required this.color,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _NutUnderlinePainter(this, onChanged);
  }
}

class _NutUnderlinePainter extends BoxPainter {
  final _NutUnderlineIndicator decoration;

  _NutUnderlinePainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final size = configuration.size!;
    final paint  = Paint()
      ..color = decoration.color
      ..style = PaintingStyle.fill;

    // 计算指示器位置
    final double indicatorWidth = decoration.width ?? size.width;
    final double indicatorHeight = decoration.height;

    // 水平居中 (offset 是 Tab 的偏移量)
    final double dx = offset.dx + (size.width - indicatorWidth) / 2;
    // 置底
    final double dy = size.height - indicatorHeight;
    
    final Rect rect = Rect.fromLTWH(dx, dy, indicatorWidth, indicatorHeight);
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(decoration.radius));

    canvas.drawRRect(rrect, paint);
  }
}