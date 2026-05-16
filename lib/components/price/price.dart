import 'package:flutter/material.dart';
import 'package:nutui_flutter/theme/colors.dart';

// 价格尺寸
enum NutPriceSize {
  small,
  normal,
  large
}

// 符号位置
enum NutSymbolPosition {
  before,
  after
}

class NutPrice extends StatelessWidget {
  // 价格数值
  final num price;

  // 货币符号
  final String symbol;

  // 小数位位数
  final int decimalLength;

  // 是否千分位分割
  final bool thousands;

  // 尺寸
  final NutPriceSize size;

  // 是否显示删除线
  final bool strikeThrough;

  // 是否显示货币符号
  final bool needSymbol;

  // 符号位置
  final NutSymbolPosition position;

  // 自定义颜色
  final Color? color;

  const NutPrice({
    super.key,
    required this.price,
    this.symbol = '¥',
    this.decimalLength = 2,
    this.thousands = false,
    this.size = NutPriceSize.normal,
    this.strikeThrough = false,
    this.needSymbol = true,
    this.position = NutSymbolPosition.before,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // 获取基础样式配置
    final color = this.color ?? NutUIColors.primary;
    final baseFontSize = _getBaseFontSize();
    final smallFontSize = (baseFontSize * 0.65).roundToDouble(); // 符号和小数字体大小

    // 文本装饰（删除线）
    final decoration = strikeThrough ? TextDecoration.lineThrough : TextDecoration.none;

    // 处理价格数字文本
    String priceText = _formatPrice(price, decimalLength, thousands);
    List<String> parts = priceText.split('.');
    String integerPart = parts[0];
    // 确保小数部分存在且长度符合要求
    String decimalPart = (parts.length > 1 ? parts[1] : '').padRight(decimalLength, '0');

    // 组装子组件
    List<Widget> children = [];

    // 符号组件
    Widget symbolWidget = Text(
      symbol,
      style: TextStyle(
        fontSize: smallFontSize,
        color: color,
        decoration: decoration,
        fontWeight: FontWeight.bold,
      ),
    );

    // 整数部分组件
    Widget integerWidget = Text(
      integerPart,
      style: TextStyle(
        fontSize: baseFontSize,
        color: color,
        decoration: decoration,
        fontWeight: FontWeight.bold,
      ),
    );

    // 小数部分组件 (如果有小数位)
    Widget? decimalWidget;
    if (decimalLength > 0) {
      decimalWidget = Text(
        '.$decimalPart',
        style: TextStyle(
          fontSize: smallFontSize,
          color: color,
          decoration: decoration,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // 根据位置拼装
    if (needSymbol && position == NutSymbolPosition.before) {
      children.add(symbolWidget);
    }

    children.add(integerWidget);

    if (decimalWidget != null) {
      children.add(decimalWidget);
    }

    if (needSymbol && position == NutSymbolPosition.after) {
      children.add(symbolWidget);
    }

    // 渲染 Row，核心：使用 baseline 对齐
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline, // 基线对齐
      textBaseline: TextBaseline.alphabetic, // 必须指定 textBaseline
      children: children,
    );
  }

  // 获取基础字体大小
  double _getBaseFontSize() {
    switch (size) {
      case NutPriceSize.large: return 24.0;
      case NutPriceSize.normal: return 16.0;
      case NutPriceSize.small: return 12.0;
    }
  }

  // 格式化价格数字 (处理千分位和小数位)
  String _formatPrice(num value, int length, bool split) {
    // 分离整数和小数
    String str = value.abs().toString(); // 处理绝对值，负号单独处理或忽略
    List<String> parts = str.split('.');

    String integer = parts[0];
    String decimal = parts.length > 1 ? parts[1] : '';

    // 截断/补齐小数位
    if (decimal.length > length) {
      decimal = decimal.substring(0, length);
    } else if (decimal.length < length) {
      decimal = decimal.padRight(length, '0');
    }

    // 处理千分位
    if (split) {
      integer = _addThousandSeparator(integer);
    }

    return length > 0 ? '$integer.$decimal' : integer;
  }

  // 千分位添加逗号 (正则表达式法)
  String _addThousandSeparator(String text) {
    // \B 匹配非单词边界，(?=(\d{3})+(?!\d)) 匹配后面跟着3的倍数个数字且后面不再跟数字的位置
    return text.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
    );
  }
}