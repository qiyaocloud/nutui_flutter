import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutui_flutter/nutui_flutter.dart';
import 'package:nutui_flutter/theme/colors.dart';

class AvatarPage extends StatelessWidget {
  const AvatarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Avatar 头像')),
      backgroundColor: NutUIColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NutCellGroup(
                title: '基础用法',
                children: [
                  _buildRow([
                    const NutAvatar(text: '王'),
                    const NutAvatar(icon: NutIcons.my),
                    const NutAvatar(
                      url: 'https://img12.360buyimg.com/imagetools/jfs/t1/143702/31/16654/116794/5fc6f541Edebf8a57/4138097748889987.png',
                    ),
                  ]),
                ],
              ),

              NutCellGroup(
                title: '头像形状',
                children: [
                  _buildRow([
                    const NutAvatar(text: '圆', shape: NutAvatarShape.circle),
                    const NutAvatar(text: '方', shape: NutAvatarShape.square),
                  ]),
                ],
              ),

              NutCellGroup(
                title: '头像尺寸',
                children: [
                  _buildRow([
                    const NutAvatar(text: '大', sizeType: NutAvatarSize.large),
                    const NutAvatar(text: '中', sizeType: NutAvatarSize.normal),
                    const NutAvatar(text: '小', sizeType: NutAvatarSize.small),
                    const NutAvatar(text: 'N', size: 60),
                  ]),
                ],
              ),

              NutCellGroup(
                title: '自定义颜色',
                children: [
                  _buildRow([
                    const NutAvatar(text: '王', bgColor: NutUIColors.primary, contentColor: NutUIColors.white),
                    const NutAvatar(icon: NutIcons.my, bgColor: NutUIColors.success),
                    const NutAvatar(text: '张', bgColor: NutUIColors.warning),
                    const NutAvatar(icon: NutIcons.heart, bgColor: NutUIColors.info),
                  ]),
                ],
              ),

              NutCellGroup(
                title: '头像组',
                desc: '支持叠加显示和 +N 截断',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: NutAvatarGroup(
                      span: 12,
                      maxCount: 4,
                      children: const [
                        NutAvatar(text: '王'),
                        NutAvatar(text: '张'),
                        NutAvatar(text: '李'),
                        NutAvatar(text: '陈'),
                        NutAvatar(text: '刘'),
                        NutAvatar(text: '周'),
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

  Widget _buildRow(List<Widget> avatars) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: avatars,
      ),
    );
  }
}
