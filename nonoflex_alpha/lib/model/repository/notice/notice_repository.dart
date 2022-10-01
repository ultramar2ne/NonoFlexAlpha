import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/repository/notice/abs_notice_repository.dart';

class NoticeMockRepository extends NoticeRepository {
  @override
  Future<void> addNotice({required String title, required String contents, bool? isFocused}) {
    // TODO: implement addNotice
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNotice(int noticeId) {
    // TODO: implement deleteNotice
    throw UnimplementedError();
  }

  @override
  Future<Notice> getNoticeDetailInfo(int noticeId) {
    // TODO: implement getNoticeDetailInfo
    throw UnimplementedError();
  }

  @override
  Future<NoticeList> getNoticeList({String? searchValue, NoticeListSortType? sortType, String? orderType, int? size, int? page, bool? onlyFocusedItem, bool? onlyTitle}) {
    // TODO: implement getNoticeList
    throw UnimplementedError();
  }

  @override
  Future<void> updateNoticeInfo(Notice notice) {
    // TODO: implement updateNoticeInfo
    throw UnimplementedError();
  }
}