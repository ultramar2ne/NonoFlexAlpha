import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/view/notice/notice_detail_viewmodel.dart';

import 'package:intl/intl.dart';

import '../../cmm/base.dart';

class NoticeDetailView extends BaseView {
  NoticeDetailViewModel viewModel = NoticeDetailViewModel();

  @override
  Widget build(BuildContext context) {
    // Get.put()을 사용하여 클래스를 인스턴스화하여 모든 child 에서 사용 가능 ...?

    return Obx(() => Scaffold(
      // count가 변경될 때 마다 Obx(()=> 를 사용하여 Text()에 없데이트함
      appBar: AppBar(
        title: Center(child: Text('상세 보기')),
        backgroundColor: ColorName.base,
        foregroundColor: ColorName.primary,
        actions: [
          IconButton(onPressed: () => viewModel.navigator.goAddNoticePage(), icon: Icon(Icons.add)),
        ],
        elevation: 0,
      ),

      // 8줄의 navigator.push를 간단한 Get.to()로 변경함. context는 필요 없음
      body: Column(
        children: [
          _drawHeader(),
          Expanded(child: _drawBody()),
          _drawFooter(),
        ],
      ),
    ));
  }

  Widget _drawHeader() {
    return SizedBox.shrink();
  }

  Widget _drawBody() {
    final notice = viewModel.notice;

    if (notice == null) return const SizedBox.shrink();

    return Center(
      child: Column(
        children: [
          Text(notice.value?.title ?? ''),
          Text(notice.value?.content ?? ''),
          Text(notice.value?.writer ?? ''),
        ],
      ),
    );
  }

  Widget _drawFooter() {
    return SizedBox.shrink();
  }
}
