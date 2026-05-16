import 'package:get/get.dart';
import 'package:nutui_flutter_example/pages/home/view.dart';
import 'package:nutui_flutter_example/pages/components/button_page.dart';
import 'package:nutui_flutter_example/pages/components/cell_page.dart';
import 'package:nutui_flutter_example/pages/components/icon_page.dart';
import 'package:nutui_flutter_example/pages/components/tag_page.dart';
import 'package:nutui_flutter_example/pages/components/avatar_page.dart';
import 'package:nutui_flutter_example/pages/components/badge_page.dart';
import 'package:nutui_flutter_example/pages/components/switch_page.dart';
import 'package:nutui_flutter_example/pages/components/form_page.dart';
import 'package:nutui_flutter_example/pages/components/feedback_page.dart';
import 'package:nutui_flutter_example/pages/components/nav_page.dart';
import 'package:nutui_flutter_example/pages/components/display_page.dart';

class Routes {
  static final List<GetPage<dynamic>> getPages = [
    GetPage(name: '/', page: () => const MainView()),
    GetPage(name: '/components/button', page: () => const ButtonPage()),
    GetPage(name: '/components/cell', page: () => const CellPage()),
    GetPage(name: '/components/icon', page: () => const IconPage()),
    GetPage(name: '/components/tag', page: () => const TagPage()),
    GetPage(name: '/components/avatar', page: () => const AvatarPage()),
    GetPage(name: '/components/badge', page: () => const BadgePage()),
    GetPage(name: '/components/switch', page: () => const SwitchPage()),
    GetPage(name: '/components/form', page: () => const FormPage()),
    GetPage(name: '/components/feedback', page: () => const FeedbackPage()),
    GetPage(name: '/components/nav', page: () => const NavPage()),
    GetPage(name: '/components/display', page: () => const DisplayPage()),
  ];
}
