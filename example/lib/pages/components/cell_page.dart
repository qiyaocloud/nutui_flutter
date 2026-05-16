import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutui_flutter/nutui_flutter.dart';
import 'package:nutui_flutter/theme/colors.dart';

class CellPage extends StatelessWidget {
  const CellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cell 单元格')),
      backgroundColor: NutUIColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NutCellGroup(
                title: '基础用法',
                children: [
                  const NutCellWithBorder(cell: NutCell(title: '单元格文字', value: '内容')),
                  const NutCellWithBorder(cell: NutCell(title: '带描述', subTitle: '描述信息', value: '内容')),
                  const NutCellWithBorder(cell: NutCell(title: '带图标', icon: NutIcons.location, value: '北京')),
                  const NutCellWithBorder(
                    cell: NutCell(title: '带链接', value: '详情', isLink: true),
                  ),
                  const NutCellWithBorder(
                    cell: NutCell(title: '必填', value: '内容', required: true),
                    isLast: true,
                  ),
                ],
              ),

              NutCellGroup(
                title: '大尺寸',
                children: [
                  const NutCellWithBorder(
                    cell: NutCell(title: '大尺寸', value: '内容', size: NutCellSize.large),
                  ),
                  const NutCellWithBorder(
                    cell: NutCell(
                      title: '带描述',
                      subTitle: '描述信息',
                      value: '内容',
                      size: NutCellSize.large,
                    ),
                    isLast: true,
                  ),
                ],
              ),

              NutCellGroup(
                title: '卡片模式 (inset)',
                inset: true,
                children: [
                  const NutCellWithBorder(cell: NutCell(title: '卡片1', value: '内容')),
                  const NutCellWithBorder(cell: NutCell(title: '卡片2', isLink: true)),
                  const NutCellWithBorder(
                    cell: NutCell(title: '卡片3', value: '内容'),
                    isLast: true,
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
}
