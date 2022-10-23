import 'package:flutter_test/flutter_test.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/data/server.dart';
import 'package:nonoflex_alpha/model/repository/notice/abs_notice_repository.dart';
import 'package:nonoflex_alpha/model/source/remote_data_source.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';

void main() {
  final logger = Logger();

  // const serverAddr = '';
  // const portNum = '';
  //
  // String authToken;
  // String refreshToken;
  //
  // String userId;
  // String userPw;

  RemoteDataSource remoteDataSource = RemoteDataSource();

  // setUp(
  //
  // );

  group('auth - success', () {
    // 로그인 코드 요청
    test('로그인 코드 요청 - getLoginCode', () async {
      /// id / pw 로 로그인 요청
      /// id는 이메일 형식이어야 한다.
      /// 로그인 성공 시 토큰 발급을 위한 로그인 코드를 반환받는다.

      /// 준비
      const id = 'jinsrobot@naver.com';
      const pw = '1111';

      /// 실행
      final result = await remoteDataSource.getLoginCode(id: id, pw: pw);

      /// 검증
      /// result에 6자리 숫자 값이 반환된다.
      expect(result.length, 6);
      expect(int.tryParse(result) != null, true);
    });

    // userCode로 로그인 코드 요청
    test('userCode로 로그인 코드 요청 - getLoginCodeByUserCode', () async {
      /// 참여자 userCode로 로그인 요청
      /// 관리자와 동일하게 로그인 코드를 발급받는다.

      /// 준비
      const userCode = 3; // 하마탈을쓴하마

      /// 실행
      final result = await remoteDataSource.getLoginCodeByUserCode(userCode: userCode);

      /// 검증
      /// result에 6자리 숫자 값이 반환된다.
      expect(result.length, 6);
      expect(int.tryParse(result) != null, true);
    });

    // 토큰 발급 및 갱신
    test('토큰 발급 및 갱신 - getAuthToken', () async {
      /// 인증 토큰을 발급한다.
      /// 로그인 코드로 토큰 발급
      /// 로그인 코드는 1회 발급되면 다시 사용할 수 없도 재발급 받아야한다.
      /// 준비
      var requestType = TokenRequestType.authorization;
      // const loginCode = '732387';
      final loginCode = await remoteDataSource.getLoginCode(
        id: 'jinsrobot@naver.com',
        pw: '1111',
      );

      /// 실행
      var resultWithLoginCode =
          await remoteDataSource.getAuthToken(requestType: requestType, loginCode: loginCode);

      /// 검증
      /// 인증 토큰 값이 반환되어 AuthToken으로 parsing되어 반환된다.
      expect(resultWithLoginCode.runtimeType == AuthToken, true);
      logger.i(resultWithLoginCode.toString());

      /// refresh_token으로 토큰 발급
      /// 최초 로그인 이후에는 발급받은 refresh_token을 활용해 auth_token을 갱신한다
      /// 준비
      requestType = TokenRequestType.refresh;
      final refreshToken = resultWithLoginCode.refreshToken;

      /// 실행
      final resultWithRefreshToken = await remoteDataSource.getAuthToken(
        requestType: requestType,
        refreshToken: refreshToken,
      );

      /// 검증
      /// 인증 토큰 값이 반환되어 AuthToken으로 parsing되어 반환된다.
      expect(resultWithRefreshToken.runtimeType == AuthToken, true);
      logger.i('access token : ${resultWithRefreshToken.accessToken}');
    });
  });

  group('notice - success', () {
    // 공지사항 생성
    test('공지사항 생성 - addNotice', () async {
      /// 새로운 공지사항을 생성한다.

      /// 준비
      const title = 'test title';
      const contents = 'test contents';
      const isFocused = true;

      /// 실행
      final result = await remoteDataSource.addNotice(
        title: title,
        contents: contents,
        isFocused: isFocused,
      );

      /// 검증
      /// 성공할 경우 추가된 Notice를 반환한다.
      expect(result.runtimeType == Notice, true);
    });

    // 공지사항 목록 조회
    test('공지사항 목록 조회 - getNoticeList', () async {
      /// 공지사항 목록을 조회한다.
      /// 공지사항 목록의 조회 옵션은 다음과 같다.
      /// - 검색
      /// - NoticeListSortType (id / title / content..? / createdAt / updatedAt)
      /// - 정렬 순서 (asc / desc default = desc)
      /// - 목록 요청 갯수
      /// - 요청 페이지
      /// - 주요 공지사항만 보기
      /// - contents 포함하지 않기

      /// 테스트의 공통 기준
      /// sortType / page 는 default 사용
      const size = 5;
      const onlyTitle = false;

      /// 공지사항 목록을 조회한다.
      /// 실행
      final noticeList = await remoteDataSource.getNoticeList(
        size: size,
        onlyTitle: false,
      );

      // 검증
      expect(
          (noticeList.isLastPage == false && noticeList.items.length == size) ||
              (noticeList.isLastPage == true),
          true);

      /// 공지사항을 검색한다.
      /// 공지사항 목록이 마지막 페이지가 아닐 경우만 테스트한다.
      if (!noticeList.isLastPage) {
        // 준비
        // 목록 중 두번째 요소를 검색하여 첫번째로 나타나는지 확인한다.
        final targetNotice = noticeList.items[1];

        // 실행
        final searchedNoticeList = await remoteDataSource.getNoticeList(
          searchValue: targetNotice.title,
          size: size,
          onlyTitle: false,
        );

        // 검증
        expect(
            searchedNoticeList.items.where((el) => el.noticeId == targetNotice.noticeId).isNotEmpty,
            true);
      }
    });

    // 공지사항 상세 조회
    test('공지사항 상세 조회 - getNoticeDetailInfo', () async {
      // 공지사항의 상세 정보를 조회한다.
      // 준비
      final noticeList = await remoteDataSource.getNoticeList();
      final notice = noticeList.items.first;

      // 실행
      final noticeDetailInfo =
          await remoteDataSource.getNoticeDetailInfo(noticeId: notice.noticeId);

      // 검증
      expect(noticeDetailInfo.noticeId == notice.noticeId, true);
    });

    // 공지사항 수정
    test('공지사항 수정 - updateNotice', () async {
      // 공지사항 내용을 수정한다.
      // 준비
      final Notice noticeForTest =
          await remoteDataSource.addNotice(title: 'title', contents: 'contents');
      const changeValue = 'helloWorld';

      // 실행
      final updatedItem = await remoteDataSource.updateNotice(
          notice: noticeForTest.copyWith(title: changeValue, content: changeValue));

      // 검증
      expect(updatedItem.runtimeType == Notice, true);
      final item = updatedItem as Notice;
      expect(item.title, changeValue);
      expect(item.content, changeValue);
    });

    // 공지사항 삭제
    test('공지사항 삭제 - deleteNotice', () async {
      // 공지사항을 삭제한다.
      // 준비
      final Notice noticeForTest =
          await remoteDataSource.addNotice(title: 'title', contents: 'contents');

      // 실행
      final result = await remoteDataSource.deleteNotice(noticeId: noticeForTest.noticeId);

      // 검증
      expect(result.runtimeType == String, true);
      logger.i('공지사항 삭제 결과 : $result');
    });
  });

  group('product - success', () {});

  group('company - success', () {});

  group('temp document - success', () {});

  group('document - success', () {});

  group('admin - success', () {});
}
