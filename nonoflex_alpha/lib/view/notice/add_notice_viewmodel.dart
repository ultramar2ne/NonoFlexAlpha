import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/repository/notice/notice_repository.dart';

enum ViewMode {
  add,
  edit,
}

// 공지사항 추가화면
class AddNoticeViewModel extends BaseController {
  NoticeRepository _noticeRepository;

  // 공지사항 추가 모드
  late ViewMode viewMode;

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

  // 공지사항 ID
  final int? noticeId;

  // 공지사항 정보
  Notice? noticeItem;

  AddNoticeViewModel({NoticeRepository? noticeRepository, this.noticeId})
      : _noticeRepository =
            noticeRepository ?? noticeRepository ?? locator.get<NoticeRepository>() {
    viewMode = noticeId == null ? ViewMode.add : ViewMode.edit;
    init();
  }

  void init() {
    if (noticeId != null) {
      getNoticeDetailInfo(noticeId!);
    }
  }

  Future<void> submit() async {
    if (_titleEditingController.text.replaceAll(' ', '').isEmpty) {
      Get.toast('제목을 입력해 주세요.');
      return;
    }
    if (_contentsEditingController.text.replaceAll(' ', '').isEmpty) {
      Get.toast('내용을 입력해 주세요.');
      return;
    }

    try {
      switch (viewMode) {
        case ViewMode.add:
          await _noticeRepository.addNotice(
              title: _titleEditingController.text,
              contents: _contentsEditingController.text,
              isFocused: isImportantNotice.value);
          Get.toast('공지사항이 추가되었습니다.');
          break;
        case ViewMode.edit:
          if (noticeItem == null) return;
          final notice = noticeItem!.copyWith(
            title: _titleEditingController.text,
            content: _contentsEditingController.text,
            isFocused: isImportantNotice.value,
          );
          await _noticeRepository.updateNoticeInfo(notice);
          Get.toast('공지사항이 수정되었습니다.');
          break;
      }
      Get.back();
    } catch (e) {
      logger.e(e.toString());
      Get.toast('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }
  }

  void getNoticeDetailInfo(int noticeId) async {
    try {
      final notice = await _noticeRepository.getNoticeDetailInfo(noticeId);
      noticeItem = notice;

      if (noticeItem == null) return;
      _titleEditingController.text = noticeItem!.title;
      _contentsEditingController.text = noticeItem!.content ?? '';
      update();
    } catch (e) {
      logger.e(e.toString());
      Get.toast('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      Get.back();
    }
  }
}
