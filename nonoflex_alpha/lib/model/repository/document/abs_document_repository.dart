abstract class DocumentRepository {

  /// temp Doc
  // 임시 문서 추가
  void addTempDocument();

  // 임시 문서 목록 조회
  void getTempDocumentList();

  // 임시 문서 상세 정보 조회
  void getTempDocumentDetailInfo();

  // 임시 문서 정보 수정
  void updateTempDocumentInfo();

  // 임시 문서 삭제
  void deleteTempDocumentData();

  /// Doc
  // 문서 추가
  void addDocument();

  // 문서 목록 조회
  void getDocumentList();

  // 거래처 별 문서 목록 조회
  void getDocumentByComapny();

  // 문서 상세 정보 조회
  void getDocumentDetailInfo();

  // 문서 정보 수정
  void updateDocumentInfo();

  // 문서 정보 삭제
  void deleteDcoumentData();
}
