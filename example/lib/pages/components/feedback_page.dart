import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutui_flutter/nutui_flutter.dart';
import 'package:nutui_flutter/theme/colors.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('反馈组件')),
      backgroundColor: NutUIColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NutCellGroup(
                title: 'Dialog 对话框',
                children: [
                  NutCellWithBorder(
                    cell: NutCell(
                      title: ' Alert 提示对话框',
                      isLink: true,
                      onTap: () => NutDialog.alert(context, title: '提示', content: '这是一个提示对话框'),
                    ),
                  ),
                  NutCellWithBorder(
                    cell: NutCell(
                      title: ' Confirm 确认对话框',
                      isLink: true,
                      onTap: () => NutDialog.confirm(context, title: '确认', content: '确定要执行此操作吗？'),
                    ),
                    isLast: true,
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Toast 轻提示',
                children: [
                  NutCellWithBorder(
                    cell: NutCell(
                      title: '文字提示',
                      isLink: true,
                      onTap: () => NutToast.text(context, '这是一条文字提示'),
                    ),
                  ),
                  NutCellWithBorder(
                    cell: NutCell(
                      title: '成功提示',
                      isLink: true,
                      onTap: () => NutToast.success(context, '操作成功'),
                    ),
                  ),
                  NutCellWithBorder(
                    cell: NutCell(
                      title: '失败提示',
                      isLink: true,
                      onTap: () => NutToast.fail(context, '操作失败'),
                    ),
                  ),
                  NutCellWithBorder(
                    cell: NutCell(
                      title: '加载中',
                      isLink: true,
                      onTap: () {
                        NutToast.loading(context);
                        Future.delayed(const Duration(seconds: 2), () => NutToast.close());
                      },
                    ),
                    isLast: true,
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Popup 弹出层',
                children: [
                  NutCellWithBorder(
                    cell: NutCell(
                      title: '底部弹出',
                      isLink: true,
                      onTap: () => NutPopup.show(
                        context: context,
                        position: NutPopupPosition.bottom,
                        child: Container(
                          height: 300.h,
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            children: [
                              Text('底部弹出层', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
                              SizedBox(height: 16.h),
                              Text('点击遮罩层或空白区域关闭'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  NutCellWithBorder(
                    cell: NutCell(
                      title: '居中弹出',
                      isLink: true,
                      onTap: () => NutPopup.show(
                        context: context,
                        position: NutPopupPosition.center,
                        round: true,
                        child: Container(
                          width: 280.w,
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('居中弹出层', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
                              SizedBox(height: 16.h),
                              Text('这是一个居中弹出的示例'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  NutCellWithBorder(
                    cell: NutCell(
                      title: '顶部弹出',
                      isLink: true,
                      onTap: () => NutPopup.show(
                        context: context,
                        position: NutPopupPosition.top,
                        round: true,
                        child: Container(
                          height: 200.h,
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            children: [
                              Text('顶部弹出层', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
                              SizedBox(height: 16.h),
                              Text('从顶部滑入的弹出层'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    isLast: true,
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Loading 加载',
                children: [
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 24.w, height: 24.w,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: NutUIColors.primary),
                            ),
                            SizedBox(height: 8.h),
                            Text('加载中...', style: TextStyle(fontSize: 12.sp, color: NutUIColors.textSecondary)),
                          ],
                        ),
                        Column(
                          children: [
                            NutIcon(icon: NutIcons.loading, size: 28.w, color: NutUIColors.primary),
                            SizedBox(height: 8.h),
                            Text('加载中...', style: TextStyle(fontSize: 12.sp, color: NutUIColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Empty 空状态',
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    color: NutUIColors.white,
                    child: Column(
                      children: [
                        NutIcon(icon: NutIcons.find, size: 80.w, color: NutUIColors.textDisabled),
                        SizedBox(height: 16.h),
                        Text('暂无数据', style: TextStyle(fontSize: 14.sp, color: NutUIColors.textSecondary)),
                        SizedBox(height: 16.h),
                        NutButton(text: '重新加载', type: NutButtonType.primary, size: NutButtonSize.small),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Skeleton 骨架屏',
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    color: NutUIColors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40.w, height: 40.w,
                              decoration: BoxDecoration(
                                color: NutUIColors.shimmerBase,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120.w, height: 14.h,
                                  decoration: BoxDecoration(
                                    color: NutUIColors.shimmerBase,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  width: 80.w, height: 10.h,
                                  decoration: BoxDecoration(
                                    color: NutUIColors.shimmerBase,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          width: double.infinity, height: 14.h,
                          decoration: BoxDecoration(
                            color: NutUIColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: double.infinity * 0.7, height: 14.h,
                          decoration: BoxDecoration(
                            color: NutUIColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
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
