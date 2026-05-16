import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutui_flutter/nutui_flutter.dart';
import 'package:nutui_flutter/theme/colors.dart';

class BadgePage extends StatelessWidget {
  const BadgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Badge 徽标')),
      backgroundColor: NutUIColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NutCellGroup(
                title: '数字徽标',
                children: [
                  _buildRow([
                    const NutBadge(value: 5, color: NutUIColors.danger, textColor: NutUIColors.white, child: NutIcon(icon: NutIcons.message, size: 24)),
                    const NutBadge(value: 15, color: NutUIColors.danger, textColor: NutUIColors.white, child: NutIcon(icon: NutIcons.message, size: 24)),
                    const NutBadge(value: 100, color: NutUIColors.danger, textColor: NutUIColors.white, child: NutIcon(icon: NutIcons.message, size: 24)),
                  ]),
                ],
              ),

              NutCellGroup(
                title: '圆点徽标',
                children: [
                  _buildRow([
                    const NutBadge(dot: true, color: NutUIColors.danger, child: NutIcon(icon: NutIcons.message, size: 24)),
                    const NutBadge(dot: true, color: NutUIColors.success, child: NutIcon(icon: NutIcons.message, size: 24)),
                  ]),
                ],
              ),

              NutCellGroup(
                title: '文字徽标',
                children: [
                  _buildRow([
                    const NutBadge(text: 'NEW', color: NutUIColors.danger, textColor: NutUIColors.white, child: NutIcon(icon: NutIcons.message, size: 24)),
                    const NutBadge(text: '热', color: NutUIColors.warning, textColor: NutUIColors.white, child: NutIcon(icon: NutIcons.message, size: 24)),
                  ]),
                ],
              ),

              NutCellGroup(
                title: '自定义颜色',
                children: [
                  _buildRow([
                    const NutBadge(value: 8, color: NutUIColors.primary, textColor: NutUIColors.white, child: NutIcon(icon: NutIcons.message, size: 24)),
                    const NutBadge(value: 8, color: NutUIColors.success, textColor: NutUIColors.white, child: NutIcon(icon: NutIcons.message, size: 24)),
                    const NutBadge(value: 8, color: NutUIColors.info, textColor: NutUIColors.white, child: NutIcon(icon: NutIcons.message, size: 24)),
                  ]),
                ],
              ),

              NutCellGroup(
                title: '独立使用',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Wrap(
                      spacing: 16.w,
                      runSpacing: 16.h,
                      children: const [
                        NutBadge(value: 8, color: NutUIColors.danger, textColor: NutUIColors.white),
                        NutBadge(text: '促销', color: NutUIColors.warning, textColor: NutUIColors.white),
                        NutBadge(dot: true, color: NutUIColors.danger),
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

  Widget _buildRow(List<Widget> badges) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Wrap(
        spacing: 24.w,
        runSpacing: 16.h,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: badges,
      ),
    );
  }
}
