import 'package:get/get.dart';

class Resource extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ko_KR': {
          // System
          'appName': '노노유통',
          'teamName': 'Cornflo3er',

          // Common
          'commonEmptyView': '알 수 없는 화면이네요.. 더 분발할게요!',
          'commonErrorView': '무언가 잘못되었습니다.. 더 분발할게요!',
          'commonEmptyListView' : '항목이 존재하지 않습니다.',
          'commonSortOption' : '정렬 기준',
          'commonSortType' : '정렬 방향',

          // API Exception

          // ViewController Exception

          // Dialog
          'commonDialogTitle': '',
          'commonDialogButtonOk': '확인',
          'commonDialogButtonCancel': '취소',

          // Splash

          // Login
          'LoginViewTitle': '로그인',
          'LoginViewLabelParticMode': '참여자',
          'LoginViewLabelAdminMode': '관리자',
          'LoginViewLabelEmailField': '아이디',
          'LoginViewLabelPasswordField': '비밀번호',
          'LoginViewHintEmailField': 'e-mail을 입력해주세요.',
          'LoginViewHintPasswordField': '비밀번호를 입력해주세요.',
          'LoginViewButtonLogin': '로그인',
          'LoginViewLabelAuthCodeField': '인증 코드',
          'LoginViewButtonLoginUseBarcode': '바코드로 인증하기',

          // Main - admin
          'MainForAdminViewBottomNavHome': '홈',
          'MainForAdminViewBottomNavProducts': '물품 관리',
          'MainForAdminViewBottomNavDocuments': '문서 관리',
          'MainForAdminViewBottomNavSetting': '설정',

          // Main - admin - Home
          'AdminHomeViewTitle': '노노유통',
          'AdminHomeViewLabelNoticeArea': '공지사항',
          'AdminHomeViewMessageAddNotice' : '새로운 공지사항을 입력해보세요!',
          'AdminHomeViewLabelTempDocumentArea': '입/출고 예정서 현황',

          // Main - product list
          'ProductListViewTitle': '물품 관리',
          'ProductListViewLabelProductList' : '물품 목록',

          // Main - document list
          'DocumentListViewTitle': '문서 관리',

          // Main - setting
          'SettingViewTitle': '설정',
          'SettingViewButtonLogout' : '로그아웃',
          'SettingViewLabelUserSetting' : '사용자 관리',
          'SettingViewButtonManagePartic' : '참여자 정보 관리',
          'SettingViewButtonManageAdmin' : '관리자 정보 관리',
          'SettingViewLabelProductSetting' : '물품 관련 추가 기능',
          'SettingViewLabelProductSetting' : '새 물품 추가',
          'SettingViewButtonManageBarcode' : '바코드 설정',
          'SettingViewLabelDocumentSetting' : '문서 관련 추가 기능',
          'SettingViewButtonPrintDocument' : '문서 출력',
          'SettingViewButtonManageCompany' : '거래처 관리',
          'SettingViewLabelEtc' : '기타',
          'SettingViewButtonAskToDeveloper' : '개발자에게 문의하기',
          'SettingViewButtonPowerUp' : '힘내라 얍얍',

          // Main - partic

          // NoticeList
          'NoticeListViewTitle' : '공지사항',
          'NoticeListViewLabelNoticeList' : '공지사항 목록',
        },
        // 'en_US': {
        //   'hello': 'Hallo Welt',
        // }
      };
}
