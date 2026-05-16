import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class NutCountDownController extends ChangeNotifier {
  _NutCountDownState? _state;

  void _attach(_NutCountDownState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  // 开始倒计时
  void start() {
    _state?.start();
  }

  // 暂停倒计时
  void pause() {
    _state?.pause();
  }

  // 重置倒计时 (重置为初始时间并暂停)
  void reset() {
    _state?.reset();
  }

  // 重新开始 (重置为初始时间并立即开始)
  void restart() {
    _state?.restart();
  }
}

// 倒计时展示模式
enum NutCountDownMode {
  text,
  card
}

class NutCountDown extends StatefulWidget {
  // 总倒计时时间(单位：毫秒)
  final int time;

  // 展示格式 (DD-天, HH-时, mm-分, ss-秒, S-毫秒(十分之一秒))
  final String format;

  // 是否自动开始
  final bool autoStart;

  // 倒计时展示模式
  final NutCountDownMode mode;

  // 控制器
  final NutCountDownController? controller;

  // 倒计时结束回调
  final VoidCallback? onFinish;

  // 倒计时变化回调 (返回剩余毫秒数)
  final ValueChanged<int>? onChange;

  // 文本模式样式
  final TextStyle? textStyle;
  final TextStyle? separatorStyle;

  // 卡片模式样式
  final double cardWidth;
  final double cardHeight;
  final BorderRadius cardBorderRadius;
  final Color cardBackgroundColor;
  final TextStyle? cardTextStyle;

  const NutCountDown({
    super.key,
    required this.time,
    this.format = 'HH:mm:ss',
    this.autoStart = true,
    this.mode = NutCountDownMode.text,
    this.controller,
    this.onFinish,
    this.onChange,
    this.textStyle,
    this.separatorStyle,
    this.cardWidth = 22,
    this.cardHeight = 22,
    this.cardBorderRadius = const BorderRadius.all(Radius.circular(4)),
    this.cardBackgroundColor = NutUIColors.countDownCardBg,
    this.cardTextStyle,
  });

  @override
  State<NutCountDown> createState() => _NutCountDownState();
}

class _NutCountDownState extends State<NutCountDown> {
  // 剩余时间(毫秒)
  late int _remainingTime;

  // 结束时间点
  DateTime? _endTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.time;
    widget.controller?._attach(this);

    if (widget.autoStart) {
      start();
    }
  }

  @override
  void didUpdateWidget(covariant NutCountDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果外部更新了总时间，重置状态
    if (oldWidget.time != widget.time) {
      reset();
      if (widget.autoStart) start();
    }
    // 绑定新 Controller
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    widget.controller?._detach();
  }

  void start() {
    if (_timer != null) return; // 已在运行
    if (_remainingTime <= 0) return; // 已结束

    _endTime = DateTime.now().add(Duration(milliseconds: _remainingTime));
    _tick();
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    _endTime = null; // 暂停时清除结束时间点
  }

  void reset() {
    pause();
    setState(() {
      _remainingTime = widget.time;
    });
  }

  void restart() {
    pause();
    setState(() {
      _remainingTime = widget.time;
    });
    start();
  }

  // 核心计时逻辑
  void _tick() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_endTime == null) {
        timer.cancel();
        return;
      }

      final now = DateTime.now();
      final diff = _endTime!.difference(now).inMilliseconds;

      if (diff <= 0) {
        timer.cancel();
        _timer = null;
        if (mounted) {
          setState(() => _remainingTime = 0);
          widget.onFinish?.call();
        }
      } else {
        // 只有当秒数发生变化时才刷新 UI (优化性能)
        if ((diff ~/ 100) != (_remainingTime ~/ 1000) || diff % 1000 >= 900) {
          if (mounted) {
            setState(() => _remainingTime = diff);
            widget.onChange?.call(diff);
          }
        }
      }
    });
  }

  // 时间解析与格式化
  Map<String, String> _parseTime() {
    int totalSeconds = _remainingTime ~/ 1000;
    int days = totalSeconds ~/ (24 * 3600);
    int hours = (totalSeconds ~/ 3600) % 24;
    int minutes = (totalSeconds ~/ 60) % 60;
    int seconds = totalSeconds % 60;
    int millis = (_remainingTime % 1000) ~/ 100; // 取十分之一秒

    return {
      'DD': days.toString().padLeft(2, '0'),
      'HH': hours.toString().padLeft(2, '0'),
      'mm': minutes.toString().padLeft(2, '0'),
      'ss': seconds.toString().padLeft(2, '0'),
      'S': millis.toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final timeMap = _parseTime();

    if (widget.mode == NutCountDownMode.card) {
      return _buildCardMode(timeMap);
    }
    return _buildTextMode(timeMap);
  }

  // 文本模式渲染
  Widget _buildTextMode(Map<String, String> timeMap) {
    // 正则切割 format: 'HH:mm:ss' -> ['HH', ':', 'mm', ':', 'ss']
    final regExp = RegExp(r'(DD|HH|mm|ss|S)');
    final parts = widget.format.split(regExp);

    TextStyle defaultStyle = widget.textStyle ?? const TextStyle(fontSize: 16, color: NutUIColors.text, fontWeight: FontWeight.bold);
    TextStyle sepStyle = widget.separatorStyle ?? TextStyle(fontSize: defaultStyle.fontSize, color: NutUIColors.countDownSeparator, fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: parts.map((part) {
        if (regExp.hasMatch(part)) {
          return Text(timeMap[part] ?? '', style: defaultStyle);
        } else {
          return Text(part, style: sepStyle);
        }
      }).toList(),
    );
  }

  // 卡片模式渲染
  Widget _buildCardMode(Map<String, String> timeMap) {
    final regExp = RegExp(r'(DD|HH|mm|ss|S)');
    final parts = widget.format.split(regExp);

    TextStyle defaultCardTextStyle = widget.cardTextStyle ??
      TextStyle(
        fontSize: widget.cardHeight * 0.6,
        color: NutUIColors.text,
        fontWeight: FontWeight.bold
      );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: parts.map((part) {
        if (regExp.hasMatch(part)) {
          // 渲染数字卡片
          return Container(
            width: widget.cardWidth,
            height: widget.cardHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.cardBackgroundColor,
              borderRadius: widget.cardBorderRadius,
            ),
            child: Text(timeMap[part] ?? '', style: defaultCardTextStyle),
          );
        } else if (part.isNotEmpty) {
          // 渲染分隔符
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(part, style: TextStyle(
              fontSize: widget.cardHeight * 0.6,
              color: NutUIColors.countDownSeparator,
              fontWeight: FontWeight.bold,
            )),
          );
        } else {
          return const SizedBox.shrink();
        }
      }).toList(),
    );
  }
}