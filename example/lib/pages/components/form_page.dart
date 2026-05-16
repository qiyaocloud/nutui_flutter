import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutui_flutter/nutui_flutter.dart';
import 'package:nutui_flutter/theme/colors.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  bool _switch = true;
  double _rate = 3;
  int _inputNumber = 1;
  String _textArea = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('表单组件')),
      backgroundColor: NutUIColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NutCellGroup(
                title: 'Switch 开关',
                children: [
                  NutCellWithBorder(
                    cell: NutCell(
                      title: '开关控制',
                      valueWidget: NutSwitch(value: _switch, onChanged: (v) => setState(() => _switch = v)),
                    ),
                    isLast: true,
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Rate 评分',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('当前评分: $_rate', style: TextStyle(fontSize: 14.sp, color: NutUIColors.textSecondary)),
                        SizedBox(height: 8.h),
                        Row(
                          children: List.generate(5, (i) {
                            final filled = i < _rate;
                            return GestureDetector(
                              onTap: () => setState(() => _rate = i + 1.0),
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: NutIcon(
                                  icon: filled ? NutIcons.starFill : NutIcons.starN,
                                  size: 28.w,
                                  color: filled ? NutUIColors.ratePrimary : NutUIColors.rateVoidColor,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'InputNumber 数字输入',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() { if (_inputNumber > 0) _inputNumber--; }),
                          child: Container(
                            width: 28.w, height: 28.w,
                            decoration: BoxDecoration(
                              border: Border.all(color: NutUIColors.border),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Icon(Icons.remove, size: 16.w),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text('$_inputNumber', style: TextStyle(fontSize: 16.sp)),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _inputNumber++),
                          child: Container(
                            width: 28.w, height: 28.w,
                            decoration: BoxDecoration(
                              color: NutUIColors.primary,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Icon(Icons.add, size: 16.w, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'TextArea 文本域',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: '请输入内容...',
                        hintStyle: TextStyle(color: NutUIColors.textPlaceholder, fontSize: 14.sp),
                        filled: true,
                        fillColor: NutUIColors.white,
                        contentPadding: EdgeInsets.all(12.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.r),
                          borderSide: BorderSide(color: NutUIColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.r),
                          borderSide: BorderSide(color: NutUIColors.border),
                        ),
                      ),
                      onChanged: (v) => setState(() => _textArea = v),
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'Checkbox 复选框 (示例)',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        _buildCheckItem('选项A'),
                        SizedBox(width: 24.w),
                        _buildCheckItem('选项B'),
                        SizedBox(width: 24.w),
                        _buildCheckItem('选项C'),
                      ],
                    ),
                  ),
                ],
              ),

              NutCellGroup(
                title: 'SearchBar 搜索栏',
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Container(
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: NutUIColors.bgGray,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 12.w),
                          NutIcon(icon: NutIcons.search, size: 16.w, color: NutUIColors.textSecondary),
                          SizedBox(width: 8.w),
                          Text('搜索商品', style: TextStyle(fontSize: 14.sp, color: NutUIColors.textPlaceholder)),
                        ],
                      ),
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

  Widget _buildCheckItem(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18.w, height: 18.w,
          decoration: BoxDecoration(
            color: NutUIColors.primary,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: NutIcon(icon: NutIcons.check, size: 12.w, color: NutUIColors.white),
        ),
        SizedBox(width: 6.w),
        Text(label, style: TextStyle(fontSize: 14.sp, color: NutUIColors.text)),
      ],
    );
  }
}
