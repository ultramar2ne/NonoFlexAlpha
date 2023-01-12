import 'package:nonoflex_alpha/model/data/record.dart';

/// 입고/ 출고 문서
class Document {
  /// 문서 고유 ID : documentId
  final int documentId;

  /// 입출고 날짜 : date
  final DateTime date;

  /// 문서 분류 : type
  final DocumentType docType;

  /// 거래처 이름 : company
  final String companyName;

  /// 문서 생성 시각 : createdAt
  final DateTime createdAt;

  /// 문서 수정 시각 : updatedAt
  final DateTime updatedAt;

  Document({
    required this.documentId,
    required this.date,
    required this.docType,
    required this.companyName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Document.fromJson(Map<String, dynamic> data) {
    final documentId = data['documentId'];
    final date = DateTime.parse(data['date']);
    final docType = DocumentType.getByServer(data['type']);
    final companyName = data['companyName'] ?? '알 수 없는 거래처';
    final createdAt = DateTime.parse(data['createdAt']);
    final updatedAt = DateTime.parse(data['updatedAt']);

    return Document(
      documentId: documentId,
      date: date,
      docType: docType,
      companyName: companyName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap({bool forServer = true}) {
    Map<String, dynamic> data = {};

    data.addAll({});

    return data;
  }
}

/// 입고/출고 문서 상세 정보
class DocumentDetail extends Document {
  /// 문서 고유 ID : documentId
  @override
  final int documentId;

  /// 입출고 날짜 : date
  @override
  final DateTime date;

  /// 문서 분류 : type
  @override
  final DocumentType docType;

  /// 거래처 이름 : companyName
  @override
  final String companyName;

  /// 거래처 Id : companyId
  final int companyId;

  /// 문서 생성 시각 : createdAt
  @override
  final DateTime createdAt;

  /// 문서 수정 시각 : updatedAt
  @override
  final DateTime updatedAt;

  /// 문서 작성자 이름 : writer
  final String writer;

  /// 문서 작성자 Id : writerId
  final int writerId;

  /// 문서 record 개수 : recordCount
  final int recordCount;

  /// 문서 record 전체 가격 : totalPrice
  final double totalPrice;

  /// record 목록 : recordList
  final List<RecordOfDocument> recordList;

  DocumentDetail({
    required this.documentId,
    required this.date,
    required this.docType,
    required this.companyName,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
    required this.writer,
    required this.writerId,
    required this.recordCount,
    required this.totalPrice,
    required this.recordList,
  }) : super(
          documentId: documentId,
          date: date,
          docType: docType,
          companyName: companyName,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  DocumentDetail copyWith({
    int? documentId,
    DateTime? date,
    DocumentType? docType,
    String? companyName,
    int? companyId,
    // createdAt,
    // updatedAt,
    // String? writer,
    // int? writerId,
    // int? recordCount,
    // double? totalPrice,
    List<RecordOfDocument>? recordList,
  }) {
    return DocumentDetail(
      documentId: documentId ?? this.documentId,
      date: date ?? this.date,
      docType: docType ?? this.docType,
      companyName: companyName ?? this.companyName,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      writer: writer,
      writerId: writerId,
      recordCount: recordCount,
      totalPrice: totalPrice,
      recordList: recordList ?? this.recordList,
    );
  }

  factory DocumentDetail.fromJson(Map<String, dynamic> data) {
    final documentId = data['documentId'];
    final date = DateTime.parse(data['date']);
    final docType = DocumentType.getByServer(data['type']);
    final companyName = data['companyName'] ?? '알 수 없는 거래처';
    final companyId = data['companyId'] ?? -1;
    final createdAt = DateTime.parse(data['createdAt']);
    final updatedAt = DateTime.parse(data['updatedAt']);
    final writer = data['writer'] ?? '알 수 없는 사용자';
    final writerId = data['writerId'] ?? -1;
    final recordCount = data['recordCount'];
    final totalPrice = data['totalPrice'];
    final recordList = data['recordList'];

    return DocumentDetail(
      documentId: documentId,
      date: date,
      docType: docType,
      companyName: companyName,
      companyId: companyId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      writer: writer,
      writerId: writerId,
      recordCount: recordCount,
      totalPrice: totalPrice,
      recordList: recordList
          .map<RecordOfDocument>(
              (el) => RecordOfDocument.fromJson(el as Map<String, dynamic>, documentId))
          .toList(),
    );
  }
}

/// 입고// 출고 문서 목록
class DocumentList {
  // 현재 페이지 : page
  final int page;

  // : count
  final int count;

  // : totalPages
  final int totalPages;

  // : totalCount
  final int totalCount;

  // : lastPage
  final bool isLastPage;

  // 문서 목록 : documentList
  // final List<Document> items;
  final List<DocumentDetail> items;

  DocumentList(
      {required this.page,
      required this.count,
      required this.totalPages,
      required this.totalCount,
      required this.isLastPage,
      required this.items});

  factory DocumentList.fromJson(Map<String, dynamic> data) {
    final metaData = data['meta'];
    final items = data['documentList'];

    return DocumentList(
        page: metaData['page'],
        count: metaData['count'],
        totalPages: metaData['totalPages'],
        totalCount: metaData['totalCount'],
        isLastPage: metaData['lastPage'],
        items: items
            .map<DocumentDetail>((el) => DocumentDetail.fromJson(el as Map<String, dynamic>))
            .toList());
  }
}

/// 임시 입고 / 출고 문서
/// 실제 재고에 반영되지 않고 휘발성을 가진다.
/// 참여자는 해당 문서를 기반으로 문서 작성을 진행할 수 있다.
class TempDocument {}

/// 임시 임고 / 출고 문서 목록
class TempDocumentList {}

/// 문서 타입
enum DocumentType {
  input('input', 'INPUT'),
  output('output', 'OUTPUT'),
  tempInput('input', 'INPUT'),
  tempOutput('output', 'OUTPUT');

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
      case DocumentType.tempInput:
        return '입고 예정서';
      case DocumentType.tempOutput:
        return '출고 예정서';
    }
  }
}

enum DocumentListSortType {
  type('', 'type'),
  company('', 'company'),
  createdAt('', 'createdAt'),
  date('', 'date');

  const DocumentListSortType(this.code, this.serverValue);

  final String code;
  final String serverValue;

  factory DocumentListSortType.fromServer(String serverValue) {
    return DocumentListSortType.values.firstWhere((value) => value.serverValue == serverValue,
        orElse: () => DocumentListSortType.createdAt);
  }
}

extension DocumentListSortTypeExt on DocumentListSortType {}
