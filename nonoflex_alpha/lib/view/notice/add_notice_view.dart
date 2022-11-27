import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';
import 'package:nonoflex_alpha/view/notice/add_notice_viewmodel.dart';

import 'package:get/get.dart';
import '../../cmm/base.dart';

class AddNoticeView extends BaseGetView<AddNoticeViewModel> {
  AddNoticeViewModel viewmodel = AddNoticeViewModel();

  @override
  AppBar defaultAppBar() {
    return AppBar(
      title: const Text('공지사항 추가'),
      backgroundColor: ColorName.base,
      foregroundColor: ColorName.primary,
      elevation: 0,
    );
  }

  @override
  Widget drawBody() {
    return Container(
      height: 300,
      child: TextFormField(
      ),
    );
  }

  @override
  Widget drawFooter() {
    return SizedBox(
      height: 82,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Expanded(
          child: BNColoredButton(
            child: Text('헬로 안녕'),
            onPressed: () => viewmodel.submit(),
          ),
        ),
      ),
    );
  }
}