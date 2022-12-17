import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/repository/notice/notice_repository.dart';

// 공지사항 추가화면
class AddNoticeViewModel extends BaseController {
  NoticeRepository _noticeRepository;

  /// 공지사항 제목 입력
  TextEditingController get titleEditingController => _titleEditingController;
  final _titleEditingController = TextEditingController();

  /// 공지사항 제목 영역 오류 메시지
  String? titleErrorText;

  /// 공지사항 내용 입력
  TextEditingController get contentsEditingController => _contentsEditingController;
  final _contentsEditingController = TextEditingController();

  /// 공지사항 내용 영역 오류 메시지
  String? contentErrorText;

  /// 주요 공지사항 여부
  var isImportantNotice = false.obs;

  AddNoticeViewModel({NoticeRepository? noticeRepository})
      : _noticeRepository =
            noticeRepository ?? noticeRepository ?? locator.get<NoticeRepository>() {
    init();
  }

  void init() {}

  Future<void> submit() async {
    if (_titleEditingController.text.isEmpty) {
      // '제목 입력해라 인간.';
      return;
    }
    if (_contentsEditingController.text.isEmpty) {
      // '내용 입력해라 인간.';
      return;
    }

    try {
      await _noticeRepository.addNotice(
          title: _titleEditingController.text,
          contents: _contentsEditingController.text,
          isFocused: isImportantNotice.value);

      Fluttertoast.showToast(msg: '성공');
      Get.back();
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
