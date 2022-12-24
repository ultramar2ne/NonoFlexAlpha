import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/data/record.dart';
import 'package:nonoflex_alpha/model/source/remote_data_source.dart';

abstract class DocumentRepository {
  /// temp Doc
  /// 임시 문서 추가
  Future<void> addTempDocument(TempDocument tempDocument);

  /// 임시 문서 목록 조회
  Future<TempDocumentList> getTempDocumentList();

  /// 임시 문서 상세 정보 조회
  Future<TempDocument> getTempDocumentDetailInfo(int tempDocumentId);

  /// 임시 문서 정보 수정
  Future<void> updateTempDocumentInfo(TempDocument tempDocument);

  /// 임시 문서 삭제
  Future<void> deleteTempDocumentData(int tempDocumentId);

  /// Doc
  /// 문서 추가
  Future<void> addDocument({
    required DateTime date,
    required DocumentType type,
    required int companyId,
    required List<Record> recordList,
  });

  /// 문서 목록 조회
  Future<DocumentList> getDocumentList(
      {String? searchValue,
      DocumentListSortType? sortType,
      String? orderType,
      int? size,
      int? page,
      int? year,
      int? month});

  /// 거래처 별 문서 목록 조회
  void getDocumentByComapny();

  /// 문서 상세 정보 조회
  Future<DocumentDetail> getDocumentDetailInfo(int documentId);

  /// 문서 정보 수정
  Future<void> updateDocumentInfo(DocumentDetail document);

  /// 문서 정보 삭제
  Future<void> deleteDcoumentData(int documentId);
}

class DocumentRepositoryImpl extends DocumentRepository {
  RemoteDataSource _remoteDataSource;

  DocumentRepositoryImpl({RemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? locator.get<RemoteDataSource>();

  @override
  Future<void> addTempDocument(TempDocument tempDocument) {
// TODO: implement addTempDocument
    throw UnimplementedError();
  }

  @override
  Future<TempDocumentList> getTempDocumentList() {
// TODO: implement getTempDocumentList
    throw UnimplementedError();
  }

  @override
  Future<TempDocument> getTempDocumentDetailInfo(int tempDocumentId) {
// TODO: implement getTempDocumentDetailInfo
    throw UnimplementedError();
  }

  @override
  Future<void> updateTempDocumentInfo(TempDocument tempDocument) {
// TODO: implement updateTempDocumentInfo
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTempDocumentData(int tempDocumentId) {
// TODO: implement deleteTempDocumentData
    throw UnimplementedError();
  }

  @override
  Future<void> addDocument({
    required DateTime date,
    required DocumentType type,
    required int companyId,
    required List<Record> recordList,
  }) async {
    return await _remoteDataSource.addDocument(
      date: date,
      type: type,
      companyId: companyId,
      recordList: recordList,
    );
  }

  @override
  Future<DocumentList> getDocumentList(
      {String? searchValue, // 검색 키워드 (제목 기반)
      DocumentListSortType? sortType,
      String? orderType,
      int? size,
      int? page,
      int? year,
      int? month}) async {
    return await _remoteDataSource.getDocumentList(
      searchValue: searchValue,
      sortType: sortType,
      orderType: orderType,
      size: size,
      page: page,
      year: year,
      month: month,
    );
  }

  @override
  void getDocumentByComapny() {
// TODO: implement getDocumentByComapny
  }

  @override
  Future<DocumentDetail> getDocumentDetailInfo(int documentId) async {
    return await _remoteDataSource.getDocumentDetailInfoByDocumentId(documentId);
  }

  @override
  Future<void> updateDocumentInfo(DocumentDetail document) {
    return _remoteDataSource.updateDocument(document: document);
  }

  @override
  Future<void> deleteDcoumentData(int documentId) {
    return _remoteDataSource.deleteDocument(documentId);
  }
}
