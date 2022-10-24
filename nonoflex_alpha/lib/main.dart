import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/conf/navigator.dart';
import 'package:nonoflex_alpha/conf/widgets.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';
import 'package:nonoflex_alpha/view/notice/notice_list_view.dart';
import 'package:nonoflex_alpha/view/splash/splash_view.dart';

import 'conf/locator.dart';

void main() {
  setUpLocator();

  // status Bar 색상 설정
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorName.base,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));

  runApp(GetMaterialApp(
    home: SplashView(),
    debugShowCheckedModeBanner: false,
  ));
}

class TestHome extends StatelessWidget {
  final TestHomeController viewmodel = TestHomeController();

  @override
  Widget build(BuildContext context) {
    // status Bar 색상 설정
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ColorName.base,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorName.base,
        body: Center(
            child: Column(
          children: [
            BNColoredButton(
              child: const Text('노티스 목록 테스트'),
              onPressed: () => viewmodel.navigator.goNoticeListPage(),
            ),
            BNTextButton(
              '텍스트버튼 테슽트',
              // child: const Text('노티스 목록 테스트'),
              onPressed: () => viewmodel.navigator.goNoticeListPage(),
            ),
            BNOutlinedButton(
              child: const Text('노티스 목록 테스트'),
              onPressed: () => viewmodel.navigator.goNoticeListPage(),
            ),
          ],
        )),
      ),
    );
  }
}

class TestHomeController extends GetxController {
  final navigator = NonoNavigatorManager();
}

class NonoFlexApp extends StatelessWidget {
  const NonoFlexApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home:
    );
  }
}

// class GetTestHome extends StatelessWidget {
//   final Controller c = Get.put(Controller());
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
//
//     // Get.put()을 사용하여 클래스를 인스턴스화하여 모든 child 에서 사용 가능 ...?
//     // final Controller c = Get.put(Controller());
//
//     return Scaffold(
//       // count가 변경될 때 마다 Obx(()=> 를 사용하여 Text()에 없데이트함
//       appBar: AppBar(
//           title: Obx(() => Text('data: ${c.count}')),
//           backgroundColor: ColorName.base,
//           elevation: 0,
//           systemOverlayStyle: SystemUiOverlayStyle(
//               statusBarColor: ColorName.base,
//               statusBarBrightness: Brightness.dark,
//               statusBarIconBrightness: Brightness.dark)),
//
//       // 8줄의 navigator.push를 간단한 Get.to()로 변경함. context는 필요 없음
//       body: Center(
//           child: Column(
//         children: [
//           ElevatedButton(
//             child: Text('가자 다음페이지'),
//             onPressed: () => Get.to(
//                 NoticeListView(),
//             ),
//           ),
//           ElevatedButton(
//             child: Text('노티스 목록 테스트'),
//             // onPressed: () => Get.to(NoticeListView()),
//             onPressed: () => Get.toNamed('/notice'),
//           ),
//           ElevatedButton(
//             child: Text('노티스 목록 테스트 네비게이터 짱짱맨'),
//             // onPressed: () => Get.to(NoticeListView()),
//             onPressed: () => NonoNavigatorManager().goNoticePage(),
//           )
//         ],
//       )),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () => c.increment(),
//       ),
//     );
//   }
// }
//
// class Other extends StatelessWidget {
//   // 다른 페이지에서 사용되는 컨트롤러를 Get으로 찾아서 redirect 할 수 있다.
//   final Controller c = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text("${c.count}"),
//       ),
//     );
//   }
// }

// class Controller extends GetxController {
//   var count = 0.obs;
//
//   increment() => count++;
// }
