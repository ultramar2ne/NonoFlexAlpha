import 'package:nonoflex_alpha/model/data/notice.dart';

abstract class NoticeRepository {
  // 공지사항 추가
  Future<void> addNotice();

  // 공지사항 목록 조회
  Future<NoticeList> getNoticeList();

  // 공지사항 상세 조회
  Future<Notice> getNoticeDetailInfo();

  // 공지사항 수정
  Future<void> updateNoticeInfo();

  // 공지사항 삭제
  Future<void> deleteNotice();
}
