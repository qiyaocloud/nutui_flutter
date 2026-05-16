import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutui_flutter/nutui_flutter.dart';
import 'package:nutui_flutter/theme/colors.dart';

class IconPage extends StatelessWidget {
  const IconPage({super.key});

  // 常用图标展示
  static const List<_IconDemo> _icons = [
    _IconDemo(NutIcons.home, 'home'),
    _IconDemo(NutIcons.my, 'my'),
    _IconDemo(NutIcons.search, 'search'),
    _IconDemo(NutIcons.cart, 'cart'),
    _IconDemo(NutIcons.category, 'category'),
    _IconDemo(NutIcons.find, 'find'),
    _IconDemo(NutIcons.location, 'location'),
    _IconDemo(NutIcons.scan, 'scan'),
    _IconDemo(NutIcons.share, 'share'),
    _IconDemo(NutIcons.edit, 'edit'),
    _IconDemo(NutIcons.del, 'del'),
    _IconDemo(NutIcons.close, 'close'),
    _IconDemo(NutIcons.success, 'success'),
    _IconDemo(NutIcons.failure, 'failure'),
    _IconDemo(NutIcons.tips, 'tips'),
    _IconDemo(NutIcons.notice, 'notice'),
    _IconDemo(NutIcons.retweet, 'retweet'),
    _IconDemo(NutIcons.plus, 'plus'),
    _IconDemo(NutIcons.more, 'more'),
    _IconDemo(NutIcons.heart, 'heart'),
    _IconDemo(NutIcons.starN, 'star'),
    _IconDemo(NutIcons.download, 'download'),
    _IconDemo(NutIcons.top, 'top'),
    _IconDemo(NutIcons.service, 'service'),
    _IconDemo(NutIcons.loading, 'loading'),
    _IconDemo(NutIcons.check, 'check'),
    _IconDemo(NutIcons.follow, 'follow'),
    _IconDemo(NutIcons.photograph, 'photograph'),
    _IconDemo(NutIcons.message, 'message'),
    _IconDemo(NutIcons.clock, 'clock'),
    _IconDemo(NutIcons.horizontalN, 'horizontal'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Icon 图标')),
      backgroundColor: NutUIColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NutCellGroup(
                title: '基础图标',
                desc: '点击图标可复制名称',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Wrap(
                      spacing: 16.w,
                      runSpacing: 16.h,
                      children: _icons.map((item) => _IconItem(data: item)).toList(),
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: '不同颜色',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Wrap(
                      spacing: 16.w,
                      runSpacing: 16.h,
                      children: [
                        NutIcon(icon: NutIcons.home, size: 28.w, color: NutUIColors.primary),
                        NutIcon(icon: NutIcons.home, size: 28.w, color: NutUIColors.success),
                        NutIcon(icon: NutIcons.home, size: 28.w, color: NutUIColors.warning),
                        NutIcon(icon: NutIcons.home, size: 28.w, color: NutUIColors.info),
                        NutIcon(icon: NutIcons.home, size: 28.w, color: NutUIColors.textSecondary),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: '不同尺寸',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Wrap(
                      spacing: 16.w,
                      runSpacing: 16.h,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        NutIcon(icon: NutIcons.home, size: 16.w),
                        NutIcon(icon: NutIcons.home, size: 24.w),
                        NutIcon(icon: NutIcons.home, size: 32.w),
                        NutIcon(icon: NutIcons.home, size: 40.w),
                        NutIcon(icon: NutIcons.home, size: 48.w),
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
}

class _IconDemo {
  final IconData icon;
  final String name;
  const _IconDemo(this.icon, this.name);
}

class _IconItem extends StatelessWidget {
  final _IconDemo data;
  const _IconItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 72.w,
        height: 72.h,
        decoration: BoxDecoration(
          color: NutUIColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: NutUIColors.borderLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NutIcon(icon: data.icon, size: 24.w, color: NutUIColors.text),
            SizedBox(height: 6.h),
            Text(data.name, style: TextStyle(fontSize: 10.sp, color: NutUIColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
