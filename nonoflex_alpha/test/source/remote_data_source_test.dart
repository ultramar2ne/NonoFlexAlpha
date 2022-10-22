import 'package:flutter_test/flutter_test.dart';
import 'package:nonoflex_alpha/model/data/server.dart';
import 'package:nonoflex_alpha/model/source/remote_data_source.dart';
import 'package:logger/logger.dart';

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
    test('공지사항 생성 - addNotice',() async {

    });

    // 공지사항 목록 조회
    test('공지사항 목록 조회 - getNoticeList',() async {});

    // 공지사항 상세 조회
    test('공지사항 상세 조회 - getNoticeDetailInfo',() async {});

    // 공지사항 수정
    test('공지사항 수정 - updateNotice',() async {});

    // 공지사항 삭제
    test('공지사항 삭제 - deleteNotice',() async {});
  });

  group('product - success', () {

  });

  group('company - success', () {

  });

  group('temp document - success', () {

  });

  group('document - success', () {

  });

  group('admin - success', () {

  });


}
