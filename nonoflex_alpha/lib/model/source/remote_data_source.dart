import 'dart:convert' as convert;
import 'dart:convert';
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
  final Configs _config;

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
      {required TokenType requestType, String? loginCode, String? refreshToken}) async {
    /// Post - api/v1/auth/token
    const path = '/api/$version/auth/token';

    Map<String, String> getBody() {
      if (loginCode == null && refreshToken == null) throw ('invalidRequest');

      Map<String, String> body = {};
      body.addAll({
        'grant_type':
            requestType == TokenType.authorization ? 'authorization_code' : 'refresh_token'
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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
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
      if (sortType != null) params.addAll({'column': sortType.name}); // 고민
      if (orderType != null) params.addAll({'order': orderType});
      if (size != null) params.addAll({'size': size.toString()});
      if (page != null) params.addAll({'page': page.toString()});
      if (onlyFocusedItem != null) params.addAll({'onlyFocusedItem': onlyFocusedItem.toString()});
      if (onlyTitle != null) params.addAll({'content': onlyTitle.toString()});

      return params;
    }

    try {
      var response = await client.get(
        requestUrl(path, params: getParams()),
        headers: header,
      );
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return NoticeList.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
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
        'productCode': product.productCode,
        'name': product.prdName,
        'category': product.category.serverValue,
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
      // if (product.fileUri != null) body['image'] = product.fileUri!;

      return body;
    }

    try {
      var response = await client.post(
        requestUrl(path),
        headers: header,
        body: convert.jsonEncode(getBody()),
      );
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
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
      if (searchValue != null && searchValue != '') params.addAll({'query': searchValue});
      if (sortType != null) params.addAll({'column': sortType.serverValue}); // 고민
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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
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
  Future<List<RecordOfProduct>> getProductRecords({
    required int productId, // 기준 물품서버코드
    int? year, // 검색 연도 - YYYY (default -> 현재 년도)
    int? month, // 검색 월 - 1 ~ 12 (default -> all)
  }) async {
    // Get - api/v1/product/[productId]/record?[query]
    final path = '/api/$version/product/$productId/record';

    Map<String, String> getParams() {
      Map<String, String> params = {};
      params.addAll({'year': '${year ?? DateTime.now().year}'});
      if (month != null && month > 0 && month <= 12) params.addAll({'month': '$month'});

      return params;
    }

    try {
      var response = await client.get(
        requestUrl(path, params: getParams()),
        headers: header,
      );
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        final recordList = data['recordList'];
        return recordList
            .map<RecordOfProduct>(
                (el) => RecordOfProduct.fromJson(el as Map<String, dynamic>, productId))
            .toList();
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
    final path = 'api/$version/product/${product.productId}';

    Map<String, String> getBody() {
      Map<String, String> body = {};
      body.addAll({
        'productCode': product.productCode,
        'name': product.prdName,
        'category': product.category.serverValue,
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
      // if (product.imageData != null) body['image'] = P!;

      return body;
    }

    try {
      var response = await client.put(
        requestUrl(path),
        headers: header,
        body: convert.jsonEncode(getBody()),
      );
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
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
        final body = utf8.decode(response.bodyBytes);
        final data = convert.jsonDecode(body);
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
        'type': company.companyType.serverValue,
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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return Company.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return CompanyList.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return Company.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
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
        'type': company.companyType.serverValue,
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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return Company.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
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
  Future<dynamic> updateCompanyActivation() async {
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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return CompanyList.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
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
        final body = utf8.decode(response.bodyBytes);
        final data = convert.jsonDecode(body);
        if (data['result'] != true) {
          throw (data['message']);
        } else {
          return data['message'];
        }
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
      }
    } catch (e) {
      rethrow;
    }
  }

  ///
  /// region temp document

  // 임시 문서 생성
  Future<dynamic> addTempDocument(Product product) async {}

  // 임시 문서 목록 조회
  // 임시 문서 상세 정보 조회
  // 임시 문서 정보 수정
  // 임시 문서 삭제

  /// endregion
  ///
  /// region document

  /// 문서 생성
  /// 문서 정보를 추가합니다.
  /// 요청 성공시 생성된 문서의 고유 ID를 포함한 정보를 반환받습니다.
  Future<dynamic> addDocument({
    required DateTime date,
    required DocumentType type,
    required int companyId,
    required List<Record> recordList,
  }) async {
    // Post - api/v1/document
    const path = '/api/$version/document';

    Map<String, String> getBody() {
      Map<String, String> body = {};
      body.addAll({
        'date': date.toString(),
        'type': type.serverValue,
        'companyId': companyId.toString(),
      });

      List<Map<String, String>> recordItems = [];
      recordList.forEach((el) {
        final Map<String, String> record = {};
        record.addAll({
          'productId': el.productId.toString(),
          'quantity': el.quantity.toString(),
          'price': el.recordPrice.toString(),
        });

        recordItems.add(record);
      });

      body.addAll({'recordList': recordItems.toString()});

      return body;
    }

    try {
      var response = await client.post(
        requestUrl(path),
        headers: header,
        body: convert.jsonEncode(getBody()),
      );
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return Document.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 문서 목록 조회
  /// 요청 성공시 해당하는 문서의 리스트를 받습니다.
  Future<DocumentList> getDocumentList({
    String? searchValue, // 검색 키워드 (제목 기반)
    DocumentListSortType? sortType, // 정렬 기준 (default ->  date)
    String? orderType, // 정렬 순서 (default -> desc)
    int? size, // 한 요청에서 가져올 데이터 수 (default -> 10)
    int? page, // 페이지 번호
    int? year, // 검색 연도 형식 YYYY (default -> 현재 연도)
    int? month, // 검색 월 1~12 (default ->  all)
  }) async {
    // Get - api/v1/document?[query]
    const path = '/api/$version/document';

    Map<String, String> getParams() {
      Map<String, String> params = {};
      if (searchValue != null && searchValue != '') params.addAll({'query': searchValue});
      if (sortType != null) params.addAll({'column': sortType.toString()}); // 고민
      if (orderType != null) params.addAll({'order': orderType});
      if (size != null) params.addAll({'size': size.toString()});
      if (page != null) params.addAll({'page': page.toString()});
      if (year != null) params.addAll({'year': year.toString()});
      if (month != null) params.addAll({'month': month.toString()});

      return params;
    }

    try {
      var response = await client.get(
        requestUrl(path, params: getParams()),
        headers: header,
      );
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return DocumentList.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 문서 상세 정보 조회
  /// 요청 성공시 해당하는 문서의 상세정보를 받습니다.
  Future<DocumentDetail> getDocumentDetailInfoByDocumentId(int documentId) async {
    /// Get - api/v1/product/[productId]
    final path = '/api/$version/document/$documentId';

    try {
      var response = await client.get(requestUrl(path), headers: header);
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return DocumentDetail.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 문서 정보 수정
  /// 문서에 해당하는 record의 수정, 유지, 추가, 삭제는 해당 API를 사용합니다.
  /// 해당 API를 사용하기 위해서는 권한... ?
  /// 수정 부분은 이야기가 필요해보임
  Future<dynamic> updateDocument({required DocumentDetail document}) async {
    // Put - api/v1/document/[documentId]
    final path = 'api/$version/document/${document.documentId}';

    Map<String, String> getBody() {
      Map<String, String> body = {};
      body.addAll({
        'date': document.date.toString(),
        'type': document.docType.serverValue,
        'companyName': document.companyName,
      });

      List<Map<String, String>> recordItems = [];
      document.recordList.forEach((el) {
        final Map<String, String> record = {};
        record.addAll({
          'productId': el.productId.toString(),
          'quantity': el.quantity.toString(),
          'price': el.recordPrice.toString(),
        });

        recordItems.add(record);
      });

      body.addAll({'recordList': recordItems.toString()});

      return body;
    }

    try {
      var response = await client.put(
        requestUrl(path),
        headers: header,
        body: convert.jsonEncode(getBody()),
      );
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return DocumentDetail.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 문서 삭제
  /// 문서 정보를 삭제합니다.
  /// 문서에 속하는 record 데이터도 모두 영구삭제됩니다.
  /// 해당 APi를 사용하기 위해서는 MANAGER 이상의 권한이 필요합니다.
  Future<dynamic> deleteDocument(int documentId) async {
    /// Delete - api/v1/document/[documentId]
    final path = '/api/$version/document/$documentId';

    try {
      var response = await client.delete(
        requestUrl(path),
        headers: header,
      );
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final data = convert.jsonDecode(body);
        if (data['result'] != true) {
          throw (data['message']);
        } else {
          return data['message'];
        }
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 엑셀 문서 생성
  /// 연 월 데이터를 기준으로 엑셀 데이터를 생성합니다.
  /// 정상적으로 요청 되었을 경우, 등록 시 사용했던 관리자의 이메일로 생성된 파일이 전송됩니다.
  /// 해당 API를 사용하기 위해서는 MANAGER 이상의 권한이 필요합니다.
  Future<dynamic> makeExcelFile(int year, int month) async {
    /// Get - api/v1/user/{userCode}
    const path = '/api/$version/document/excel';

    Map<String, String> getParams() {
      Map<String, String> params = {
        'year': year.toString(),
        'month': month.toString(),
      };
      return params;
    }

    try {
      var response = await client.get(requestUrl(path, params: getParams()),
          headers: {'Authorization': 'Bearer ${_config.accessToken ?? ''}', 'Content-Type': '*/*'});
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        if (data['result'] == true) {
          return true;
        } else {
          return false;
        }
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
      }
    } catch (e) {
      rethrow;
    }
  }

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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return User.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
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
      Map<String, String> params = {
        'size': '1000',
      };
      if (searchValue != null) params.addAll({'query': searchValue});

      return params;
    }

    try {
      var response = await client.get(
        requestUrl(path, params: getParams()),
        headers: header,
      );
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return UserList.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return User.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
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
        'userType': user.userType.serverValue,
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
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = convert.jsonDecode(body);
        return User.fromJson(data);
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
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
    final path = '/api/$version/user/$userCode';

    try {
      var response = await client.delete(
        requestUrl(path),
        headers: header,
      );
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final data = convert.jsonDecode(body);
        if (data['result'] != true) {
          throw (data['message']);
        } else {
          return data['message'];
        }
      } else {
        /// error
        final body = utf8.decode(response.bodyBytes);
        throw (body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// endregion
}
