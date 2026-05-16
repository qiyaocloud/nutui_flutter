import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nutui_flutter/nutui_flutter.dart';
import 'package:nutui_flutter/theme/colors.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NutUIColors.background,
      appBar: AppBar(
        title: const Text('NutUI Flutter 组件库'),
        centerTitle: true,
        backgroundColor: NutUIColors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('导航组件', [
                _NavItem(icon: NutIcons.horizontalN, title: 'TabBar 标签栏', route: '/components/nav'),
                _NavItem(icon: NutIcons.horizontalN, title: 'Tabs / Sidebar / Menu', route: '/components/nav'),
              ]),
              _buildSection('基础组件', [
                _NavItem(icon: NutIcons.retweet, title: 'Button 按钮', route: '/components/button'),
                _NavItem(icon: NutIcons.my, title: 'Cell 单元格', route: '/components/cell'),
                _NavItem(icon: NutIcons.service, title: 'Icon 图标', route: '/components/icon'),
                _NavItem(icon: NutIcons.tips, title: 'Tag 标签', route: '/components/tag'),
                _NavItem(icon: NutIcons.my, title: 'Avatar 头像', route: '/components/avatar'),
              ]),
              _buildSection('表单组件', [
                _NavItem(icon: NutIcons.check, title: 'Switch 开关', route: '/components/switch'),
                _NavItem(icon: NutIcons.checklist, title: 'Checkbox / Radio / 评分 / 输入 / 文本域', route: '/components/form'),
                _NavItem(icon: NutIcons.search, title: 'SearchBar 搜索', route: '/components/form'),
              ]),
              _buildSection('反馈组件', [
                _NavItem(icon: NutIcons.issue, title: 'Dialog / Toast / Popup / 加载 / 骨架 / 空状态', route: '/components/feedback'),
                _NavItem(icon: NutIcons.notice, title: 'NoticeBar / Swipe', route: '/components/display'),
              ]),
              _buildSection('展示组件', [
                _NavItem(icon: NutIcons.heart, title: 'Badge 徽标', route: '/components/badge'),
                _NavItem(icon: NutIcons.find, title: 'Grid / Price / 倒计时 / 环形进度 / 折叠', route: '/components/display'),
                _NavItem(icon: NutIcons.starN, title: '分割线 / 分页 / 上传', route: '/components/display'),
              ]),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<_NavItem> items) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: NutCellGroup(
        title: title,
        children: items.map((item) => _NavCell(item: item)).toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String title;
  final String route;
  const _NavItem({required this.icon, required this.title, required this.route});
}

class _NavCell extends StatelessWidget {
  final _NavItem item;
  const _NavCell({required this.item});

  @override
  Widget build(BuildContext context) {
    return NutCellWithBorder(
      cell: NutCell(
        icon: item.icon,
        title: item.title,
        isLink: true,
        onTap: () => Get.toNamed(item.route),
      ),
    );
  }
}
