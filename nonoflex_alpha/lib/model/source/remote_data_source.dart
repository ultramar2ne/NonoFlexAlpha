import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/data/server.dart';
import 'package:nonoflex_alpha/model/repository/notice/notice_repository.dart';

class RemoteDataSource {
  static const String serverAddr = '3.39.53.3';
  static const String portNum = '3000';
  static const String version = 'v1';

  static const String token =
      'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJST0xFIjoiUk9MRV9BRE1JTiIsImlzcyI6ImJ1ZGR5IiwiZXhwIjoxNjY2NTE5NjM0LCJpYXQiOjE2NjY1MTI0MzQsInVzZXJJZCI6MSwidXNlcm5hbWUiOiLstIjsoIjsoJXqt4Dsl7zrkaXsnbTsnqXtg5ztmZgifQ.C7pcMxVGGCwpvOKpWVz6w5e6TeaVQOjiax6sjYH72EQ';

  final Map<String, String> header = {'Authorization': token, 'Content-Type': 'application/json'};

  Uri requestUrl(String path, {Map<String, String>? params}) =>
      Uri.http('$serverAddr:$portNum', path, params);

  final client = http.Client();

  RemoteDataSource();

  /// region Auth
  /// 로그인 코드 요청
  Future<String> getLoginCode({required String id, required String pw}) async {
    /// Post - /api/version/auth/code
    const path = '/api/$version/auth/code';

    Map<String, String> getBody() {
      Map<String, String> body = {};
      body.addAll({'email': id});
      body.addAll({'password': pw});

      return body;
    }

    try {
      final response = await client.post(
        requestUrl(path),
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode(getBody()),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return data['code'];
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      throw(e);
    }
  }

  /// userCode로 로그인 코드 요청
  /// 참여자 로그인 시 사용
  Future<String> getLoginCodeByUserCode({required int userCode}) async {
    /// Post - /api/version/auth/code/[userCode]
    final path = '/api/$version/auth/code/$userCode';

    try {
      final response = await client.post(
        requestUrl(path),
        headers: header,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return data['code'];
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 토큰 발급 및 갱신
  Future<AuthToken> getAuthToken(
      {required TokenRequestType requestType, String? loginCode, String? refreshToken}) async {
    /// Post - api/v1/auth/token
    const path = '/api/$version/auth/token';

    Map<String, String> getBody() {
      if (loginCode == null && refreshToken == null) throw ('invalidRequest');

      Map<String, String> body = {};
      body.addAll({
        'grant_type':
            requestType == TokenRequestType.authorization ? 'authorization_code' : 'refresh_token'
      });
      if (loginCode != null) body.addAll({'code': loginCode});
      if (refreshToken != null) body.addAll({'refresh_token': refreshToken});

      return body;
    }

    try {
      final response = await client.post(
        requestUrl(path),
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode(getBody()),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return AuthToken.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// endregion

  /// region Notice
  /// 공지사항 생성
  Future<dynamic> addNotice({required String title, required String contents, bool? isFocused}) async {
    /// post - api/v1/notice
    const path = '/api/$version/notice';

    Map<String, String> getBody() {
      Map<String, String> body = {};
      body.addAll({
        'title': title,
        'content': contents,
        'focus': isFocused.toString(),
      });

      return body;
    }

    try {
      var response = await client.post(
        requestUrl(path),
        headers: header,
        body: convert.jsonEncode(getBody()),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return Notice.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  // 공지사항 목록 조회
  Future<NoticeList> getNoticeList({
    String? searchValue, // 검색 키워드 (제목 기반)
    NoticeListSortType? sortType, // 정렬 기준 (default ->  createdAt)
    String? orderType, // 정렬 순서 (default -> desc)
    int? size, // 한 요청에서 가져올 데이터 수 (default -> 10)
    int? page, // 페이지 번호
    bool? onlyFocusedItem, // 주요 공지사항만 보기
    bool? onlyTitle, // 공지사항 내용 포함 여부, 선택하지 않을경우 null 반환
  }) async {
    /// get - api/v1/notice?[query]
    const path = '/api/$version/notice';

    Map<String, String> getParams() {
      Map<String, String> params = {};
      if (searchValue != null) params.addAll({'query': searchValue});
      if (sortType != null) params.addAll({'column': sortType.toString()}); // 고민
      if (orderType != null) params.addAll({'order': orderType});
      if (size != null) params.addAll({'size': size.toString()});
      if (page != null) params.addAll({'page': page.toString()});
      if (onlyFocusedItem != null) params.addAll({'onlyFocusedItem': onlyFocusedItem.toString()});
      if (onlyTitle != null) params.addAll({'onlyTitle': onlyTitle.toString()});

      return params;
    }

    final Map<String, String> params = {'order': 'asc'};

    try {
      var response = await client.get(
        requestUrl(path, params: getParams()),
        headers: header,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return NoticeList.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  // 공지사항 상세 조회
  Future<Notice> getNoticeDetailInfo({required int noticeId}) async {
    /// get - api/v1/notice/[noticeId]
    final path = '/api/$version/notice/$noticeId';

    try {
      var response = await client.get(requestUrl(path), headers: header);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return Notice.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  // 공지사항 수정
  Future<dynamic> updateNotice({required Notice notice}) async {
    /// put - api/v1/notice/[noticeId]
    final path = '/api/$version/notice/${notice.noticeId}';

    Map<String, String> getBody() {
      Map<String, String> body = {};
      body.addAll({
        'title': notice.title,
        'content': notice.content ?? '',
        'focus': notice.isFocused.toString(),
      });

      return body;
    }

    try {
      var response = await client.put(
        requestUrl(path),
        headers: header,
        body: convert.jsonEncode(getBody()),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return Notice.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  // 공지사항 삭제
  Future<dynamic> deleteNotice({required int noticeId}) async {
    /// delete - api/v1/notice/[noticeId]
    final path = '/api/$version/notice/$noticeId';

    try {
      var response = await client.delete(
        requestUrl(path),
        headers: header,
      );
      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        if(data['result'] != true){
          throw(data['message']);
        } else {
          return data['message'];
        }
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// endregion
  ///
  /// region product

  // 물품 생성
  // 물품 목록 조회
  // 물품 상세 정보 조회
  // 물품 레코드 조회
  // 물품 정보 수정
  // 물품 삭제

  /// endregion
  ///
  /// region company

  // 거래처 생성
  // 거래처 목록 조회
  // 거래처 상세 정보 조회
  // 거래처 문서 조회
  // 거래처 정보 수정
  // 거래처 활성 상태 수정
  // 거래처 삭제

  /// endregion
  ///
  /// region temp document

  // 임시 문서 생성
  // 임시 문서 목록 조회
  // 임시 문서 상세 정보 조회
  // 임시 문서 정보 수정
  // 임시 문서 삭제

  /// endregion
  ///
  /// region document

  // 문서 생성
  // 문서 목록 조회
  // 문서 상세 정보 조회
  // 문서 정보 수정
  // 문서 삭제

  /// endregion
  ///
  /// region only admin

  // 참여자 등록
  // 사용자 목록 조회
  // 사용자 상세 정보 조회
  // 사용자 정보 수정
  // 사용자 정보 삭제

  /// endregion
}
