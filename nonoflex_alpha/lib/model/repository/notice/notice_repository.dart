import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/repository/notice/abs_notice_repository.dart';
import 'package:nonoflex_alpha/model/source/remote_data_source.dart';

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
    return await _remoteDataSource.getNoticeList();
  }

  @override
  Future<void> updateNoticeInfo(Notice notice) {
    // TODO: implement updateNoticeInfo
    throw UnimplementedError();
  }
}
