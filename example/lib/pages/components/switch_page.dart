import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutui_flutter/nutui_flutter.dart';
import 'package:nutui_flutter/theme/colors.dart';

class SwitchPage extends StatefulWidget {
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  bool _basic = true;
  bool _disabled = false;
  bool _disabledOn = true;
  bool _customColor = true;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Switch 开关')),
      backgroundColor: NutUIColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NutCellGroup(
                title: '基础用法',
                children: [
                  NutCellWithBorder(
                    cell: NutCell(
                      title: '开关',
                      valueWidget: NutSwitch(value: _basic, onChanged: (v) => setState(() => _basic = v)),
                    ),
                  ),
                  NutCellWithBorder(
                    cell: NutCell(
                      title: '禁用状态',
                      valueWidget: NutSwitch(value: _disabled, disabled: true, onChanged: (v) => setState(() => _disabled = v)),
                    ),
                    isLast: true,
                  ),
                ],
              ),

              NutCellGroup(
                title: '禁用与开启',
                children: [
                  NutCellWithBorder(
                    cell: NutCell(
                      title: '禁用且开启',
                      valueWidget: NutSwitch(value: _disabledOn, disabled: true, onChanged: (v) => setState(() => _disabledOn = v)),
                    ),
                    isLast: true,
                  ),
                ],
              ),

              NutCellGroup(
                title: '自定义颜色',
                children: [
                  NutCellWithBorder(
                    cell: NutCell(
                      title: '自定义颜色',
                      valueWidget: NutSwitch(
                        value: _customColor,
                        activeColor: NutUIColors.success,
                        onChanged: (v) => setState(() => _customColor = v),
                      ),
                    ),
                    isLast: true,
                  ),
                ],
              ),

              NutCellGroup(
                title: '加载状态',
                children: [
                  NutCellWithBorder(
                    cell: NutCell(
                      title: '加载中',
                      valueWidget: NutSwitch(value: _loading, loading: true, onChanged: (v) => setState(() => _loading = v)),
                    ),
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
