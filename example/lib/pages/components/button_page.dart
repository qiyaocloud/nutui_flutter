import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutui_flutter/nutui_flutter.dart';
import 'package:nutui_flutter/theme/colors.dart';

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Button 按钮')),
      backgroundColor: NutUIColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 按钮类型
              NutCellGroup(
                title: '按钮类型',
                children: [
                  _buildDemoRow([
                    NutButton(text: '主要按钮', type: NutButtonType.primary),
                    NutButton(text: '信息按钮', type: NutButtonType.info),
                    NutButton(text: '成功按钮', type: NutButtonType.success),
                  ]),
                  _buildDemoRow([
                    NutButton(text: '警告按钮', type: NutButtonType.warning),
                    NutButton(text: '危险按钮', type: NutButtonType.danger),
                    NutButton(text: '默认按钮'),
                  ]),
                ],
              ),

              // 按钮外观
              NutCellGroup(
                title: '按钮外观',
                children: [
                  _buildDemoRow([
                    NutButton(text: '实心', type: NutButtonType.primary),
                    NutButton(text: '描边', type: NutButtonType.primary, appearance: NutButtonAppearance.outlined),
                  ]),
                  _buildDemoRow([
                    NutButton(text: '虚线', type: NutButtonType.primary, appearance: NutButtonAppearance.dashed),
                    NutButton(text: '纯文字', type: NutButtonType.primary, appearance: NutButtonAppearance.text),
                  ]),
                ],
              ),

              // 按钮尺寸
              NutCellGroup(
                title: '按钮尺寸',
                children: [
                  _buildDemoRow([
                    NutButton(text: '大号', size: NutButtonSize.large),
                    NutButton(text: '中号', size: NutButtonSize.medium),
                  ]),
                  _buildDemoRow([
                    NutButton(text: '小号', size: NutButtonSize.small),
                    NutButton(text: '迷你', size: NutButtonSize.mini),
                  ]),
                ],
              ),

              // 按钮形状
              NutCellGroup(
                title: '按钮形状',
                children: [
                  _buildDemoRow([
                    NutButton(text: '直角', shape: NutButtonShape.rect),
                    NutButton(text: '圆角', shape: NutButtonShape.round),
                  ]),
                ],
              ),

              // 按钮状态
              NutCellGroup(
                title: '按钮状态',
                children: [
                  _buildDemoRow([
                    NutButton(text: '禁用', disabled: true),
                    NutButton(text: '加载中', loading: true),
                  ]),
                ],
              ),

              // 按钮搭配图标
              NutCellGroup(
                title: '按钮搭配图标',
                children: [
                  _buildDemoRow([
                    NutButton(text: '搜索', icon: NutIcons.search),
                    NutButton(text: '购物车', icon: NutIcons.cart),
                  ]),
                ],
              ),

              // 块级按钮
              NutCellGroup(
                title: '块级按钮 (block)',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: NutButton(
                      text: '块级按钮',
                      type: NutButtonType.primary,
                      block: true,
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

  Widget _buildDemoRow(List<Widget> buttons) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: buttons,
      ),
    );
  }
}
