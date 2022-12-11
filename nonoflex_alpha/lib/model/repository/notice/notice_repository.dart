import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/source/remote_data_source.dart';

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

class NoticeRepositoryImpl extends NoticeRepository {
  final RemoteDataSource _remoteDataSource;

  NoticeRepositoryImpl({RemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? locator.get<RemoteDataSource>();

  @override
  Future<void> addNotice({required String title, required String contents, bool? isFocused}) async {
    await _remoteDataSource.addNotice(title: title, contents: contents, isFocused: isFocused);
  }

  @override
  Future<void> deleteNotice(int noticeId) {
    // TODO: implement deleteNotice
    throw UnimplementedError();
  }

  @override
  Future<Notice> getNoticeDetailInfo(int noticeId) async {
    return await _remoteDataSource.getNoticeDetailInfo(noticeId: noticeId);
  }

  @override
  Future<NoticeList> getNoticeList(
      {String? searchValue,
      NoticeListSortType? sortType,
      String? orderType,
      int? size,
      int? page,
      bool? onlyFocusedItem,
      bool? onlyTitle}) async {
    return await _remoteDataSource.getNoticeList(
      searchValue: searchValue,
      sortType: sortType,
      orderType: orderType,
      size: size,
      page: page,
      onlyFocusedItem: onlyFocusedItem,
      onlyTitle: onlyTitle,
    );
  }

  @override
  Future<void> updateNoticeInfo(Notice notice) {
    // TODO: implement updateNoticeInfo
    throw UnimplementedError();
  }
}
