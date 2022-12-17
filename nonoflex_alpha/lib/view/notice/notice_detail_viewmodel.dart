import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/repository/notice/notice_repository.dart';


class NoticeDetailViewModel extends BaseController {
  final NoticeRepository _noticeRepository;

  // 공지사항 정보
  final Notice noticeItem;

  NoticeDetailViewModel({
    NoticeRepository? noticeRepository,
    required this.noticeItem,
  }) : _noticeRepository = noticeRepository ?? locator.get<NoticeRepository>() {
    init();
  }

  void init() {
    getNoticeDetailInfo();
  }

  void getNoticeDetailInfo() async {
    try{
      // final notice = await _noticeRepository.getNoticeDetailInfo(noticeId);
      // noticeItem.value = notice;
      // noticeItem.refresh();
    } catch(e){
      logger.e(e.toString());
    }
  }

  void deleteNotice() async {
    // 정말 삭제하시겠습니까?

    try {
      await _noticeRepository.deleteNotice(noticeItem.noticeId);
      Get.back();
    } catch(e) {
      logger.e(e.toString());
    }

  }
}
