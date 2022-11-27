import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/conf/navigator.dart';
import 'package:nonoflex_alpha/conf/ui/theme.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';

abstract class BaseGetView<T> extends StatelessWidget {
  final theme = locator.get<BNTheme>();
  final logger = locator.get<BNTheme>();

  BaseGetView({Key? key}) : super(key: key);

  final String? tag = null;

  T get controller => GetInstance().find<T>(tag: tag)!;

  @override
  Widget build(BuildContext context) {
    if (controller is! BaseController) return _defaultErrorView('');

    BaseController _controller = controller as BaseController;
    return _controller.obx(
      (state) => Stack(
        children: [
          Scaffold(
            backgroundColor: theme.base,
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
            bottomNavigationBar: bottomNavigationBar(),
          ),

          /// api 요청 등, 로직 중 포함된 로딩 인디케이터
          Obx(() =>
              Visibility(visible: _controller.isLoading.value, child: _defaultLoadingIndicator()))
        ],
      ),
      onLoading: _defaultLoadingIndicator(),
      onEmpty: _defaultEmptyView(),
      onError: (errorMessage) => _defaultErrorView(errorMessage),
    );
  }

  AppBar? defaultAppBar() => null;

  Widget? bottomNavigationBar() => null;

  Widget drawHeader() => const SizedBox.shrink();

  Widget drawBody() => const SizedBox.shrink();

  Widget drawFooter() => const SizedBox.shrink();
}

extension BaseGetViewDefaultWidget on BaseGetView {
  Widget _defaultLoadingIndicator() => Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          color: ColorName.primary,
          strokeWidth: 50,
        ),
      );

  Widget _defaultEmptyView() => Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Text('commonEmptyView'.tr),
      );

  Widget _defaultErrorView(String? errorMessage) => Center(
        child: Text(errorMessage ?? 'commonErrorView'.tr),
      );
}

abstract class BaseController extends GetxController with StateMixin {
  final logger = Logger();
  final NonoNavigatorManager baseNavigator = NonoNavigatorManager();

  /// task status
  bool isInited = false;
  var isLoading = false.obs;

  void completeInitialize({String? errorMessage}) {
    if (errorMessage != null) {
      change(null, status: RxStatus.error(errorMessage));
    }
    change(null, status: RxStatus.success());
  }

  updateLoadingState(bool state) => isLoading.value = state;

  void changeViewState(TaskState taskState,
      {bool wholeScreen = false, String? errorMessage, String? toastMessage}) {
    // if(toastMessage!= null)

    updateLoadingState(taskState == TaskState.doing);
    switch (taskState) {
      case TaskState.success:
        change(null, status: RxStatus.success());
        break;
      case TaskState.doing:
        if (wholeScreen) {
          change(null, status: RxStatus.loading());
        }
        break;
      case TaskState.empty:
        change(null, status: RxStatus.empty());
        break;
      case TaskState.error:
        Get.dialog(AlertDialog())
        if (wholeScreen) {
          change(null, status: RxStatus.error(errorMessage));
        }
        break;
    }
  }
}

enum TaskState {
  success,
  doing,
  empty,
  error,
}
