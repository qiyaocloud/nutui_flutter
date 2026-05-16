import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../icon/icon.dart';

// 头像形状
enum NutAvatarShape {
  circle,
  square,
}

// 头像预设尺寸
enum NutAvatarSize {
  large,
  normal,
  small
}

class NutAvatar extends StatelessWidget {
  // 图片地址（网络URL或本地路径）
  final String? url;

  // 图标（url优先级高于icon）
  final IconData? icon;

  // 文字 (通常传1-2个字符，url和icon优先级高于text)
  final String? text;

  // 尺寸类型 (与自定义size互斥)
  final NutAvatarSize sizeType;

  // 自定义尺寸 (设置此项 sizeType 失效)
  final double? size;

  // 形状
  final NutAvatarShape shape;

  // 背景颜色 (仅在显示 icon 或 text 时生效)
  final Color bgColor;

  // 文字/图标颜色
  final Color contentColor;

  // 边框
  final BoxBorder? border;

  const NutAvatar({
    super.key,
    this.url,
    this.icon,
    this.text,
    this.sizeType = NutAvatarSize.normal,
    this.size,
    this.shape = NutAvatarShape.circle,
    this.bgColor = NutUIColors.avatarDefaultBg,
    this.contentColor = NutUIColors.white,
    this.border,
  });

  // 获取实际渲染尺寸
  double get _avatarSize {
    if (size != null) return size!;
    switch (sizeType) {
      case NutAvatarSize.large: return 48;
      case NutAvatarSize.normal: return 40;
      case NutAvatarSize.small: return 28;
    }
  }

  // 获取圆角
  BorderRadius get _borderRadius {
    if (shape == NutAvatarShape.circle) {
      return BorderRadius.circular(_avatarSize / 2);
    } else {
      return BorderRadius.circular(4); // 方形微圆角
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _avatarSize,
      height: _avatarSize,
      decoration: BoxDecoration(
        color: (url != null) ? null : bgColor,
        border: border,
        borderRadius: _borderRadius,
        image: url != null
          ? DecorationImage(
            image: NetworkImage(url!),
            fit: BoxFit.cover,
        ) : null,
      ),
      alignment: Alignment.center,
      // 有图片时不再显示子组件
      child: url != null ? null : _buildContent(),
    );
  }

  // 渲染图标或文字
  Widget? _buildContent() {
    if (icon != null) {
      return NutIcon(
        icon: icon!,
        size: _avatarSize * 0.5, // 图标占头像一半大小
        color: contentColor,
      );
    }

    if (text != null && text!.isNotEmpty) {
      return Text(
        text!,
        style: TextStyle(
          fontSize: _avatarSize * 0.4, // 字体大小自适应
          color: contentColor,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return null;
  }
}

class NutAvatarGroup extends StatelessWidget {
  // 头像列表
  final List<Widget> children;

  // 头像之间的重叠距离 (正值表示重叠，负值表示间距)
  final double span;

  // 最大显示数量 (超出部分显示 +N)
  final int? maxCount;

  // 叠加方向（从左到右）
  final bool right;

  const NutAvatarGroup({
    super.key,
    required this.children,
    this.span = 10,
    this.maxCount,
    this.right = true,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> displayChildren = children;
    int remainingCount = 0;

    // 处理最大数量截断
    if (maxCount != null && children.length > maxCount!) {
      displayChildren = children.sublist(0, maxCount!);
      remainingCount = children.length - maxCount!;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(displayChildren.length + (remainingCount > 0 ? 1 : 0), (index) {
        bool isLast = index == displayChildren.length && remainingCount > 0;

        // 头像叠放效果：除第一个外，都向左偏移
        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 0 : span,
          ),
          child: isLast
            ? _buildRemainingAvatar(remainingCount)
            : Container(
              // 给后续叠放的头像加白色边框，区分层次
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: NutUIColors.white, width: 2),
              ),
              child: displayChildren[index],
          ),
        );
      }),
    );
  }

  // 构建 "+N" 头像
  Widget _buildRemainingAvatar(int count) {
    // 尝试获取前面头像的尺寸，这里简单使用 NutAvatarSize.normal
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: NutUIColors.white,
      ),
      child: NutAvatar(
        text: '+$count',
        bgColor: const Color(0xFFE8E8E8),
        contentColor: const Color(0xFF969799),
        shape: NutAvatarShape.circle,
      ),
    );
  }
}