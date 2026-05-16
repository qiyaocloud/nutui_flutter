import 'package:flutter/material.dart';
import 'package:nutui_flutter/theme/colors.dart';

// 索引节点数据模型
class NutIndexAnchor {
  final String title;
  final List<String> items;

  const NutIndexAnchor({
    required this.title,
    required this.items,
  });
}

class NutFixedNav extends StatefulWidget {
  // 索引数据源
  final List<NutIndexAnchor> list;

  // 索引字母的点击回调
  final ValueChanged<String>? onAnchorTap;

  // 列表项高度 (用于计算滚动偏移，需与实际渲染高度一致)
  final double itemHeight;

  // 索引标题高度
  final double headerHeight;

  const NutFixedNav({
    super.key,
    required this.list,
    this.onAnchorTap,
    this.itemHeight = 50.0,
    this.headerHeight = 30.0,
  });

  @override
  State<NutFixedNav> createState() => _NutFixedNavState();
}

class _NutFixedNavState extends State<NutFixedNav> {
  final ScrollController _scrollController = ScrollController();

  // 当前选中的字母索引 (-1 表示未选中)
  int _currentIndex = -1;

  // 中央提示字母是否显示
  bool _showIndicator = false;

  // 存储每个字母对应的滚动偏移量
  final Map<String, double> _offsetMap = {};

  @override
  void initState() {
    super.initState();
    _calculateOffsets();
    _scrollController.addListener(_onListScroll);
  }

  @override
  void didUpdateWidget(covariant NutFixedNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.list != widget.list || oldWidget.itemHeight != widget.itemHeight) {
      _calculateOffsets();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_onListScroll);
    _scrollController.dispose();
  }

  // 计算每个分组头部的滚动偏移量
  void _calculateOffsets() {
    _offsetMap.clear();
    double offset = 0;
    for (var anchor in widget.list) {
      _offsetMap[anchor.title] = offset;
      // 当前分组总高度 = 标题高度 + 子项数量 * 子项高度
      offset += widget.headerHeight + (anchor.items.length * widget.itemHeight);
    }
  }

  // 监听左侧列表滚动，驱动右侧字母高亮
  void _onListScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;

    // 从后往前遍历，找到当前偏移量对应的分组
    for (int i = widget.list.length - 1; i >= 0; i--) {
      final anchorTitle = widget.list[i].title;
      if (_offsetMap.containsKey(anchorTitle) && offset >= _offsetMap[anchorTitle]!) {
        if (_currentIndex != i) {
          setState(() => _currentIndex = i);
        }
        break;
      }
    }
  }

  // 右侧字母被点击或滑动选中
  void _onLetterSelected(int index) {
    if (index < 0 || index >= widget.list.length) return;

    final anchorTitle = widget.list[index].title;
    final targetOffset = _offsetMap[anchorTitle] ?? 0.0;

    // 标志位：右侧驱动左侧滚动时，左侧的 listener 不应再反向修改右侧高亮
    // (因为 animateTo 过程中 offset 会不断变化)
    setState(() {
      _currentIndex = index;
      _showIndicator = true;
    });

    // 滚动到对应位置
    _scrollController.jumpTo(targetOffset);

    widget.onAnchorTap?.call(anchorTitle);

    // 隐藏中央提示
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _showIndicator = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 提取字母列表
    final letters = widget.list.map((e) => e.title).toList();

    return Stack(
      children: [
        // 左侧列表
        _buildList(),
        // 右侧字母条
        _buildSidebar(letters),
        // 中央字母提示
        if (_showIndicator) _buildIndicator(),
      ],
    );
  }

  // 构建左侧列表
  Widget _buildList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        final anchor = widget.list[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分组标题
            Container(
              height: widget.headerHeight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: NutUIColors.bgGray,
              alignment: Alignment.centerLeft,
              child: Text(
                anchor.title,
                style: const TextStyle(fontSize: 13, color: NutUIColors.textSecondary, fontWeight: FontWeight.w500),
              ),
            ),
            // 子项列表
            ...anchor.items.map((item) => Container(
              height: widget.itemHeight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: NutUIColors.border, width: 0.5)),
              ),
              alignment: Alignment.centerLeft,
              child: Text(item, style: const TextStyle(fontSize: 14, color: NutUIColors.text)),
            )),
          ],
        );
      },
    );
  }

  // 构建右侧字母条
  Widget _buildSidebar(List<String> letters) {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      width: 28,
      child: GestureDetector(
        onVerticalDragStart: (details) => _handleSidebarTouch(details.globalPosition, letters),
        onVerticalDragUpdate: (details) => _handleSidebarTouch(details.globalPosition, letters),
        onTapUp: (details) => _handleSidebarTouch(details.globalPosition, letters),
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: letters.asMap().entries.map((entry) {
              final index = entry.key;
              final letter = entry.value;
              final isActive = _currentIndex == index;
              return GestureDetector(
                onTap: () => _onLetterSelected(index),
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive ? NutUIColors.primary :  Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive ? Colors.white : NutUIColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // 处理右侧触摸滑动定位
  void _handleSidebarTouch(Offset globalPosition, List<String> letters) {
    // 获取右侧 Sidebar 的 RenderBox
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    // 将全局坐标转换为本地坐标
    final localPosition = box.globalToLocal(globalPosition);
    // 计算触摸点在侧边栏的垂直比例
    final pct = (localPosition.dy / box.size.height).clamp(0.0, 1.0);
    // 根据比例计算出对应的字母索引
    final index = (pct * letters.length).floor().clamp(0, letters.length - 1);

    _onLetterSelected(index);
  }

  // 构建中央字母提示
  Widget _buildIndicator() {
    final currentLetter = widget.list[_currentIndex].title;
    return Center(
      child: AnimatedOpacity(
        opacity: _showIndicator ? 0.9 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: NutUIColors.primary.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            currentLetter,
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}