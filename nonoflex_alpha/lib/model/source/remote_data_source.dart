import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:nonoflex_alpha/conf/config.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/conf/manager/auth_manager.dart';
import 'package:nonoflex_alpha/model/data/company.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/data/record.dart';
import 'package:nonoflex_alpha/model/data/server.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/model/repository/notice/notice_repository.dart';

class RemoteDataSource {
  Configs _config;

  static const String serverAddr = Configs.serverAddress;
  static const String portNum = Configs.portNum;
  static const String version = Configs.version;

  Map<String, String> get header =>
      {'Authorization': 'Bearer ${_config.accessToken ?? ''}', 'Content-Type': 'application/json'};

  Uri requestUrl(String path, {Map<String, String>? params}) =>
      Uri.http('$serverAddr:$portNum', path, params);

  final client = http.Client();

  RemoteDataSource({Configs? config}) : _config = config ?? locator.get<Configs>();

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
      rethrow;
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
  Future<dynamic> addNotice(
      {required String title, required String contents, bool? isFocused}) async {
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
        if (data['result'] != true) {
          throw (data['message']);
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

  /// 물품 생성
  /// TODO: Test
  /// 물품 정보를 추가합니다.
  /// MANAGER 이상의 권한이 필요합니다.
  Future<dynamic> addProduct(Product product) async {
    // Post - api/v1/product
    const path = '/api/$version/product';

    Map<String, String> getBody() {
      Map<String, String> body = {};
      body.addAll({
        'productCode': product.prdCode,
        'name': product.prdName,
        'category': product.category,
        'maker': product.maker,
        'unit': product.unit,
        'stock': '${product.stock}',
        'storageType': product.storageType.name,
      });

      // additional value
      if (product.description != null) body['description'] = product.description!;
      if (product.barcode != null) body['barcode'] = product.barcode!;
      if (product.price != null) body['price'] = '${product.price!}';
      if (product.marginPrice != null) body['margin'] = '${product.marginPrice!}';
      if (product.fileUri != null) body['image'] = product.fileUri!;

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
        return Product.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 물품 목록 조회
  /// TODO: Test
  /// 물품 목록을 조회합니다.
  /// API 를 요청하는 대상의 권한이 PARTIC일 경우 활성화 상태의 물품만 조회됩니다.
  Future<ProductList> getProductList({
    String? searchValue, // 검색 키워드 (제목 기반)
    ProductListSortType? sortType, // 정렬 기준 (default ->  createdAt)
    String? orderType, // 정렬 순서 (default -> desc)
    int? size, // 한 요청에서 가져올 데이터 수 (default -> 10)
    int? page, // 페이지 번호
    bool? onlyActiveItem, // 활성 물품만 보기
  }) async {
    // Get - api/v1/product?[query]
    const path = '/api/$version/product';

    Map<String, String> getParams() {
      Map<String, String> params = {};
      if (searchValue != null) params.addAll({'query': searchValue});
      if (sortType != null) params.addAll({'column': sortType.toString()}); // 고민
      if (orderType != null) params.addAll({'order': orderType});
      if (size != null) params.addAll({'size': size.toString()});
      if (page != null) params.addAll({'page': page.toString()});
      if (onlyActiveItem != null) params.addAll({'onlyFocusedItem': onlyActiveItem.toString()});

      return params;
    }

    try {
      var response = await client.get(
        requestUrl(path, params: getParams()),
        headers: header,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return ProductList.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 물품 상세 정보 조회 - 물품서버코드
  /// TODO: Test
  /// 물품 정보를 조회합니다.
  /// 요청 성공 시 해당하는 물품의 정보를 받습니다.
  Future<Product> getProductDetailInfoByProductId(int productId) async {
    /// Get - api/v1/product/[productId]
    final path = '/api/$version/product/$productId';

    try {
      var response = await client.get(requestUrl(path), headers: header);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return Product.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 물품 상세 정보 조회 - 바코드
  /// TODO: Test
  /// 물품 정보를 조회합니다.
  /// 요청 성공 시 해당하는 물품의 정보를 받습니다.
  Future<Product> getProductDetailInfoByBarcode(String barcode) async {
    /// Get - api/v1/product/[productId]
    final path = '/api/$version/product/barcode/$barcode';

    try {
      var response = await client.get(requestUrl(path), headers: header);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return Product.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 물품 레코드 조회
  /// TODO: Test
  /// 요청한 해당 년, 월 물품의 레코드를 조회합니다.
  /// 요청 성공 시 해당하는 물품의 정보와 레코드를 받습니다.
  Future<RecordList> getProductRecords({
    required int productId, // 기준 물품서버코드
    int? year, // 검색 연도 - YYYY (default -> 현재 년도)
    int? month, // 검색 월 - 1 ~ 12 (default -> all)
  }) async {
    // Get - api/v1/product/[productId]/record?[query]
    final path = '/api/$version/product/$productId/record';

    Map<String, String> getParams() {
      Map<String, String> params = {};
      if (year != null && year > 2020 && year <= 2050) params.addAll({'year': '$year'});
      if (month != null && month > 0 && month <= 12) params.addAll({'month': '$month'});

      return params;
    }

    try {
      var response = await client.get(
        requestUrl(path, params: getParams()),
        headers: header,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        // return NoticeList.fromJson(data);
        throw ('이거 추가해라 인간');
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 물품 정보 수정
  /// TODO: Test
  /// 물품 정보를 수정합니다.
  /// MANAGER 이상의 권한이 필요합니다.
  Future<dynamic> updateProduct({required Product product}) async {
    // Put - api/v1/product/[productId]
    final path = 'api/$version/product/${product.prdId}';

    Map<String, String> getBody() {
      Map<String, String> body = {};
      body.addAll({
        'productCode': product.prdCode,
        'name': product.prdName,
        'category': product.category,
        'maker': product.maker,
        'unit': product.unit,
        'stock': '${product.stock}',
        'storageType': product.storageType.name,
        'active': product.isActive.toString(),
      });

      // additional value
      if (product.description != null) body['description'] = product.description!;
      if (product.barcode != null) body['barcode'] = product.barcode!;
      if (product.price != null) body['price'] = '${product.price!}';
      if (product.marginPrice != null) body['margin'] = '${product.marginPrice!}';
      if (product.fileUri != null) body['image'] = product.fileUri!;

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
        return Product.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 물품 삭제
  /// TODO : Test
  /// 물품 정보를 삭제합니다.
  /// MANAGER 이상의 권한이 필요합니다.
  /// 물품 삭제 시 참조되고 있는 데이터가 모두 손쇨될 수 있습니다.
  /// 이력을 보관하고 싶을 경우 activate 속성을 false로 수정하여 비활성화 하는 것을 권장합니다.
  Future<dynamic> deleteProduct(int productId) async {
    /// Delete - api/v1/product/[productId]
    final path = '/api/$version/product/$productId';

    try {
      var response = await client.delete(
        requestUrl(path),
        headers: header,
      );
      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        if (data['result'] != true) {
          throw (data['message']);
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
  /// region company

  /// 거래처 생성
  /// TODO : Test
  /// 거래처 정보를 추가합니다.
  /// MANAGER 이상의 권한이 필요합니다.
  Future<dynamic> addCompany(Company company) async {
    // Post - api/v1/company
    const path = '/api/$version/company';

    Map<String, String> getBody() {
      Map<String, String> body = {};
      body.addAll({
        'name': company.name,
        'type': company.companyType.toString(),
      });

      // additional value
      if (company.description != null) body['category'] = company.description!;

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
        return Company.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 거래처 목록 조회
  /// TODO : Test
  /// 거래처 목록을 조회합니다.
  Future<CompanyList> getCompanyList({
    String? searchValue, // 검색 키워드 (제목 기반)
    CompanyListSortType? sortType, // 정렬 기준 (default ->  name)
    String? orderType, // 정렬 순서 (default -> asc)
    int? size, // 한 요청에서 가져올 데이터 수 (default -> 10)
    int? page, // 페이지 번호
    bool? onlyActiveItem, // 활성 거래처만 보기
  }) async {
    // Get - api/v1/company?[query]
    const path = '/api/$version/company';

    Map<String, String> getParams() {
      Map<String, String> params = {};
      if (searchValue != null) params.addAll({'query': searchValue});
      if (sortType != null) params.addAll({'column': sortType.toString()}); // 고민
      if (orderType != null) params.addAll({'order': orderType});
      if (size != null) params.addAll({'size': size.toString()});
      if (page != null) params.addAll({'page': page.toString()});
      if (onlyActiveItem != null) params.addAll({'onlyFocusedItem': onlyActiveItem.toString()});

      return params;
    }

    try {
      var response = await client.get(
        requestUrl(path, params: getParams()),
        headers: header,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return CompanyList.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 거래처 상세 정보 조회
  /// TODO : Test
  /// 거래처 정보를 조회합니다.
  /// 요청 성공 시 해당하는 거래처의 정보를 받습니다.
  Future<Company> getCompanyDetailInfoByCompanyId(int companyId) async {
    /// Get - api/v1/company/[companyId]
    final path = '/api/$version/company/$companyId';

    try {
      var response = await client.get(requestUrl(path), headers: header);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return Company.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 거래처 문서 조회
  /// TODO : Test
  /// 해당 거래처와 관련된 문서를 조회합니다.
  Future<DocumentList> getDocumentListByCompanyId() async {
    throw ('');
  }

  /// 거래처 정보 수정
  /// TODO : Test
  /// 거래처 정보를 수정합니다.
  /// MANAGER 이상의 권한이 필요합니다.
  Future<dynamic> updateCompany({required Company company}) async {
    // Put - api/v1/company/[companyId]
    final path = 'api/$version/company/${company.companyId}';

    Map<String, String> getBody() {
      Map<String, String> body = {};
      body.addAll({
        'name': company.name,
        'type': company.companyType.toString(),
        'category': company.description ?? '',
        'active': company.isActive.toString(),
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
        return Company.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 거래처 활성 상태 수정
  /// TODO : Test
  /// 거래처의 활성 상태 정보를 일괄적으로 수정합니다.
  /// 전달되지 않은 거래처에 대해서는 데이터가 변경되지 않습니다.
  /// ADMIN 이상의 권한이 필요합니다.
  Future<dynamic> updateComapnyActivation() async {
    // Put - api/v1/company/active
    const path = 'api/$version/company/active';

    Map<String, String> getBody() {
      Map<String, String> body = {};
      // TODO : 추가되어야함
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
        return CompanyList.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 거래처 삭제
  /// TODO : Test
  /// 거래처 정보를 삭제합니다.
  /// MANAGER 이상의 권한이 필요합니다.
  /// 거래처 삭제 시 참조되고 있는 데이터가 모두 손쇨될 수 있습니다.
  /// 이력을 보관하고 싶을 경우 activate 속성을 false로 수정하여 비활성화 하는 것을 권장합니다.
  Future<dynamic> deleteCompany(int companyId) async {
    /// Delete - api/v1/company/[companyId]
    final path = '/api/$version/company/$companyId';

    try {
      var response = await client.delete(
        requestUrl(path),
        headers: header,
      );
      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        if (data['result'] != true) {
          throw (data['message']);
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

  /// 참여자 등록
  /// TODO : Test
  /// 해당 시스템을 사용할 수 있는 사용자를 추가합니다.
  /// MANAGER 권한 이상의 사용자는 회원가입을 통해 추가할 수 있습니다.
  Future<dynamic> addParticipant(String userName) async {
    // Post - /api/version/user
    const path = '/api/$version/user';

    Map<String, String> getBody() {
      Map<String, String> body = {};
      body.addAll({'userName': userName});

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
        return User.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 목록 조회
  /// TODO : Test
  /// 해당 시스템을 사용할 수 있는 사용자 목록을 조회합니다.
  /// 요청 성공 시 전체 사용자의 정보를 받습니다.
  Future<UserList> getUserList({String? searchValue}) async {
    // Get - api/v1/user?[query]
    const path = '/api/$version/user';

    Map<String, String> getParams() {
      Map<String, String> params = {};
      if (searchValue != null) params.addAll({'query': searchValue});

      return params;
    }

    try {
      var response = await client.get(
        requestUrl(path, params: getParams()),
        headers: header,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return UserList.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 상세 정보 조회
  Future<User> getUserDetailInfo(int userCode) async {
    /// Get - api/v1/user/{userCode}
    final path = '/api/$version/user/$userCode';

    try {
      var response = await client.get(requestUrl(path), headers: header);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = convert.jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 정보 수정
  /// TODO : Test
  /// 해당 시스템의 사용자 정보를 업데이트 합니다.
  Future<dynamic> updateUser({required User user}) async {
    /// put - api/v1/user/[userCode]
    final path = '/api/$version/user/${user.userCode}';

    Map<String, String> getBody() {
      Map<String, String> body = {};
      body.addAll({
        'email': user.id,
        'userName': user.userName,
        'active': user.isActive.toString(),
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
        return User.fromJson(data);
      } else {
        /// error
        throw (response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 정보 삭제
  /// TODO : Test
  /// 특정 사용자의 정보를 삭제합니다.
  /// MANAGER 이상의 권한이 필요합니다.
  Future<dynamic> deleteUser({required int userCode}) async {
    /// delete - api/v1/user/[userCode]
    final path = '/api/$version/user/[/$userCode';

    try {
      var response = await client.delete(
        requestUrl(path),
        headers: header,
      );
      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        if (data['result'] != true) {
          throw (data['message']);
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
}
