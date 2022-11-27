import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/repository/notice/notice_repository.dart';


class NoticeDetailViewModel extends BaseController {
  NoticeRepository _noticeRepository;

  // final noticeId = Get.arguments['noticeId'];

  Rx<Notice?> notice = (null as Notice?).obs;

  NoticeDetailViewModel({NoticeRepository? noticeRepository})
      : _noticeRepository = noticeRepository ?? locator.get<NoticeRepository>() {
    init();
  }

  void init() async {
    final notice222 = await _noticeRepository.getNoticeDetailInfo(70);
    notice.value = notice222;
  }
}
