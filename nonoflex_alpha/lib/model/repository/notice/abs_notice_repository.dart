import 'package:nonoflex_alpha/model/data/notice.dart';

enum NoticeListSortType {
  id,
  title,
  // content
  createdAt,
  updatedAt,
}

abstract class NoticeRepository {
  // 공지사항 추가
  Future<void> addNotice({required String title, required String contents, bool? isFocused});

  // 공지사항 목록 조회
  Future<NoticeList> getNoticeList({
    String? searchValue,
    NoticeListSortType? sortType,
    String? orderType,
    int? size,
    int? page,
    bool? onlyFocusedItem,
    bool? onlyTitle,
  });

  // 공지사항 상세 조회
  Future<Notice> getNoticeDetailInfo(int noticeId);

  // 공지사항 수정
  Future<void> updateNoticeInfo(Notice notice);

  // 공지사항 삭제
  Future<void> deleteNotice(int noticeId);
}
