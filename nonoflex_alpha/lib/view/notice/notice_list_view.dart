import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/view/notice/notice_list_viewmodel.dart';

import 'package:intl/intl.dart';

import '../../cmm/base.dart';

class NoticeListView extends BaseFormatView {
  NoticeListViewModel viewModel = NoticeListViewModel();

  @override
  Widget build(BuildContext context) {
    // Get.put()을 사용하여 클래스를 인스턴스화하여 모든 child 에서 사용 가능 ...?

    return Obx(() => Scaffold(
      // count가 변경될 때 마다 Obx(()=> 를 사용하여 Text()에 없데이트함
      appBar: AppBar(
        title: Center(child: Text(viewModel.title)),
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
    final items = viewModel.noticeList;

    // Obx(() => Text("Clicks: ${c.count}"))
    final length = items.length;

    if (items.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      itemCount: length,
      itemBuilder: (BuildContext context, int index) {
        return _drawListItem(items[index]);
      },
    );
  }

  Widget _drawFooter() {
    return SizedBox.shrink();
  }

  Widget _drawListItem(Notice item) {
    final title = item.title;
    final timeInfo = item.createdAt != item.updatedAt
        ? DateFormat('yyyy-MM-dd').format(item.createdAt).toString()
        : '(수정됨)' + DateFormat('yyyy-MM-dd').format(item.updatedAt).toString();

    return ListTile(
      title: Text(title),
      trailing: Text(timeInfo),
      onTap: () => viewModel.goNoticeDetail(item.noticeId),
    );
  }

  @override
  AppBar defaultAppBar() {
    // TODO: implement defaultAppBar
    throw UnimplementedError();
  }

  @override
  Widget drawBody() {
    // TODO: implement drawBody
    throw UnimplementedError();
  }

  @override
  Widget drawFooter() {
    // TODO: implement drawFooter
    throw UnimplementedError();
  }
}
