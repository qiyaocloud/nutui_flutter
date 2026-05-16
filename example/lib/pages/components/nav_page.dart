import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutui_flutter/nutui_flutter.dart';
import 'package:nutui_flutter/theme/colors.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _tabbarIndex = 0;
  int _tabsIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('导航组件')),
      backgroundColor: NutUIColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NutCellGroup(
                title: 'NavBar 导航栏',
                desc: '自定义导航栏（独立使用，非 Scaffold AppBar）',
                children: [
                  Container(
                    color: NutUIColors.white,
                    child: const NutNavbar(
                      title: '页面标题',
                      rightText: '更多',
                      rightIcon: NutIcons.more,
                      safeAreaTop: false,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    color: NutUIColors.white,
                    child: const NutNavbar(
                      title: '自定义返回',
                      leftText: '返回',
                      rightText: '分享',
                      safeAreaTop: false,
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'TabBar 标签栏',
                children: [
                  Container(
                    color: NutUIColors.white,
                    child: NutTabbar(
                      currentIndex: _tabbarIndex,
                      onTap: (i) => setState(() => _tabbarIndex = i),
                      items: const [
                        NutTabbarItem(icon: NutIcons.home, title: '首页'),
                        NutTabbarItem(icon: NutIcons.category, title: '分类'),
                        NutTabbarItem(icon: NutIcons.find, title: '发现'),
                        NutTabbarItem(icon: NutIcons.my, title: '我的'),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Tabs 标签页',
                desc: '左右可滑动切换',
                children: [
                  SizedBox(
                    height: 180.h,
                    child: NutTabs(
                      tabs: const ['标签1', '标签2', '标签3'],
                      initialIndex: _tabsIndex,
                      onChanged: (i) => setState(() => _tabsIndex = i),
                      children: [
                        Center(child: Text('内容1', style: TextStyle(fontSize: 16.sp, color: NutUIColors.textSecondary))),
                        Center(child: Text('内容2', style: TextStyle(fontSize: 16.sp, color: NutUIColors.textSecondary))),
                        Center(child: Text('内容3', style: TextStyle(fontSize: 16.sp, color: NutUIColors.textSecondary))),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Sidebar 侧边导航',
                children: [
                  Container(
                    color: NutUIColors.white,
                    height: 200.h,
                    child: Row(
                      children: [
                        Container(
                          width: 100.w,
                          color: NutUIColors.bgGray,
                          child: Column(
                            children: ['选项一', '选项二', '选项三'].asMap().entries.map((e) {
                              final isActive = e.key == 0;
                              return Container(
                                height: 48.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isActive ? NutUIColors.white : Colors.transparent,
                                  border: Border(bottom: BorderSide(color: NutUIColors.border, width: 0.5)),
                                ),
                                child: Text(
                                  e.value,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: isActive ? NutUIColors.primary : NutUIColors.text,
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text('侧边内容区域', style: TextStyle(fontSize: 14, color: NutUIColors.textSecondary)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Pagination 分页',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NutButton(text: '上一页', size: NutButtonSize.small, appearance: NutButtonAppearance.outlined),
                        Text('1 / 10', style: TextStyle(fontSize: 14.sp, color: NutUIColors.text)),
                        NutButton(text: '下一页', size: NutButtonSize.small, type: NutButtonType.primary),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Menu 菜单',
                children: [
                  Container(
                    color: NutUIColors.white,
                    height: 48.h,
                    child: Row(
                      children: [
                        _buildMenuItem('综合排序'),
                        _buildMenuItem('价格'),
                        _buildMenuItem('筛选'),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String text) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: NutUIColors.border, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: TextStyle(fontSize: 13.sp, color: NutUIColors.text)),
            SizedBox(width: 4.w),
            NutIcon(icon: Icons.arrow_drop_down, size: 16, color: NutUIColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
