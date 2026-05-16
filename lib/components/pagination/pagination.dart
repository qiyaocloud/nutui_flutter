import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../icon/icon.dart';

/// 分页模式 (简单模式只有上一页/下一页)
enum NutPaginationMode {
  multi,
  simple
}

class NutPagination extends StatefulWidget {
  // 当前页码(从1开始)
  final int modelValue;

  // 总条数
  final int totalItems;

  // 每页条数
  final int itemPerPage;

  // 页面改变回调
  final ValueChanged<int>? onChange;

  // 模式
  final NutPaginationMode mode;

  // 上一页图标
  final IconData prevIcon;

  // 下一页图标
  final IconData nextIcon;

  // 是否禁用
  final bool disabled;

  const NutPagination({
    super.key,
    required this.modelValue,
    required this.totalItems,
    this.itemPerPage = 10,
    this.onChange,
    this.mode = NutPaginationMode.multi,
    this.prevIcon = NutIcons.left,
    this.nextIcon = NutIcons.right,
    this.disabled = false,
  });

  @override
  State<NutPagination> createState() => _NutPaginationState();
}

class _NutPaginationState extends State<NutPagination> {
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.modelValue.clamp(1, pageCount);
  }

  @override
  void didUpdateWidget(covariant NutPagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 外部强制更新页码
    if (oldWidget.modelValue != widget.modelValue) {
      _currentPage = widget.modelValue.clamp(1, pageCount);
    }
  }
  
  // 计算总页数
  int get pageCount {
    if (widget.totalItems <= 0) return 1;
    return (widget.totalItems / widget.itemPerPage).ceil();
  }
  
  // 切换页码
  void _changePage(int page) {
    if (widget.disabled) return;
    if (page < 1 || page > pageCount || page == _currentPage) return;
    
    setState(() => _currentPage = page);
    widget.onChange?.call(page);
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.mode == NutPaginationMode.simple) {
      return _buildSimpleMode();
    }
    return _buildMultiMode();
  }
  
  // 简单模式
  Widget _buildSimpleMode() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButton(
          icon: widget.prevIcon,
          onTap: () => _changePage(_currentPage - 1),
          isDisabled: _currentPage <= 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('$_currentPage / $pageCount', style: const TextStyle(fontSize: 14, color: NutUIColors.text)),
        ),
        _buildButton(
          icon: widget.nextIcon,
          onTap: () => _changePage(_currentPage + 1),
          isDisabled: _currentPage >= pageCount,
        ),
      ],
    );
  }

  // 多页码模式
  Widget _buildMultiMode() {
    List<dynamic> pages = _generatePages(_currentPage, pageCount);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 上一页
        _buildButton(
          icon: widget.prevIcon,
          onTap: () => _changePage(_currentPage - 1),
          isDisabled: _currentPage <= 1,
        ),
        // 动态页码
        ...pages.map((item) {
          if (item is int) {
            return _buildPageItem(item);
          } else {
            // 省略号
            return _buildEllipsis();
          }
        }),
        // 下一页
        _buildButton(
          icon: widget.nextIcon,
          onTap: () => _changePage(_currentPage + 1),
          isDisabled: _currentPage >= pageCount,
        ),
      ],
    );
  }

  // 上一页/下一页按钮
  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDisabled,
  }) {
    bool finalDisabled = isDisabled || widget.disabled;
    return GestureDetector(
      onTap: finalDisabled ? null : onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: NutUIColors.itemBg,
          borderRadius: BorderRadius.circular(4),
        ),
        child: NutIcon(
          icon: icon,
          size: 14,
          color: finalDisabled ? NutUIColors.disabled : NutUIColors.text,
        ),
      ),
    );
  }

  // 数字页码项
  Widget _buildPageItem(int page) {
    bool isActive = page == _currentPage;
    return GestureDetector(
      onTap: () => _changePage(page),
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? NutUIColors.primary : NutUIColors.itemBg,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '$page',
          style: TextStyle(
            fontSize: 14,
            color: isActive ? Colors.white : (widget.disabled ? NutUIColors.disabled : NutUIColors.text),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // 省略号项
  Widget _buildEllipsis() {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      child: const Text('...', style: TextStyle(fontSize: 14, color: NutUIColors.textSecondary, fontWeight: FontWeight.bold)),
    );
  }

  // 生成动态页码列表
  // 返回包含 Int(页码) 和 String('...') 的列表
  List<dynamic> _generatePages(int current, int total) {
    if (total <= 5) {
      // 总页数少，全部显示
      return List.generate(total, (index) => index + 1);
    }

    List<dynamic> pages = [];

    // 始终显示第一页
    pages.add(1);

    if (current <= 3) {
      // 靠近首页
      pages.addAll([2, 3, 4]);
      pages.add('...');
    } else if (current >= total - 2) {
      // 靠近尾页
      pages.add('...');
      pages.addAll([total - 3, total - 2, total - 1]);
    } else {
      // 在中间
      pages.add('...');
      pages.addAll([current - 1, current, current + 1]);
      pages.add('...');
    }

    // 始终显示最后一页
    pages.add(total);

    return pages;
  }
}