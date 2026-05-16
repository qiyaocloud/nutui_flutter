import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutui_flutter/theme/colors.dart';

import 'controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NutUI Flutter 组件库'),
      ),
      body: ListView(
        children: [

        ],
      ),
    );
  }

}