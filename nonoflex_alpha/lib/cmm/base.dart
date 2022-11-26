import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nonoflex_alpha/conf/navigator.dart';
import 'package:nonoflex_alpha/conf/ui/theme.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';

abstract class BaseView extends StatelessWidget {
  final logger = Logger();

  BaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return draw();
  }

  Widget draw() => const SizedBox.shrink();
}

// abstract class BaseGetView<T> extends StatelessWidget {
//   const BaseGetView({Key? key}) : super(key: key);
//
//   final String? tag = null;
//
//   T get controller => GetInstance().find<T>(tag: tag)!;
//
// }

abstract class BaseFormatView extends StatelessWidget {
  late BuildContext context;
  final BNTheme theme = LightTheme();
  final logger = Logger();

  final stateController = Get.put(BaseViewController());

  @override
  Widget build(BuildContext context) {
    this.context = context;
    stateController.updateLoadingState(false);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: backgroundColor(),
          appBar: defaultAppBar(),
          body: SafeArea(
            child: Column(
              children: [
                drawHeader(),
                Expanded(child: drawBody()),
                drawFooter(),
              ],
            ),
          ),
        ),
        Obx(
          () => Visibility(
            visible: stateController.isLoading.value,
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: ColorName.primary,
                strokeWidth: 50,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool touchOutMode = false;

  Color backgroundColor() => ColorName.base;

  AppBar? defaultAppBar() => null;

  Widget drawHeader() => const SizedBox.shrink();

  Widget drawBody() => const SizedBox.shrink();

  Widget drawFooter() => const SizedBox.shrink();
}

abstract class BaseViewModel extends GetxController {
  final logger = Logger();

  final NonoNavigatorManager navigator = NonoNavigatorManager();
}

// BaseView의 상태를 관리한다.
class BaseViewController extends GetxController {
  var isLoading = false.obs;

  updateLoadingState(bool state) => isLoading.value = state;
}

enum TaskState {
  init,
  doing,
  error,
}
