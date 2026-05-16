import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutui_flutter/nutui_flutter.dart';
import 'package:nutui_flutter/theme/colors.dart';

class DisplayPage extends StatelessWidget {
  const DisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('展示组件')),
      backgroundColor: NutUIColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NutCellGroup(
                title: 'Grid 宫格',
                children: [
                  NutGrid(
                    columnNum: 4,
                    children: const [
                      NutGridItem(icon: NutIcons.location, text: '定位'),
                      NutGridItem(icon: NutIcons.home, text: '电话'),
                      NutGridItem(icon: NutIcons.message, text: '消息'),
                      NutGridItem(icon: NutIcons.left, text: '设置'),
                      NutGridItem(icon: NutIcons.cart, text: '购物车'),
                      NutGridItem(icon: NutIcons.scan, text: '扫码'),
                      NutGridItem(icon: NutIcons.search, text: '搜索'),
                      NutGridItem(icon: NutIcons.more, text: '更多'),
                    ],
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Grid 宫格 (带间距)',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: NutGrid(
                      columnNum: 4,
                      border: false,
                      gutter: 8,
                      children: const [
                        NutGridItem(icon: NutIcons.location, text: '定位'),
                        NutGridItem(icon: NutIcons.home, text: '电话'),
                        NutGridItem(icon: NutIcons.message, text: '消息'),
                        NutGridItem(icon: NutIcons.left, text: '设置'),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Price 价格',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const NutPrice(price: 199.90, size: NutPriceSize.large),
                        SizedBox(height: 12.h),
                        const NutPrice(price: 99.00, size: NutPriceSize.normal),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NutPrice(price: 199.90, size: NutPriceSize.small),
                            SizedBox(width: 12.w),
                            NutPrice(price: 299.00, size: NutPriceSize.small, strikeThrough: true, color: NutUIColors.textDisabled),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        const NutPrice(price: 1234567.89, thousands: true, size: NutPriceSize.normal),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Countdown 倒计时',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        _buildCountdownCard('02'),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(':', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: NutUIColors.countDownSeparator)),
                        ),
                        _buildCountdownCard('15'),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(':', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: NutUIColors.countDownSeparator)),
                        ),
                        _buildCountdownCard('48'),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(':', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: NutUIColors.countDownSeparator)),
                        ),
                        _buildCountdownCard('23'),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'CircleProgress 环形进度',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircleProgress(0.75, NutUIColors.primary, '75%'),
                        _buildCircleProgress(0.60, NutUIColors.success, '60%'),
                        _buildCircleProgress(0.45, NutUIColors.warning, '45%'),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Collapse 折叠面板',
                children: [
                  Container(
                    color: NutUIColors.white,
                    child: Column(
                      children: [
                        _buildCollapseItem('标题一', '内容区域一：这里是折叠面板的详细内容'),
                        Divider(height: 0.5, color: NutUIColors.border),
                        _buildCollapseItem('标题二', '内容区域二：NutUI Flutter 组件库示例'),
                        Divider(height: 0.5, color: NutUIColors.border),
                        _buildCollapseItem('标题三', '内容区域三：点击标题展开/收起内容'),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'NoticeBar 通知栏',
                children: [
                  Container(
                    color: NutUIColors.noticeDefaultBg,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Row(
                      children: [
                        NutIcon(icon: NutIcons.notice, size: 16, color: NutUIColors.noticeDefaultColor),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            '这是一条通知消息，NutUI Flutter 组件库示例',
                            style: TextStyle(fontSize: 13.sp, color: NutUIColors.noticeDefaultColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: NutIcon(icon: NutIcons.close, size: 14, color: NutUIColors.noticeDefaultColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Divider 分割线',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        Divider(height: 1, color: NutUIColors.divider),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            const Expanded(child: Divider(height: 1, color: NutUIColors.divider)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text('文字分割', style: TextStyle(fontSize: 12.sp, color: NutUIColors.textSecondary)),
                            ),
                            const Expanded(child: Divider(height: 1, color: NutUIColors.divider)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Swipe 轮播 (示例)',
                children: [
                  Container(
                    height: 160.h,
                    color: NutUIColors.primaryLight,
                    child: const Center(
                      child: Text('Swipe 轮播区域\n原生 PageView 可替代', textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: NutUIColors.primary)),
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

  Widget _buildCountdownCard(String text) {
    return Container(
      width: 40.w, height: 40.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: NutUIColors.countDownCardBg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(text, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: NutUIColors.white)),
    );
  }

  Widget _buildCircleProgress(double progress, Color color, String label) {
    return Column(
      children: [
        SizedBox(
          width: 60.w, height: 60.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60.w, height: 60.h,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: NutUIColors.circleProgressTrack,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: NutUIColors.circleProgressText)),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Text('进度', style: TextStyle(fontSize: 12.sp, color: NutUIColors.textSecondary)),
      ],
    );
  }

  Widget _buildCollapseItem(String title, String content) {
    return StatefulBuilder(
      builder: (context, setInnerState) {
        final expanded = ValueNotifier<bool>(false);
        return ValueListenableBuilder<bool>(
          valueListenable: expanded,
          builder: (context, isExpanded, child) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () => expanded.value = !isExpanded,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    color: NutUIColors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(title, style: TextStyle(fontSize: 14.sp, color: NutUIColors.collapseTitle, fontWeight: FontWeight.w500)),
                        ),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: NutIcon(icon: Icons.keyboard_arrow_down, size: 18, color: NutUIColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Container(
                    padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 14.h),
                    color: NutUIColors.white,
                    width: double.infinity,
                    child: Text(content, style: TextStyle(fontSize: 13.sp, color: NutUIColors.collapseContent)),
                  ),
                  crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
