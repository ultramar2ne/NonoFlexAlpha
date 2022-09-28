import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/navigator.dart';
import 'package:provider/provider.dart';

abstract class BlueBasePage extends StatelessWidget{
  late final BlueDialog dialog;
  late final NonoNavigatorManager navigatorManager;
  bool _isCompletedSetup = false;

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    if (!_isCompletedSetup) {
      _setUp(context);
    }
    return Container();
  }

  void _setUp(BuildContext context) {
    dialog = BlueDialog(context);
    navigatorManager = NonoNavigatorManager(Navigator.of(context));
    _isCompletedSetup = true;
  }
}

abstract class BlueBaseView<T extends BlueBaseViewModel> extends StatelessWidget{
  late final ScrollController primaryScrollController;
  late BuildContext context;
  late final T viewModel;
  bool _isCompletedSetup = false;

  // Widget drawLoadingIndicator(BlueTaskState taskStatus, {bool dark = false}) {
  //   return (taskStatus.step == TaskStep.doing && taskStatus.progress)
  //       ? TaskLoadingIndicator()
  //       : const SizedBox.shrink();
  // }

  @override
  Widget build(BuildContext context) {
    if (!_isCompletedSetup) _setUp(context);
    this.context = context;
    return PrimaryScrollController(controller: primaryScrollController, child: draw());
  }

  Widget draw();

  void _setUp(BuildContext context) {
    viewModel = Provider.of<T>(context);
    _isCompletedSetup = true;
    primaryScrollController = ScrollController();
  }
}

abstract class BlueBaseActionView <T extends BlueBaseViewModel> extends StatefulWidget{

}

abstract class BlueBaseViewModel with ChangeNotifier{
  late final BlueDialog dialog;
  late final NonoNavigatorManager navigatorManager;
  late BlueTaskState taskState;
  late BlueViewState viewState;
  bool isDisposed = false;

  BlueBaseViewModel(this.dialog,this.navigatorManager) {
    taskState = BlueTaskState(this);
    viewState = BlueViewState(this);
  }

  @override
  void dispose() {
    isDisposed = true;
    taskState.clear();
    viewState.clear();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!isDisposed) super.notifyListeners();
  }

  // 비동기 처리와 오류처리를 위한 함수
  Future<dynamic> launch(Future<dynamic> Function() body,
      {bool progress = false, Function(dynamic e)? onError}) async {
    try {
      taskState.doing(progress: progress);
      final result = await body();
      taskState.success();
      return result;
    } catch (e, stackTrace) {
      taskState.error(e: e);
      if (onError != null) {
        onError(e);
        return;
      }
      // if (kDebugMode) {
      //   dialog.alert(e.toString(), title: 'Debug message (${e.runtimeType})');
      // } else {
      //   if (!isDisposed) dialog.alert(e.toString());
      // }
    }
  }

  // 비동기 처리와 오류처리를 위한 함수
  // launch와 기능은 같지만 view 에 대한 상태변화를 반영함.
  Future<dynamic> launchWithView(Future<dynamic> Function() body,
      {bool progress = false, bool Function(dynamic r)? onFail ,Function(dynamic e)? onError}) async {
    try {
      viewState.loading();
      final result = await body();
      viewState.complete();
      return result;
    } catch (e, stackTrace) {
      viewState.error(e: e);
      if (onError != null) {
        onError(e);
        return;
      }
      // if (kDebugMode) {
      //   dialog.alert(e.toString(), title: 'Debug message (${e.runtimeType})');
      // } else {
      //   if (!isDisposed) dialog.alert(e.toString());
      // }
    }
  }
}

/// 프로세스 처리결과
class BlueTaskState {
  TaskStep step = TaskStep.none;
  String? msg;
  bool progress = false;
  BlueBaseViewModel viewModel;

  BlueTaskState(this.viewModel);

  void doing({bool progress = false}) {
    step = TaskStep.doing;
    this.progress = progress;
    viewModel.notifyListeners();
  }

  void error({String? msg, dynamic e}) {
    step = TaskStep.error;
    if (msg != null) {
      this.msg = msg;
    } else if (e != null) {
      if (e is Exception) {
        this.msg = e.toString();
      } else if (e is Error) {
        this.msg = e.toString();
      }
    }
    viewModel.notifyListeners();
  }

  void clear() {
    step = TaskStep.none;
    msg = null;
  }

  void success([String? msg]) {
    step = TaskStep.success;
    this.msg = msg;
    viewModel.notifyListeners();
  }
}
enum TaskStep { none, doing, success, error }


/// 프로세스에 따른 view의 처리결과
class BlueViewState{
  ViewState step = ViewState.none;
  String? msg;
  BlueBaseViewModel viewModel;

  BlueViewState(this.viewModel);

  void loading() {
    step = ViewState.loading;
    viewModel.notifyListeners();
  }

  void complete([String? msg]) {
    step = ViewState.complete;
    this.msg = msg;
    viewModel.notifyListeners();
  }

  void fail({String? msg = '에러 메세지'}) {
    step = ViewState.fail;
    this.msg = msg;
    viewModel.notifyListeners();
  }

  void error({String? msg, dynamic e}) {
    step = ViewState.error;
    if (msg != null) {
      this.msg = msg;
    } else if (e != null) {
      if (e is Exception) {
        this.msg = e.toString();
      } else if (e is Error) {
        this.msg = e.toString();
      }
    }
    viewModel.notifyListeners();
  }

  void clear() {
    step = ViewState.none;
    msg = null;
  }
}
enum ViewState { none, loading, complete, fail, error }