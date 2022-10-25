import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nonoflex_alpha/conf/navigator.dart';
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

abstract class BaseFormatView extends StatelessWidget {
  late BuildContext context;
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
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
    );
  }

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

enum TaskState {
  init,
  doing,
  error,
}
