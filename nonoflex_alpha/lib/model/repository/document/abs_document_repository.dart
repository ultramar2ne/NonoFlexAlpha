import 'package:nonoflex_alpha/model/data/document.dart';

abstract class DocumentRepository {
  /// temp Doc
  // 임시 문서 추가
  Future<void> addTempDocument(TempDocument tempDocument);

  // 임시 문서 목록 조회
  Future<TempDocumentList> getTempDocumentList();

  // 임시 문서 상세 정보 조회
  Future<TempDocument> getTempDocumentDetailInfo(int tempDocumentId);

  // 임시 문서 정보 수정
  Future<void> updateTempDocumentInfo(TempDocument tempDocument);

  // 임시 문서 삭제
  Future<void> deleteTempDocumentData(int tempDocumentId);

  /// Doc
  // 문서 추가
  Future<void> addDocument(Document document);

  // 문서 목록 조회
  Future<DocumentList> getDocumentList();

  // 거래처 별 문서 목록 조회
  void getDocumentByComapny();

  // 문서 상세 정보 조회
  Future<Document> getDocumentDetailInfo(int documentId);

  // 문서 정보 수정
  Future<void> updateDocumentInfo(Document document);

  // 문서 정보 삭제
  Future<void> deleteDcoumentData(int documentId);
}
