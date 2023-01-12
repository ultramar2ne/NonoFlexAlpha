import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nonoflex_alpha/conf/config.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/conf/manager/auth_manager.dart';
import 'package:nonoflex_alpha/conf/navigator.dart';
import 'package:nonoflex_alpha/conf/ui/theme.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';

abstract class BaseGetView<T> extends StatelessWidget {
  final theme = locator.get<BNTheme>();
  final logger = locator.get<Logger>();

  BuildContext? currentContext;

  BaseGetView({Key? key}) : super(key: key);

  final String? tag = null;

  T get controller => GetInstance().find<T>(tag: tag)!;

  @override
  Widget build(BuildContext context) {
    currentContext ??= context;
    // currentContext = context;
    if (controller is! BaseController) return _defaultErrorView('');
    BaseController _controller = controller as BaseController;
    return WillPopScope(
      onWillPop: () async {
        final result = await willPopCallback();
        return result ?? true;
      },
      child: _controller.obx(
        (state) => Stack(
          children: [
            Scaffold(
              backgroundColor: theme.base,
              appBar: defaultAppBar(),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }

  Future<bool>? willPopCallback() => null;

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
  final NonoNavigatorManager baseNavigator;
  final configs = locator.get<Configs>();
  final logger = locator.get<Logger>();

  /// task status
  bool isInited = false;
  var isLoading = false.obs;

  BaseController({NonoNavigatorManager? navigatorManager, bool loadingComplete = true})
      : baseNavigator = navigatorManager ?? NonoNavigatorManager() {
    /// isLoading이 true일 경우 반드시 초기 로딩이 끝난 뒤 [completeInitialize]를 호출하여 로딩 화면을 종료해야한다.
    if (loadingComplete) completeInitialize();
  }

  // 초기화 과정을 종료한다.
  // 최초 초기화 과정을 의미하며, 로딩중일경우 전체 페이지에 로딩화면이 나타난다.
  void completeInitialize({String? errorMessage}) {
    if (errorMessage != null) {
      change(null, status: RxStatus.error(errorMessage));
    }
    change(null, status: RxStatus.success());
  }

  // view에 로딩인디케이터 표시 여부를 업데이트.
  updateLoadingState(bool state) => isLoading.value = state;

  // view의 동작 상태를 변경한다.
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
        // Get.dialog(AlertDialog())
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
