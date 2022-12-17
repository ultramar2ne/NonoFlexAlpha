/// 입고/ 출고 문서
class Document {

}

/// 입고// 출고 문서 목록
class DocumentList {

}

/// 임시 입고 / 출고 문서
/// 실제 재고에 반영되지 않고 휘발성을 가진다.
/// 참여자는 해당 문서를 기반으로 문서 작성을 진행할 수 있다.
class TempDocument {

}

/// 임시 임고 / 출고 문서 목록
class TempDocumentList {

}

/// 문서 타입
enum DocumentType {
  input('input', 'INPUT'),
  output('OUTPUT', 'OUTPUT');

  const DocumentType(this.code, this.serverValue);

  final String code;
  final String serverValue;

  factory DocumentType.getByServer(String serverValue) {
    return DocumentType.values
        .firstWhere((value) => value.serverValue == serverValue, orElse: () => DocumentType.input);
  }
}

extension DocumentTypeExt on DocumentType {
  String get displayName {
    switch (this) {
      case DocumentType.input:
        return '입고서';
      case DocumentType.output:
        return '출고서';
    }
  }
}
