import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutui_flutter/nutui_flutter.dart';
import 'package:nutui_flutter/theme/colors.dart';

class TagPage extends StatelessWidget {
  const TagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tag 标签')),
      backgroundColor: NutUIColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NutCellGroup(
                title: '标签类型',
                children: [
                  _buildRow([
                    const NutTag(text: '主要标签', type: NutTagType.primary),
                    const NutTag(text: '成功标签', type: NutTagType.success),
                    const NutTag(text: '危险标签', type: NutTagType.danger),
                    const NutTag(text: '警告标签', type: NutTagType.warning),
                  ]),
                ],
              ),

              NutCellGroup(
                title: '空心样式 (plain)',
                children: [
                  _buildRow([
                    const NutTag(text: '主要', type: NutTagType.primary, plain: true),
                    const NutTag(text: '成功', type: NutTagType.success, plain: true),
                    const NutTag(text: '危险', type: NutTagType.danger, plain: true),
                    const NutTag(text: '警告', type: NutTagType.warning, plain: true),
                  ]),
                ],
              ),

              NutCellGroup(
                title: '圆角样式',
                children: [
                  _buildRow([
                    const NutTag(text: '圆角标签', round: true),
                    const NutTag(text: '成功圆角', type: NutTagType.success, round: true),
                  ]),
                ],
              ),

              NutCellGroup(
                title: '标记样式 (mark)',
                children: [
                  _buildRow([
                    const NutTag(text: '标记标签', mark: true),
                    const NutTag(text: '成功标记', type: NutTagType.success, mark: true),
                  ]),
                ],
              ),

              NutCellGroup(
                title: '标签尺寸',
                children: [
                  _buildRow([
                    const NutTag(text: '大号', size: NutTagSize.large),
                    const NutTag(text: '中号', size: NutTagSize.normal),
                    const NutTag(text: '小号', size: NutTagSize.small),
                  ]),
                ],
              ),

              NutCellGroup(
                title: '可关闭标签',
                children: [
                  _buildRow([
                    NutTag(
                      text: '可关闭',
                      type: NutTagType.primary,
                      closeable: true,
                      onClose: () {},
                    ),
                    NutTag(
                      text: '关闭',
                      type: NutTagType.success,
                      closeable: true,
                      onClose: () {},
                    ),
                  ]),
                ],
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<Widget> tags) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: tags,
      ),
    );
  }
}
