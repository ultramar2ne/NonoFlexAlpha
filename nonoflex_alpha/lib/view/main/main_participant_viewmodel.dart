import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/conf/manager/auth_manager.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/model/repository/notice/notice_repository.dart';

class MainForParticViewModel extends BaseController {
  final NoticeRepository _noticeRepository;
  final AuthManager _authManager;

  // 공지사항 정보
  Notice? noticeItem;

  MainForParticViewModel({
    NoticeRepository? noticeRepository,
    AuthManager? authManager,
  })  : _noticeRepository = noticeRepository ?? locator.get<NoticeRepository>(),
        _authManager = authManager ?? locator.get<AuthManager>() {
    init();
  }

  void init() {
    getNoticeDetailInfo();
  }

  void getNoticeDetailInfo() async {
    try {
      final noticeList = await _noticeRepository.getNoticeList(
          size: 1, onlyTitle: true, sortType: NoticeListSortType.createdAt);
      noticeItem = noticeList.items.first;
      update();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  User? getUserInfo() {
    return _authManager.currentUser;
  }

  void onClickedLogoutButton() async {
    if (!await Get.confirmDialog('정말 로그아웃 하시겠습니까?')) return;
    await _authManager.clearAuthInfo();
    baseNavigator.goLoginPage();
  }

  void openNoticeDetail() async {
    if (noticeItem == null) return;
    await baseNavigator.goNoticeDetailPage(noticeItem!);
    init();
  }

  void goNoticeListPage() async {
    await baseNavigator.goNoticeListPage();
    init();
  }

  void goProductListPage() {
    baseNavigator.goProductListPage(isNested: false);
  }

  void goDocumentListPage() {
    baseNavigator.goDocumentListPage(isNested: false);
  }

  void goAddDocumentPage(DocumentType documentType) {
    switch (documentType) {
      case DocumentType.input:
      case DocumentType.output:
        baseNavigator.goAddDocumentPage(documentType);
        break;
      case DocumentType.tempInput:
      case DocumentType.tempOutput:
        return;
    }
  }
}
