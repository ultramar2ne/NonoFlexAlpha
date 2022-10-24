import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/repository/notice/abs_notice_repository.dart';

class AddNoticeViewModel extends BaseViewModel {
  NoticeRepository _noticeRepository;

  /// 공지사항 제목 입력
  TextEditingController get titleEditingController => _contentsEditingController;
  final _titleEditingController = TextEditingController();

  /// 공지사항 내용 입력
  TextEditingController get contentsEditingController => _contentsEditingController;
  final _contentsEditingController = TextEditingController();

  /// 주요 공지사항 여부
  bool isImportantNotice = false;

  AddNoticeViewModel({NoticeRepository? noticeRepository})
      : _noticeRepository =
            noticeRepository ?? noticeRepository ?? locator.get<NoticeRepository>() {
    init();
  }

  void init() {}

  Future<void> submit() async {
    if (_titleEditingController.text.isEmpty) {
      // '제목 입력해라 인간.';
    }
    if (_contentsEditingController.text.isEmpty) {
      // '내용 입력해라 인간.';
    }

    try {
      await _noticeRepository.addNotice(
          title: _titleEditingController.text,
          contents: _contentsEditingController.text,
          isFocused: isImportantNotice);

      Fluttertoast.showToast(msg: '성공');
    } catch (e) {}
  }
}
